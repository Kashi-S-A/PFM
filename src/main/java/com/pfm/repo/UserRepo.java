package com.pfm.repo;

import org.springframework.data.jpa.repository.JpaRepository;

import com.pfm.entity.User;

public interface UserRepo extends JpaRepository<User, Integer>{

}
