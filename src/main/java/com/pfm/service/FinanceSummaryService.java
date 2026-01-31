package com.pfm.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import com.pfm.dto.FinanceSummary;
import com.pfm.entity.Budget;
import com.pfm.entity.Transaction;
import com.pfm.entity.TxnType;
import com.pfm.repo.BudgetRepo;
import com.pfm.repo.TransactionRepo;

@Service
public class FinanceSummaryService {

	@Autowired
	private TransactionRepo transactionRepo;
	@Autowired
	private BudgetRepo budgetRepo;
	
    // cache per user 
	@Cacheable(value = "financeSummary", key = "#uid")
	public FinanceSummary getSummary(Integer uid) {
		
		 List<Transaction> txns = transactionRepo.findByUserId(uid);
		 List<Budget> budgets = budgetRepo.findByUserId(uid);
		 
		 double totalIncome = 0.0, totalExpense = 0.0;
		 
		 Map<String, Double> incomeByCat = new HashMap<>();
		 Map<String, Double> expenseByCat = new HashMap<>();
		 
		 for(Transaction t:txns) {
			 String catName = (t.getCategory() != null) ? t.getCategory().getName() : "Uncategorized";
			 TxnType type = (t.getCategory() != null && t.getCategory().getType() != null) 
					 	? t.getCategory().getType()
                        : TxnType.EXPENSE;
			 
			 double amt = t.getAmount();
			 
			 if(type == TxnType.INCOME) {
				 totalIncome += amt;
				 incomeByCat.put(catName, incomeByCat.getOrDefault(catName, 0.0) + amt);
			 } else {
				 totalExpense += amt;
				 expenseByCat.put(catName, expenseByCat.getOrDefault(catName, 0.0) + amt);
			 }
		 }
		 
		// sort top to bottom
		 StringBuilder incomeSummary = new StringBuilder();
		 incomeByCat.entrySet().stream()
		 			.sorted((a,b) -> Double.compare(b.getValue(), a.getValue()))
		 			.forEach(e -> incomeSummary.append(e.getKey())
		 					.append(": ₹").append(String.format("%,.2f", e.getValue())).append("\n"));
		
		 StringBuilder expenseSummary = new StringBuilder();
		 expenseByCat.entrySet().stream()
		 			.sorted((a,b) -> Double.compare(b.getValue(), a.getValue()))
		 			.forEach(e -> expenseSummary.append(e.getKey())
		 					.append(": ₹").append(String.format("%,.2f", e.getValue())).append("\n"));        
		 
	        StringBuilder budgetSummary = new StringBuilder();
	        if(budgets != null && !budgets.isEmpty()) {
	        	for(Budget b : budgets) {
	        		String bcat = (b.getCategory() != null) ? b.getCategory().getName() : "Unknown";
	        		budgetSummary.append(bcat)
	        					.append(": ₹").append(String.format("%,.2f", b.getAmount()))
	        					.append(" (").append(b.getMonth()).append(" ").append(b.getYear()).append(")")
	        					.append("\n");
	        	}
	        } else {
	        	budgetSummary.append("Not Available\n");
	        }
	        
	// ===== Budget vs Actual (current month/year) =====
	        java.time.YearMonth now = java.time.YearMonth.now();
	        int m = now.getMonthValue();
	        int y = now.getYear();
	        
	        Map<String, Double> actualThisMonthByCat = new HashMap<>();
	        for (Transaction t : txns) {
	            if (t.getDate() == null) continue;
	            if (t.getDate().getMonthValue() != m || t.getDate().getYear() != y) continue;

	            TxnType type = (t.getCategory() != null && t.getCategory().getType() != null)
	                    ? t.getCategory().getType()
	                    : TxnType.EXPENSE;
	            if (type != TxnType.EXPENSE) continue;

	            String catName = (t.getCategory() != null) ? t.getCategory().getName() : "Uncategorized";
	            actualThisMonthByCat.put(catName, actualThisMonthByCat.getOrDefault(catName, 0.0) + t.getAmount());
	        }

	        StringBuilder budgetVsActual = new StringBuilder();
	        StringBuilder overspend = new StringBuilder();

	        if (budgets != null && !budgets.isEmpty()) {
	            for (Budget b : budgets) {
	                if (b.getMonth() != m || b.getYear() != y) continue;

	                String cat = (b.getCategory() != null) ? b.getCategory().getName() : "Unknown";
	                double budgetAmt = b.getAmount();
	                double actualAmt = actualThisMonthByCat.getOrDefault(cat, 0.0);
	                double diff = budgetAmt - actualAmt;

	                String status = (diff >= 0) ? "✅ Within" : "⚠️ Over";
	                budgetVsActual.append(cat)
	                        .append(": Budget ₹").append(String.format("%,.2f", budgetAmt))
	                        .append(" | Spent ₹").append(String.format("%,.2f", actualAmt))
	                        .append(" | ").append(status)
	                        .append("\n");

	                if (diff < 0) {
	                    overspend.append(cat)
	                            .append(": Over by ₹").append(String.format("%,.2f", Math.abs(diff)))
	                            .append("\n");
	                }
	            }
	        } else {
	            budgetVsActual.append("Not Available\n");
	            overspend.append("Not Available\n");
	        }

	        // ===== Trend (this month vs last month total expense) =====
	        java.time.YearMonth last = now.minusMonths(1);
	        double thisMonthExpense = 0.0;
	        double lastMonthExpense = 0.0;

	        for (Transaction t : txns) {
	            if (t.getDate() == null) continue;
	            TxnType type = (t.getCategory() != null && t.getCategory().getType() != null)
	                    ? t.getCategory().getType()
	                    : TxnType.EXPENSE;
	            if (type != TxnType.EXPENSE) continue;

	            var ym = java.time.YearMonth.from(t.getDate());
	            if (ym.equals(now)) thisMonthExpense += t.getAmount();
	            if (ym.equals(last)) lastMonthExpense += t.getAmount();
	        }

	        StringBuilder trend = new StringBuilder();
	        trend.append("This month: ₹").append(String.format("%,.2f", thisMonthExpense)).append("\n")
	             .append("Last month: ₹").append(String.format("%,.2f", lastMonthExpense)).append("\n");

	        // ===== Chart explanation data (text) =====
	        StringBuilder charts = new StringBuilder();
	        charts.append("1) Income vs Expense (bar): compares total income and expense.\n")
	              .append("2) Category-wise Spending (pie): shows which categories take most expense.\n")
	              .append("3) Monthly Trend (line): compares this month vs last month expense.\n")
	              .append("4) Budget vs Actual (bars): shows category budget vs spent, within/over.\n");

	        double net = totalIncome - totalExpense;
	        
	     // ✅ LIMIT TEXT (keeps prompt small + fast)
	        String income = topNLines(incomeSummary.toString(), 5);
	        String expense = topNLines(expenseSummary.toString(), 8);
	        String budget = topNLines(budgetSummary.toString(), 8);

	        // ✅ also trim other long blocks (recommended)
	        String budgetVsActualTrim = topNLines(budgetVsActual.toString(), 8);
	        String overspendTrim = topNLines(overspend.toString(), 5);
	        String trendTrim = topNLines(trend.toString(), 6);

	        return new FinanceSummary(
	        	    totalIncome, totalExpense, net,
	        	    income,
	        	    expense,
	        	    budget,
	        	    budgetVsActualTrim,
	        	    overspendTrim,
	        	    trendTrim,
	        	    charts.toString()
	        	);
	    }
	
	private String topNLines(String text, int n) {
	    if (text == null) return "";
	    String[] lines = text.split("\n");
	    StringBuilder sb = new StringBuilder();
	    int count = 0;

	    for (String line : lines) {
	        if (line == null) continue;
	        line = line.trim();
	        if (line.isEmpty()) continue;

	        sb.append(line).append("\n");
	        count++;

	        if (count >= n) break;
	    }
	    return sb.toString();
	}

	  
	 // When user adds/updates/deletes txn or budget, clear cache
	 @CacheEvict(value = "financeSummary", key = "#uid")
	 public void evictSummary(Integer uid) {
		 
	 }
}