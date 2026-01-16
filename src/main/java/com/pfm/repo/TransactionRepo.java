package com.pfm.repo;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.pfm.entity.Transaction;
import com.pfm.entity.TxnType;

public interface TransactionRepo extends JpaRepository<Transaction, Integer> {

	List<Transaction> findByUserId(Integer uid);

	List<Transaction> findByUserIdAndTypeAndDateBetween(Integer id, TxnType expense, LocalDate fromDate,
			LocalDate toDate);
}
    @Query("""
      SELECT t FROM Transaction t
      WHERE t.user.id = :userId
      AND (:type IS NULL OR t.type = :type)
      AND (:catId IS NULL OR t.category.id = :catId)
      AND (:fromDate IS NULL OR t.date >= :fromDate)
      AND (:toDate IS NULL OR t.date <= :toDate)
    """)
    List<Transaction> filterTrans(
            @Param("userId") Integer integer,
            @Param("type") TxnType type,
            @Param("catId") Long catId,
            @Param("fromDate") LocalDate fromDate,
            @Param("toDate") LocalDate toDate
    );

	List<Transaction> findByUserId(Integer id);
}
