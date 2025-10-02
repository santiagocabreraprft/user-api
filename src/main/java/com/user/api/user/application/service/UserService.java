package com.user.api.user.application.service;

import com.user.api.user.application.port.in.UserUseCase;
import com.user.api.user.application.port.out.UserRepositoryPort;
import com.user.api.user.domain.User;
import com.user.api.user.domain.exception.UserAlreadyExistsException;
import com.user.api.user.domain.exception.UserNotFoundException;
import com.user.api.user.infrastructure.dto.UserRequestDto;
import com.user.api.user.infrastructure.dto.UserResponseDto;
import com.user.api.user.infrastructure.mapper.UserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class UserService implements UserUseCase {

    private final UserRepositoryPort userRepositoryPort;
    private final UserMapper userMapper;

    @Override
    @Transactional(readOnly = true)
    public List<UserResponseDto> getAllUsers() {
        List<User> users = userRepositoryPort.findAll();
        return userMapper.toResponseDtoList(users);
    }

    @Override
    @Transactional(readOnly = true)
    public UserResponseDto getUserById(Long id) {
        User user = userRepositoryPort.findById(id)
                .orElseThrow(() -> new UserNotFoundException(id));
        return userMapper.toResponseDto(user);
    }

    @Override
    @Transactional(readOnly = true)
    public UserResponseDto getUserByEmail(String email) {
        User user = userRepositoryPort.findByEmail(email)
                .orElseThrow(() -> new UserNotFoundException("email", email));
        return userMapper.toResponseDto(user);
    }

    @Override
    public UserResponseDto createUser(UserRequestDto userRequestDto) {
        if (userRepositoryPort.existsByEmail(userRequestDto.getEmail())) {
            throw new UserAlreadyExistsException(userRequestDto.getEmail());
        }

        User user = userMapper.toEntity(userRequestDto);
        User savedUser = userRepositoryPort.save(user);
        return userMapper.toResponseDto(savedUser);
    }

    @Override
    public UserResponseDto updateUser(Long id, UserRequestDto userRequestDto) {
        User existingUser = userRepositoryPort.findById(id)
                .orElseThrow(() -> new UserNotFoundException(id));

        // Check if email is being changed and if it already exists
        if (!existingUser.getEmail().equals(userRequestDto.getEmail()) &&
                userRepositoryPort.existsByEmail(userRequestDto.getEmail())) {
            throw new UserAlreadyExistsException(userRequestDto.getEmail());
        }

        userMapper.updateEntityFromDto(userRequestDto, existingUser);
        User updatedUser = userRepositoryPort.save(existingUser);
        return userMapper.toResponseDto(updatedUser);
    }

    @Override
    public void deleteUser(Long id) {
        if (!userRepositoryPort.existsById(id)) {
            throw new UserNotFoundException(id);
        }
        userRepositoryPort.deleteById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean existsByEmail(String email) {
        return userRepositoryPort.existsByEmail(email);
    }
}