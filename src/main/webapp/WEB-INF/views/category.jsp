<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Add Category</title>
    <style>
        .form-container {
            width: 400px;
            margin: 40px auto;
            padding: 20px;
            border-radius: 8px;
            background: #ffffff;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
        }
        input, select, button {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
        }
        button {
            margin-top: 15px;
            background-color: #0d6efd;
            color: white;
            border: none;
            cursor: pointer;
        }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<div class="form-container">
    <h2>Add Category</h2>

    <form action="${pageContext.request.contextPath}/category/save" method="post">

        <label>Category Name</label>
        <input type="text" name="name" required />

        <label>Type</label>
        <select name="type" required>
            <option value="">-- Select Type --</option>
            <option value="INCOME">INCOME</option>
            <option value="EXPENSE">EXPENSE</option>
        </select>

        <button type="submit">Add Category</button>
    </form>
</div>

</body>
</html>
