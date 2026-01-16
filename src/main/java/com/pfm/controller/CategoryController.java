package com.pfm.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.pfm.entity.Category;
import com.pfm.repo.CategoryRepo;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/category")
public class CategoryController {

    private final CategoryRepo categoryRepository;

    public CategoryController(CategoryRepo categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    @GetMapping
    public String listCategories(HttpServletRequest request) {
        request.setAttribute("categories", categoryRepository.findAll());
        return "category"; // category.jsp
    }

    @GetMapping("/add")
    public String showAddPage() {
        return "add-category"; // add-category.jsp
    }

    @PostMapping("/save")
    public String saveCategory(Category category) {
        categoryRepository.save(category);
        return "redirect:/category";
    }
}
