package com.user.api.user.application.port.in;

import com.user.api.user.infrastructure.dto.UserRequestDto;
import com.user.api.user.infrastructure.dto.UserResponseDto;

import java.util.List;

public interface UserUseCase {
    List<UserResponseDto> getAllUsers();
    UserResponseDto getUserById(Long id);
    UserResponseDto getUserByEmail(String email);
    UserResponseDto createUser(UserRequestDto userRequestDto);
    UserResponseDto updateUser(Long id, UserRequestDto userRequestDto);
    void deleteUser(Long id);
    boolean existsByEmail(String email);
}