<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Hello Page</title>
</head>
<body>
    <h1>Hello, <%= ((model.User)request.getAttribute("user")).getName() %>!</h1>
</body>
</html>
