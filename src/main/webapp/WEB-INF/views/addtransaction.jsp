<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Transaction</title>

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
	    font-size: 28px;
	    font-weight: 700;
	    color: #1e293b;
	    margin-bottom: 6px;
	}

	.page-subtitle {
	    text-align: center;
	    color: #64748b;
	    margin-bottom: 32px;
	    font-size: 14px;
	}

	.transaction-card {
	    max-width: 520px;
	    margin: 0px auto;
	    padding: 42px 38px 46px;
	    background: #ffffff;
	    border-radius: 20px;
	    box-shadow: 0 25px 55px rgba(0,0,0,0.14);
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
</style>
</head>

<body>

<jsp:include page="navbar.jsp" />

<%
java.util.List<com.pfm.entity.Category> ctgs =
    (java.util.List<com.pfm.entity.Category>) request.getAttribute("categories");
%>

<div class="page-container">

    <div class="transaction-card">
		<div class="page-title">Add Transaction</div>
		<div class="page-subtitle">Add a new transaction to track your spending</div>

        <form action="addtransaction" method="post">

            <div class="form-group">
                <label>Amount</label>
                <input type="number" name="amount" required>
            </div>

            <div class="form-group">
                <label>Description</label>
                <input type="text" name="description">
            </div>

            <div class="form-group">
                <label>Date</label>
                <input type="date" name="date" required>
            </div>

            <div class="form-group">
                <label>Category</label>
                <select name="catId" required>
                    <option value="">Select Category</option>
                    <%
                    if (ctgs != null && !ctgs.isEmpty()) {
                        for (com.pfm.entity.Category c : ctgs) {
                    %>
                        <option value="<%=c.getId()%>"><%=c.getName()%></option>
                    <%
                        }
                    } else {
                    %>
                        <option disabled>No Categories Found</option>
                    <%
                    }
                    %>
                </select>
            </div>

            <button class="save-btn">Save Transaction</button>
        </form>
    </div>

</div>

</body>
</html>
