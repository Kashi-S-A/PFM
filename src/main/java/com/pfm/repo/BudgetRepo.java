package com.pfm.repo;

import org.springframework.data.jpa.repository.JpaRepository;

import com.pfm.entity.Budget;

public interface BudgetRepo extends JpaRepository<Budget, Integer> {

}
