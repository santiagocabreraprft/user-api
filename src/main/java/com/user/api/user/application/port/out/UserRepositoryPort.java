package com.user.api.user.application.port.out;

import com.user.api.user.domain.User;

import java.util.List;
import java.util.Optional;

public interface UserRepositoryPort {

    List<User> findAll();
    Optional<User> findById(Long id);
    Optional<User> findByEmail(String email);
    User save(User user);
    void deleteById(Long id);
    boolean existsById(Long id);
    boolean existsByEmail(String email);
}
