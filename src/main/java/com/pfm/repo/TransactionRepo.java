package com.pfm.repo;

import org.springframework.data.jpa.repository.JpaRepository;

import com.pfm.entity.Transaction;

public interface TransactionRepo extends JpaRepository<Transaction, Integer>{

}
