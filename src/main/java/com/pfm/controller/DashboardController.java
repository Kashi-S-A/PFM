package com.pfm.controller;

import java.security.Principal;
import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.pfm.entity.Budget;
import com.pfm.entity.Category;
import com.pfm.entity.Transaction;
import com.pfm.entity.TxnType;
import com.pfm.entity.User;
import com.pfm.repo.BudgetRepo;
import com.pfm.repo.CategoryRepo;
import com.pfm.repo.TransactionRepo;
import com.pfm.repo.UserRepo;

import jakarta.servlet.http.HttpSession;


@Controller
public class DashboardController {
	
	@Autowired
	private CategoryRepo categoryRepo;

	@Autowired
    private UserRepo userRepo;
	
	@Autowired
	private BudgetRepo budgetRepo;
	
	@Autowired
	private TransactionRepo transactionRepo;
	
	@GetMapping("/dashboard")
    public String dashboard(HttpSession session, Principal principal, Model model) {
		
        String email = principal.getName();        
        User user = userRepo.findByEmail(email).orElse(null);

        if (user == null) {
            return "redirect:/login?error=User not found";
        }

        
        if (user != null) {
            session.setAttribute("userName", user.getName());
//            session.setAttribute("userId", user.getId());
        }
        
     //Chart 1: Fetch filtered EXPENSE transactions 
        LocalDate fromDate = LocalDate.now().withDayOfMonth(1);
        LocalDate toDate = LocalDate.now();
        
        List<Transaction> expenses = transactionRepo.findByUserIdAndTypeAndDateBetween(
        		user.getId(), 
        		TxnType.EXPENSE, 
        		fromDate, 
        		toDate
        		);
        
        //Chart 1: Calculate category-wise totals
        Map<String, Double> categoryExpenseMap = new LinkedHashMap<>();
        for(Transaction t : expenses) {
        	String category = t.getCategory().getName();
        	Double amount = t.getAmount();
        	
        	categoryExpenseMap.put(
        			category, 
        			categoryExpenseMap.getOrDefault(category, 0.0) + amount
        			);
        }
        
        //Send data to JSP
        model.addAttribute("categoryExpenseMap", categoryExpenseMap);
        
      //Chart 2:INCOME vs EXPENSE :- Fetch filtered INC transactions, EXP is already filtered above
        List<Transaction> incomes = transactionRepo.findByUserIdAndTypeAndDateBetween(
        		user.getId(),
        		TxnType.INCOME,
        		fromDate,
        		toDate
        		);
        
        Double totalIncome = 0.0;
        for(Transaction i : incomes) {
        	
        	totalIncome += i.getAmount();
        }
        
        Double totalExpense = 0.0;
        for(Transaction e : expenses) {
        	
        	totalExpense += e.getAmount();
        }
        
        model.addAttribute("totalIncome", totalIncome);
        model.addAttribute("totalExpense", totalExpense);
        
      //Chart 3: Expense Trend-Line - expenses change over time, as expenses is already fetched above
        Map<LocalDate, Double> dateExpenseMap = new LinkedHashMap<>();
        for(Transaction e : expenses) {
        		dateExpenseMap.put(
        				e.getDate(), 
        				dateExpenseMap.getOrDefault(e.getDate(), 0.0) + e.getAmount()
        				);
        }
        
        model.addAttribute("dateExpenseMap", dateExpenseMap);

        //CHART 4: BUDGET vs EXPENSE 
        List<Budget> budgets = budgetRepo.findByUserId(user.getId());//Logged in users budget 
        List<Transaction> expense = transactionRepo.findByUserId(user.getId());//Logged in users budget 

        
        Map<String , Double> budgetMap = new LinkedHashMap<>();
        for(Budget b : budgets) {
        	budgetMap.put(b.getCategory().getName(), b.getAmount());
        }
        
        Map<String, Double> expenseMap = new LinkedHashMap<>();
        for(Transaction e : expense) {
        	String category = e.getCategory().getName();
        	expenseMap.put(
        			category, 
        			expenseMap.getOrDefault(category, 0.0) + e.getAmount());
        }
        
        model.addAttribute("budgetMap", budgetMap);
        model.addAttribute("expenseMap", expenseMap);
        
        return "dashboard";
    }
	
	@GetMapping("/category")
	public String CategoryPage(Model model) {
		List<Category> categories = categoryRepo.findAll();
		model.addAttribute("categories", categories);
		
		return "category";
	}
}
