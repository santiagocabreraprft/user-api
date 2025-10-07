package com.user.api.user.infrastructure.adapter.in;

import com.user.api.user.application.port.in.UserUseCase;
import com.user.api.user.infrastructure.dto.UserRequestDto;
import com.user.api.user.infrastructure.dto.UserResponseDto;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "http://localhost:3000")
@RequiredArgsConstructor
@Tag(name = "User API", description = "Operations related to users")
public class UserController {

    private final UserUseCase userUseCase;

    @GetMapping
    @Operation(summary = "Get all users", description = "Returns a list of all users")
    public ResponseEntity<List<UserResponseDto>> getAllUsers() {
        List<UserResponseDto> users = userUseCase.getAllUsers();
        return ResponseEntity.ok(users);
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get user by ID", description = "Returns a user by their ID")
    public ResponseEntity<UserResponseDto> getUserById(
            @Parameter(description = "ID of the user", example = "1") @PathVariable Long id) {
        UserResponseDto user = userUseCase.getUserById(id);
        return ResponseEntity.ok(user);
    }

    @GetMapping("/email/{email}")
    @Operation(summary = "Get user by email", description = "Returns a user by their email")
    public ResponseEntity<UserResponseDto> getUserByEmail(
            @Parameter(description = "Email of the user", example = "user@example.com") @PathVariable String email) {
        UserResponseDto user = userUseCase.getUserByEmail(email);
        return ResponseEntity.ok(user);
    }

    @PostMapping
    @Operation(summary = "Create a new user", description = "Creates a new user with the provided information")
    public ResponseEntity<UserResponseDto> createUser(
            @Parameter(description = "User information for creation") @Valid @RequestBody UserRequestDto userRequestDto) {
        UserResponseDto createdUser = userUseCase.createUser(userRequestDto);
        return new ResponseEntity<>(createdUser, HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    @Operation(summary = "Update user", description = "Updates an existing user by ID")
    public ResponseEntity<UserResponseDto> updateUser(
            @Parameter(description = "ID of the user to update", example = "1") @PathVariable Long id,
            @Parameter(description = "Updated user information") @Valid @RequestBody UserRequestDto userRequestDto) {
        UserResponseDto updatedUser = userUseCase.updateUser(id, userRequestDto);
        return ResponseEntity.ok(updatedUser);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Delete user", description = "Deletes a user by their ID")
    public ResponseEntity<Void> deleteUser(
            @Parameter(description = "ID of the user to delete", example = "1") @PathVariable Long id) {
        userUseCase.deleteUser(id);
        return ResponseEntity.noContent().build();
    }
}