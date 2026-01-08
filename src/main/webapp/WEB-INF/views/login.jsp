<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login</title>

<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f6f8;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        margin: 0;
    }

    .login-container {
        background-color: #ffffff;
        padding: 30px;
        width: 350px;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }

    .login-container h2 {
        text-align: center;
        margin-bottom: 20px;
        color: #333;
    }

    .form-group {
        margin-bottom: 15px;
    }

    .form-group label {
        display: block;
        margin-bottom: 5px;
        font-weight: bold;
        color: #555;
    }

    .form-group input {
        width: 100%;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
        font-size: 14px;
    }

    .form-group input:focus {
        outline: none;
        border-color: #007bff;
    }

    .login-btn {
        width: 100%;
        padding: 10px;
        background-color: #007bff;
        color: white;
        border: none;
        border-radius: 4px;
        font-size: 16px;
        cursor: pointer;
    }

    .login-btn:hover {
        background-color: #0056b3;
    }

    .error {
        color: red;
        font-size: 13px;
        margin-bottom: 10px;
    }
</style>

</head>
<body>

<div class="login-container">
    <h2>Login</h2>

    <%-- Display error message if login fails --%>
    <h3 style="color: red">${error}</h3>
    <h3 style="color: green">${success}</h3>

    <form action="login" method="post">
        <div class="form-group">
            <label>Email ID</label>
            <input type="email" name="username" placeholder="Enter email" required>
        </div>

        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" placeholder="Enter password" required>
        </div>

        <button type="submit" class="login-btn">Login</button>
        <a href="register">Don't have an Account ? Register Now</a>
    </form>
</div>

</body>
</html>
