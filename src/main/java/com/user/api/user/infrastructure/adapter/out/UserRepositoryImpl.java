package com.user.api.user.infrastructure.adapter.out;

import com.user.api.user.application.port.out.UserRepositoryPort;
import com.user.api.user.domain.User;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;

@Component
@RequiredArgsConstructor
public class UserRepositoryImpl implements UserRepositoryPort {

    private final UserJpaRepository userJpaRepository;

    @Override
    public List<User> findAll() {
        return userJpaRepository.findAll();
    }

    @Override
    public Optional<User> findById(Long id) {
        return userJpaRepository.findById(id);
    }

    @Override
    public Optional<User> findByEmail(String email) {
        return userJpaRepository.findByEmail(email);
    }

    @Override
    public User save(User user) {
        return userJpaRepository.save(user);
    }

    @Override
    public void deleteById(Long id) {
        userJpaRepository.deleteById(id);
    }

    @Override
    public boolean existsById(Long id) {
        return userJpaRepository.existsById(id);
    }

    @Override
    public boolean existsByEmail(String email) {
        return userJpaRepository.existsByEmail(email);
    }
}