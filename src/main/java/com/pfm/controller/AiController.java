package com.pfm.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.pfm.entity.Budget;
import com.pfm.entity.Transaction;
import com.pfm.entity.TxnType;
import com.pfm.entity.User;
import com.pfm.repo.BudgetRepo;
import com.pfm.repo.TransactionRepo;
import com.pfm.repo.UserRepo;
import com.pfm.service.AiService;

import jakarta.servlet.http.HttpSession;
import reactor.core.publisher.Flux;

@Controller
@RequestMapping("/ai")
public class AiController {

	@Autowired
	private AiService aiService;
	@Autowired
	private TransactionRepo transactionRepo;
	@Autowired
	private BudgetRepo budgetRepo;
	@Autowired
	private UserRepo userRepo;
	
    // ================= AI CHAT PAGE =================
	@GetMapping("/chat")
	public String chatPage() {
		return "ai-chat";
	}
	
    // ================= ASYNC AI CHAT =================
	@PostMapping("/ask-async")
	@ResponseBody
	public String askAsync(@RequestParam String question, Principal principal) {

	    if (principal == null) return "Please login again.";

	    String email = principal.getName();
	    User user = userRepo.findByEmail(email).orElse(null);
	    if (user == null) return "Please login again.";

	    Integer uid = user.getId();

	    // ✅ user-specific data
	    List<Transaction> txns = transactionRepo.findByUserId(uid);
	    List<Budget> budgets = budgetRepo.findByUserId(uid);

	    double totalIncome = 0.0;
	    double totalExpense = 0.0;

	    Map<String, Double> incomeByCat = new HashMap<>();
	    Map<String, Double> expenseByCat = new HashMap<>();

	    for (Transaction t : txns) {
	        String catName = (t.getCategory() != null) ? t.getCategory().getName() : "Uncategorized";

	        // ✅ enum type safe
	        TxnType type = (t.getCategory() != null && t.getCategory().getType() != null)
	                ? t.getCategory().getType()
	                : TxnType.EXPENSE;

	        double amt = t.getAmount();

	        if (type == TxnType.INCOME) {
	            totalIncome += amt;
	            incomeByCat.put(catName, incomeByCat.getOrDefault(catName, 0.0) + amt);
	        } else {
	            totalExpense += amt;
	            expenseByCat.put(catName, expenseByCat.getOrDefault(catName, 0.0) + amt);
	        }
	    }

	    // ✅ Budget summary
	    StringBuilder budgetSummary = new StringBuilder();
	    if (budgets != null && !budgets.isEmpty()) {
	        for (Budget b : budgets) {
	            String bcat = (b.getCategory() != null) ? b.getCategory().getName() : "Unknown";
	            budgetSummary.append(bcat)
	                    .append(": ₹")
	                    .append(String.format("%,.2f", b.getAmount()))
	                    .append(" (").append(b.getMonth()).append(" ").append(b.getYear()).append(")")
	                    .append("\n");
	        }
	    } else {
	        budgetSummary.append("Not available\n");
	    }

	    // ✅ expense summary (sorted desc)
	    StringBuilder expenseSummary = new StringBuilder();
	    expenseByCat.entrySet().stream()
	            .sorted((a, b) -> Double.compare(b.getValue(), a.getValue()))
	            .forEach(e -> expenseSummary.append(e.getKey())
	                    .append(": ₹").append(String.format("%,.2f", e.getValue()))
	                    .append("\n"));

	    // ✅ income summary (sorted desc)
	    StringBuilder incomeSummary = new StringBuilder();
	    incomeByCat.entrySet().stream()
	            .sorted((a, b) -> Double.compare(b.getValue(), a.getValue()))
	            .forEach(e -> incomeSummary.append(e.getKey())
	                    .append(": ₹").append(String.format("%,.2f", e.getValue()))
	                    .append("\n"));

	    String prompt = """
	    You are a Personal Finance Assistant for an Indian user. Currency is INR (₹).
	    Use ONLY the data below. DO NOT guess anything.

	    Greeting rule:
	    If the user message is only a greeting (hi/hello/hey), respond:
	    Hello %s 👋 Welcome to your Personal Finance Assistant.
	    What would you like to do today?
	    • 📌 Expense summary (this month)
	    • 🧾 Budget status (within/over)
	    • 💡 Savings tips
	    (Stop.)

	    Answering rules:
	    - Answer ONLY what the user asked.
	    - Use EXPENSE_DATA for expenses, INCOME_DATA for income, BUDGET_DATA for budgets.
	    - Only give 2 actionable suggestions if user asks for advice/tips/save/reduce.

	    Output format:
	    - Headings + bullets (no long paragraphs)
	    - Money format ₹43,947.00

	    DATA:
	    INCOME_TOTAL: ₹%s
	    EXPENSE_TOTAL: ₹%s
	    NET_SAVINGS: ₹%s

	    INCOME_DATA:
	    %s

	    EXPENSE_DATA:
	    %s

	    BUDGET_DATA:
	    %s

	    User Question: %s
	    Return plain text only.
	    """.formatted(
	            user.getName(),
	            String.format("%,.2f", totalIncome),
	            String.format("%,.2f", totalExpense),
	            String.format("%,.2f", (totalIncome - totalExpense)),
	            incomeSummary.toString(),
	            expenseSummary.toString(),
	            budgetSummary.toString(),
	            question
	    );

	    return aiService.ask(prompt);
	}

	
    // ================= SMART CATEGORY =================
	@PostMapping("/suggest-category")
	@ResponseBody
	public String suggestCategory(@RequestParam String description) {
		
		String prompt = """
				Categorize this expense.
				Respond ONLY in this format:
				Category: <name>
				Type: Expense or Income
				
				Description: %s
				""".formatted(description);
		
		return aiService.ask(prompt);
	}
	
	
	@GetMapping(value="/ask-stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
	@ResponseBody
	public Flux<String> askStream(@RequestParam String question, Principal principal) {

		 if (principal == null) {
		        return Flux.just("Please login again.");
		    }

		    String email = principal.getName();
		    User user = userRepo.findByEmail(email).orElse(null);

		    if (user == null) {
		        return Flux.just("Please login again.");
		    }

		    Integer uid = user.getId();

		    List<Transaction> txns = transactionRepo.findByUserId(uid);		
		    List<Budget> budgets = budgetRepo.findByUserId(uid);


	    double totalIncome = 0.0;
	    double totalExpense = 0.0;
	    
	    Map<String, Double> incomeByCat = new HashMap<>();
	    Map<String, Double> expenseByCat = new HashMap<>();
	    
	    for (Transaction t : txns) {
	        String catName = (t.getCategory() != null)
	                ? t.getCategory().getName() : "Uncategorized";

	        TxnType type = (t.getCategory() != null)
	                ? t.getCategory().getType() : TxnType.EXPENSE; // default safe value

	        double amt = t.getAmount();

	        if (type == TxnType.INCOME) {
	            totalIncome += amt;
	            incomeByCat.put(catName,
	                    incomeByCat.getOrDefault(catName, 0.0) + amt);
	        } else {
	            totalExpense += amt;
	            expenseByCat.put(catName,
	                    expenseByCat.getOrDefault(catName, 0.0) + amt);
	        }
	    }

	    
        // Budgets summary
	    StringBuilder budgetSummary  = new StringBuilder();
	    if(budgets != null && !budgets.isEmpty()) {
	    	for(Budget b:budgets) {
	    		String bcat = (b.getCategory() != null) ? b.getCategory().getName() : "Unknown";
	    		budgetSummary.append(bcat)
	    					.append(": ₹")
	    					.append(String.format("%, .2f", b.getAmount()))
	    					.append(" (")
	    					.append(b.getMonth()).append(" ").append(b.getYear())
	    					.append(")\n");
	    	}
	    } else {
	    	budgetSummary.append("Not Available\n");
	    }
	    
        // Income/Expense category summaries
	    StringBuilder expenseSummary = new StringBuilder();
        expenseByCat.entrySet().stream()
                .sorted((a,b)-> Double.compare(b.getValue(), a.getValue()))
                .forEach(e -> expenseSummary.append(e.getKey())
                        .append(": ₹").append(String.format("%,.2f", e.getValue()))
                        .append("\n"));

        StringBuilder incomeSummary = new StringBuilder();
        incomeByCat.entrySet().stream()
                .sorted((a,b)-> Double.compare(b.getValue(), a.getValue()))
                .forEach(e -> incomeSummary.append(e.getKey())
                        .append(": ₹").append(String.format("%,.2f", e.getValue()))
                        .append("\n"));
        
        String prompt = """
        		You are a Personal Finance Assistant for an Indian user. Currency is INR (₹).
        		Use ONLY the data below. DO NOT guess anything.

        		Greeting rule:
        		If the user message is only a greeting (hi/hello/hey), respond EXACTLY:
        		Hello %s 👋 Welcome to your Personal Finance Assistant.
        		What would you like to do today?
        		• 📌 Expense summary (this month)
        		• 🧾 Budget status (within/over)
        		• 💡 Savings tips
        		(Stop.)

        		Answering rules:
        		- Answer ONLY what the user asked.
        		- If user asks about budgets -> use BUDGET_DATA.
        		- If user asks about expenses -> use EXPENSE_DATA.
        		- If user asks about income -> use INCOME_DATA.
        		- If user asks “is my finance good” -> use totals + net savings and explain briefly.
        		- Only give "2 actionable suggestions" when user asks for advice/tips/save/reduce.

        		Output format rules:
        		- Use short headings + bullets.
        		- Each bullet on new line.
        		- Avoid long paragraphs.
        		- Always format money like ₹43,947.00.

        		DATA:
        		INCOME_TOTAL: ₹%s
        		EXPENSE_TOTAL: ₹%s
        		NET_SAVINGS: ₹%s

        		INCOME_DATA:
        		%s

        		EXPENSE_DATA:
        		%s

        		BUDGET_DATA:
        		%s

        		User Question: %s
        		""".formatted(
        		        user.getName(),                              // ✅ greeting name
        		        String.format("%,.2f", totalIncome),
        		        String.format("%,.2f", totalExpense),
        		        String.format("%,.2f", (totalIncome - totalExpense)),
        		        incomeSummary.toString(),
        		        expenseSummary.toString(),
        		        budgetSummary.toString(),
        		        question
        		);

        return aiService.askStream(prompt);
	}
}