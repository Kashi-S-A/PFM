<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Transactions</title>

<style>
    body {
        margin: 0;
        font-family: 'Segoe UI', system-ui, sans-serif;
        background: linear-gradient(180deg, #eef2f7, #f8fafc);
        min-height: 100vh;
    }

	.page-container {
	    max-width: 1200px;
	    margin: 0px auto;
	    padding: 40px;
	    background: transparent;   
	    border-radius: 0;          
	    box-shadow: none;         
	}


    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(20px); }
        to   { opacity: 1; transform: translateY(0); }
    }

    .content-grid {
        display: grid;
        grid-template-columns: 280px 1fr;
        gap: 30px;
    }

	.filters-card {
	    background: #ffffff;
	    padding: 26px 22px;
	    border-radius: 18px;
	    box-shadow: 0 15px 35px rgba(0,0,0,0.12);
	}

	.filters-card h3 {
	    text-align: center;
	    color: #2563eb;
	    margin-bottom: 22px;
		margin-top:auto;
	    font-size: 25px;
	    font-weight: 700;
	}

	/* GROUP */
	.filter-group {
	    margin-bottom: 18px;
	}

	.filter-group label {
	    display: block;
	    font-weight: 600;
	    margin-bottom: 6px;
	    color: #334155;
	    font-size: 13px;
	}
	.filter-group select,
	.filter-group input {
	    width: 100%;
	    height: 44px;
	    padding: 0 14px;
	    border-radius: 10px;
	    border: 1px solid #e2e8f0;
	    font-size: 14px;
	    background: #ffffff;
	    box-sizing: border-box;
	}

	.filter-group input:focus,
	.filter-group select:focus {
	    border-color: #2563eb;
	    box-shadow: 0 0 0 2px rgba(37,99,235,0.15);
	    outline: none;
	}

	.type-buttons {
	    display: flex;
	    gap: 12px;
	}

	.type-btn {
	    flex: 1;
	    height: 42px;
	    border-radius: 10px;
	    border: none;
	    font-weight: 600;
	    font-size: 13px;
	    cursor: pointer;
	    background: #e0e7ff;
	    color: #1e3a8a;
	}

	.type-btn:hover {
	    background: #c7d2fe;
	}

	.apply-btn {
	    width: 100%;
	    height: 46px;
	    margin-top: 14px;
	    border-radius: 12px;
	    border: none;
	    background: linear-gradient(135deg, #2563eb, #1e3a8a);
	    color: #fff;
	    font-weight: 600;
	    font-size: 14px;
	    cursor: pointer;
	}

    .table-card {
        background: #ffffff;
        padding: 24px;
        border-radius: 18px;
        box-shadow: 0 12px 30px rgba(0,0,0,0.1);
    }

    .table-title {
        text-align: center;
        font-size: 20px;
        font-weight: 700;
        color: #2563eb;
        margin-bottom: 18px;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        border-radius: 14px;
        overflow: hidden;
    }

    thead {
        background: linear-gradient(135deg, #1e3a8a, #2563eb);
    }

    thead th {
        color: #ffffff;
        padding: 14px;
        font-size: 14px;
        text-align: center;
    }

    tbody td {
        padding: 14px;
        text-align: center;
        border-bottom: 1px solid #e2e8f0;
        font-size: 14px;
        color: #475569;
    }

    tbody tr:nth-child(even) {
        background: #f8fafc;
    }

    .no-data {
        color: #dc2626;
        font-weight: 600;
        padding: 20px;
    }
	
	.filter-group select {
	    appearance: none;
	    -webkit-appearance: none;
	    -moz-appearance: none;

	    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='14' height='14' fill='%2364738b' viewBox='0 0 16 16'%3E%3Cpath d='M1.5 5.5l6 6 6-6'/%3E%3C/svg%3E");
	    background-repeat: no-repeat;
	    background-position: right 14px center;
	    background-size: 14px;

	    padding-right: 42px; 
	}


</style>
</head>

<body>

<jsp:include page="navbar.jsp" />

<div class="page-container">

    <div class="content-grid">

		<form class="filters-card" action="filterTransactions" method="get">

		    <h3>Filters</h3>

		    <div class="filter-group">
		        <label>Type</label>
		        <div class="type-buttons">
		            <button type="submit" name="type" value="INCOME" class="type-btn">INCOME</button>
		            <button type="submit" name="type" value="EXPENSE" class="type-btn">EXPENSE</button>
		        </div>
		    </div>

		    <div class="filter-group">
		        <label>Category</label>
		        <select name="categoryId">
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

		    <div class="filter-group">
		        <label>From Date</label>
		        <input type="date" name="fromDate">
		    </div>

		    <div class="filter-group">
		        <label>To Date</label>
		        <input type="date" name="toDate">
		    </div>

		    <button class="apply-btn">Apply Filters</button>
		</form>


        <!-- RIGHT TABLE -->
        <div class="table-card">
            <div class="table-title">Monthly Transactions</div>

            <table>
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Description</th>
                        <th>Category</th>
                        <th>Type</th>
                        <th>Amount</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td colspan="6" class="no-data">No Transactions Found</td>
                    </tr>
                </tbody>
            </table>
        </div>

    </div>

</div>

</body>
</html>
