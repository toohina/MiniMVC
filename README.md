javac -cp "C:\Program Files\Apache Software Foundation\Tomcat 11.0\lib\servlet-api.jar" -d WEB-INF\classes src\model\User.java src\controller\HelloServlet.java

💡 What it's doing (broken down):
Part	Meaning
javac	Java Compiler — compiles .java files into .class bytecode
-cp "..."	-cp stands for classpath. You’re telling javac where to find external classes used in your code. Here, you're including servlet-api.jar which has HttpServlet, HttpServletRequest, etc.
"C:\Program Files\Apache Software Foundation\Tomcat 11.0\lib\servlet-api.jar"	This is the path to the servlet library provided by Tomcat. Without this, you’ll get cannot find symbol: HttpServlet errors.
-d WEB-INF\classes	This tells javac: “Put the compiled .class files here.” So the output will be placed in WEB-INF\classes\model\ and controller\.
src\model\User.java src\controller\HelloServlet.java	These are the source files you're compiling. Your actual code.

✅ So what happens when you run this?
It compiles both your Java files
It uses the Servlet API from Tomcat to understand HttpServlet classes

It outputs:
WEB-INF\classes\model\User.class
WEB-INF\classes\controller\HelloServlet.class
This is the required structure for Tomcat to run your web app properly.

---------------------------------------------------------------------------------------------------
❌ What’s the error?
Your compiler is shouting:
cannot find symbol: HttpServlet, ServletException, HttpServletRequest, etc.
This means it cannot find the servlet classes — and the root cause is:

🚨 You're using javax.servlet.*, but compiling against Tomcat 11, which uses jakarta.servlet.*.
Starting from Tomcat 10+, the entire Servlet API moved from:

Old package	➡️	New package
javax.servlet.*	➡️	jakarta.servlet.*
javax.servlet.http.*	➡️	jakarta.servlet.http.*
javax.servlet.annotation.*	➡️	jakarta.servlet.annotation.*

✅ ✅ ✅ FIX: Update Your Imports to jakarta.*
Change the top of your HelloServlet.java from this:

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

To this:
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
✅ Now your code matches the Servlet 6.1 API used in Tomcat 11.

⚠️ Also — Do you need @WebServlet?
You're using:
@WebServlet("/hello")
But if you already have web.xml doing servlet mapping, you can remove this annotation entirely.

So either:
Keep the annotation and remove servlet mapping in web.xml, OR
Use web.xml only and remove @WebServlet from the servlet.

For now, since you're using web.xml, remove this line:
@WebServlet("/hello")

--------------------------------------------------------------------------------------------

📦 ▶️ Step 1:Move the Whole MiniMVC/ Folder into Tomcat
You don’t need to rename anything now. Simply copy your full MiniMVC folder as-is into:
C:\Program Files\Apache Software Foundation\Tomcat 11.0\webapps\
So final structure will be:
Tomcat 11.0/
└── webapps/
    └── MiniMVC/
        ├── hello.jsp
        ├── src/
        ├── WEB-INF/
        │   ├── web.xml
        │   └── classes/
        │       ├── model/User.class
        │       └── controller/HelloServlet.class
✅ src/ folder can stay — Tomcat will ignore it. What it cares about is:
WEB-INF/classes/...
hello.jsp
web.xml

▶️ Step 2: Start Tomcat
Navigate to:
C:\Program Files\Apache Software Foundation\Tomcat 11.0\bin
Then run:
startup.bat

If you see port 8080 occupied:
🔁 Option 1: Kill Whatever is Using Port 8080
Open CMD and run:
netstat -ano | findstr :8080
You'll see something like:
TCP    0.0.0.0:8080     ...     LISTENING     12345
That last number (e.g., 12345) is the PID of the process using the port.

Then kill it:
taskkill /PID 12345 /F
Now re-run:
startup.bat
Tomcat will now own port 8080 cleanly. ✅

🔁 Option 2: Change Tomcat’s Port (if you don’t want to kill anything)
Open:
C:\Program Files\Apache Software Foundation\Tomcat 11.0\conf\server.xml
Find this line:
<Connector port="8080" protocol="HTTP/1.1"
Change the port to something like 8085:
<Connector port="8085" protocol="HTTP/1.1"
Save the file, then re-run:
startup.bat
Now your app will run on:
http://localhost:8085/MiniMVC/hello
🔥 Now: Open in Browser
Either:
http://localhost:8080/MiniMVC/hello
or (if you changed port):
http://localhost:8085/MiniMVC/hello

-----------------------------------------------------------------------------------------------------------
C:\Program Files\Apache Software Foundation\Tomcat 11.0\bin>taskkill /PID 7368 /F
ERROR: The process with PID 7368 could not be terminated.
Reason: Access is denied.

✅ Step-by-Step: Kill Process with Admin Access
🔹 Step 1: Open CMD as Administrator
Press Windows key
Type: cmd
Right-click on Command Prompt
Click “Run as administrator”
You’ll get a black terminal with admin access.

🔹 Step 2: Run the Kill Command Again
Now type:
taskkill /PID 7368 /F
✔️ This time it will work because you're running as admin.

🔹 Step 3: Restart Tomcat
Now run:
cd "C:\Program Files\Apache Software Foundation\Tomcat 11.0\bin"
startup.bat
Your Tomcat should now launch cleanly without the "port in use" error 🎉

-------------------------------------------------------------------------------------

🧠 What This Means
xml
Copy
Edit
<servlet>
    <servlet-name>HelloServlet</servlet-name>
    <servlet-class>controller.HelloServlet</servlet-class>
</servlet>

<servlet-mapping>
    <servlet-name>HelloServlet</servlet-name>
    <url-pattern>/hello</url-pattern>
</servlet-mapping>
This does:
Tells Tomcat: “Load this Java class: controller.HelloServlet”

When the browser requests /hello, run that servlet

✅ So You Should Visit:
http://localhost:8080/MiniMVC/hello
That will:

Run HelloServlet

Create a User object (e.g., "Toohina")

Forward the request to hello.jsp

hello.jsp reads that User and says:

Hello, Toohina!
