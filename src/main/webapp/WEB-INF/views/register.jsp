<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register</title>

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

    .register-container {
        background-color: #ffffff;
        padding: 30px;
        width: 350px;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }

    .register-container h2 {
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

    .error {
        color: red;
        font-size: 13px;
        display: none;
    }

    .register-btn {
        width: 100%;
        padding: 10px;
        background-color: #007bff;
        color: white;
        border: none;
        border-radius: 4px;
        font-size: 16px;
        cursor: pointer;
    }

    .register-btn:hover {
        background-color: #0056b3;
    }
</style>

<script>
    function validatePasswords() {
        var password = document.getElementById("password").value;
        var confirmPassword = document.getElementById("confirmPassword").value;
        var errorMsg = document.getElementById("errorMsg");

        if (password !== confirmPassword) {
            errorMsg.style.display = "block";
            errorMsg.innerText = "Passwords do not match!";
            return false; // stop form submission
        }

        errorMsg.style.display = "none";
        return true; // allow form submission
    }
</script>

</head>
<body>

<div class="register-container">
    <h2>Register</h2>

    <form action="register" method="post" onsubmit="return validatePasswords()">

        <div class="form-group">
            <label>Full Name</label>
            <input type="text" name="name" placeholder="Enter full name" required>
        </div>

        <div class="form-group">
            <label>Email Address</label>
            <input type="email" name="email" placeholder="Enter email" required>
        </div>

        <div class="form-group">
            <label>Password</label>
            <input type="password" id="password" name="password" placeholder="Enter password" required>
        </div>

        <div class="form-group">
            <label>Confirm Password</label>
            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm password" required>
            <span id="errorMsg" class="error"></span>
        </div>

        <button type="submit" class="register-btn">Register</button>
          <a href="login">Already Registered ? Login Here</a>
    </form>
</div>

</body>
</html>
