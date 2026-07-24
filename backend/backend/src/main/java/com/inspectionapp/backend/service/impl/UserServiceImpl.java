package com.inspectionapp.backend.service.impl;

import com.inspectionapp.backend.dto.request.CreateUserRequest;
import com.inspectionapp.backend.dto.request.UpdateUserRequest;
import com.inspectionapp.backend.dto.response.UserResponse;
import com.inspectionapp.backend.entity.User;
import com.inspectionapp.backend.entity.UserRole;
import com.inspectionapp.backend.exception.DuplicateResourceException;
import com.inspectionapp.backend.exception.ResourceNotFoundException;
import com.inspectionapp.backend.repository.UserRepository;
import com.inspectionapp.backend.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Manages user accounts.
 *
 * <p>All read-only methods run inside a read-only transaction, which lets the
 * underlying connection pool and database optimise accordingly (e.g. read
 * replicas, skip dirty-checking on flush). Write methods override this with a
 * full read-write transaction via {@code @Transactional} on the method.
 *
 * <p>Duplicate detection is done before the INSERT so that the error message
 * is clear and deterministic, rather than relying on a DB constraint violation
 * translated by the JPA provider.
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    @Transactional
    public UserResponse createUser(CreateUserRequest request) {
        if (userRepository.existsByUsername(request.username())) {
            throw new DuplicateResourceException("Username already exists: " + request.username());
        }
        if (userRepository.existsByEmail(request.email())) {
            throw new DuplicateResourceException("Email already exists: " + request.email());
        }

        User user = User.builder()
                .username(request.username())
                .email(request.email())
                .fullName(request.fullName())
                .role(request.role())
                .password(passwordEncoder.encode(request.password()))
                .build();

        return toResponse(userRepository.save(user));
    }

    @Override
    public UserResponse getUserById(Long id) {
        return userRepository.findById(id)
                .map(this::toResponse)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + id));
    }

    @Override
    public List<UserResponse> getAllUsers() {
        return userRepository.findAll()
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Override
    public List<UserResponse> getUsersByRole(UserRole role) {
        return userRepository.findByRole(role)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    /**
     * Applies a partial update — only fields that are non-null in the request
     * are written to the entity. Uniqueness is re-checked when the username or
     * email changes, but only against other users (the current value is skipped
     * to avoid a false-positive conflict on an unchanged field).
     */
    @Override
    @Transactional
    public UserResponse updateUser(Long id, UpdateUserRequest request) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + id));

        if (request.username() != null && !request.username().equals(user.getUsername())) {
            if (userRepository.existsByUsername(request.username())) {
                throw new DuplicateResourceException("Username already exists: " + request.username());
            }
            user.setUsername(request.username());
        }

        if (request.email() != null && !request.email().equals(user.getEmail())) {
            if (userRepository.existsByEmail(request.email())) {
                throw new DuplicateResourceException("Email already exists: " + request.email());
            }
            user.setEmail(request.email());
        }

        if (request.fullName() != null) {
            user.setFullName(request.fullName());
        }
        if (request.role() != null) {
            user.setRole(request.role());
        }

        return toResponse(userRepository.save(user));
    }

    @Override
    @Transactional
    public void deleteUser(Long id) {
        if (!userRepository.existsById(id)) {
            throw new ResourceNotFoundException("User not found with id: " + id);
        }
        userRepository.deleteById(id);
    }

    // -------------------------------------------------------------------------
    // Mapping
    // -------------------------------------------------------------------------

    private UserResponse toResponse(User user) {
        return new UserResponse(
                user.getId(),
                user.getUsername(),
                user.getEmail(),
                user.getFullName(),
                user.getRole(),
                user.getCreatedAt(),
                user.getUpdatedAt()
        );
    }

}
