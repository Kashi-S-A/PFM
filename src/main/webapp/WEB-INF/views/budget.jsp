<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Budget</title>

<style>
    body {
        margin: 0;
        font-family: 'Segoe UI', system-ui, sans-serif;
        background: #eef2f7;
        min-height: 100vh;
    }

	.page-container {
	    max-width: 1200px;
	    margin: 40px auto;
	    padding: 0;
	    background: transparent;  
	    border-radius: 0;
	    box-shadow: none;
	}


    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(15px); }
        to   { opacity: 1; transform: translateY(0); }
    }

    .page-title {
        text-align: center;
        font-size: 30px;
        font-weight: 700;
        color: #1e293b;
        margin-bottom: 6px;
    }

    .page-subtitle {
        text-align: center;
        color: #64748b;
        margin-bottom: 45px;
    }

	.budget-card {
	    max-width: 700px;
	    margin: 60px auto;
	    padding: 42px 40px 48px;
	    background: #ffffff;
	    border-radius: 22px;
	    box-shadow: 0 28px 60px rgba(0,0,0,0.14);
	}


    .budget-form {
        width: 100%;
    }

    .form-group {
        margin-bottom: 20px;
    }

    .form-group label {
        display: block;
        font-weight: 600;
        margin-bottom: 6px;
        color: #334155;
    }

    .form-group input,
    .form-group select {
        width: 100%;
        height: 46px;
        padding: 0 14px;
        border-radius: 10px;
        border: 1px solid #e2e8f0;
        font-size: 14px;
        background-color: #ffffff;
        box-sizing: border-box;
    }

    .form-group select {
        appearance: none;
        -webkit-appearance: none;
        -moz-appearance: none;
        background-image:
            url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='%2364748b' viewBox='0 0 16 16'%3E%3Cpath d='M1.5 5.5l6 6 6-6'/%3E%3C/svg%3E");
        background-repeat: no-repeat;
        background-position: right 14px center;
        background-size: 14px;
        padding-right: 42px;
    }

    .form-group input:focus,
    .form-group select:focus {
        border-color: #0d6efd;
        box-shadow: 0 0 0 2px rgba(13,110,253,0.15);
        outline: none;
    }

    .save-btn {
        width: 100%;
        height: 46px;
        border-radius: 10px;
        border: none;
        background: linear-gradient(135deg, #0d6efd, #003d99);
        color: #fff;
        font-size: 15px;
        font-weight: 600;
        cursor: pointer;
        margin-top: 8px;
    }

    .table-wrapper {
        border-radius: 16px;
        overflow: hidden;
        box-shadow: 0 12px 28px rgba(0,0,0,0.08);
        background: #ffffff;
    }

    table {
        width: 100%;
        border-collapse: collapse;
    }

    thead {
        background: linear-gradient(135deg, #1e3a8a, #2563eb);
    }

    thead th {
        color: white;
        padding: 14px;
        text-align: center;
        font-size: 14px;
    }

    tbody td {
        padding: 14px;
        text-align: center;
        border-bottom: 1px solid #e2e8f0;
        color: #475569;
        font-size: 14px;
    }

    tbody tr:nth-child(even) {
        background: #f8fafc;
    }

    .no-budget {
        color: #64748b;
        font-weight: 500;
        padding: 18px;
    }
</style>
</head>

<body>

<jsp:include page="navbar.jsp" />

<div class="page-container">
    <!-- FLOATING FORM CARD -->
    <div class="budget-card">
		<div class="page-title">Monthly Budget</div>
		<div class="page-subtitle">Track and control your spending goals</div>

        <form class="budget-form" action="saveBudget" method="post">

            <div class="form-group">
                <label>Month</label>
                <select name="month" required>
                    <option value="">Select Month</option>
                    <option value="1">January</option>
                    <option value="2">February</option>
                    <option value="3">March</option>
                    <option value="4">April</option>
                    <option value="5">May</option>
                    <option value="6">June</option>
                    <option value="7">July</option>
                    <option value="8">August</option>
                    <option value="9">September</option>
                    <option value="10">October</option>
                    <option value="11">November</option>
                    <option value="12">December</option>
                </select>
            </div>

            <div class="form-group">
                <label>Year</label>
                <select name="year" required>
                    <option value="">Select Year</option>
                    <option>2024</option>
                    <option>2025</option>
                    <option>2026</option>
                </select>
            </div>

            <div class="form-group">
                <label>Category</label>
                <select name="categoryId" required>
                    <option value="">Select Category</option>
                    <option value="1">Food</option>
                    <option value="2">Rent</option>
                    <option value="3">Shopping</option>
                    <option value="4">Movie</option>
                    <option value="5">Salary</option>
                    <option value="6">Travel</option>
                    <option value="7">EMI</option>
                    <option value="8">Mobile Recharge</option>
                    <option value="9">Bills</option>
                    <option value="10">Other Expense</option>
                    <option value="11">Other Income</option>
                </select>
            </div>

            <div class="form-group">
                <label>Amount</label>
                <input type="number" name="amount" placeholder="Enter amount" required>
            </div>

            <button class="save-btn">Save Budget</button>
        </form>
    </div>

    <div class="table-wrapper">
        <table>
            <thead>
                <tr>
                    <th>Month</th>
                    <th>Year</th>
                    <th>Category</th>
                    <th>Amount</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td colspan="4" class="no-budget">Budgets Do Not Exist</td>
                </tr>
            </tbody>
        </table>
    </div>

</div>

</body>
</html>
