package com.inspectionapp.backend.service;

import com.inspectionapp.backend.dto.request.CreateUserRequest;
import com.inspectionapp.backend.dto.request.UpdateUserRequest;
import com.inspectionapp.backend.dto.response.UserResponse;
import com.inspectionapp.backend.entity.UserRole;

import java.util.List;

/**
 * Manages system users (admins and inspectors).
 *
 * <p>Responsibilities:
 * <ul>
 *   <li>Create users with duplicate-username and duplicate-email guards.</li>
 *   <li>Retrieve users by ID, role, or in full.</li>
 *   <li>Apply partial updates — only non-null fields are changed.</li>
 *   <li>Delete a user by ID; fails fast with {@code ResourceNotFoundException}
 *       if the user does not exist.</li>
 * </ul>
 */
public interface UserService {

    UserResponse createUser(CreateUserRequest request);

    UserResponse getUserById(Long id);

    List<UserResponse> getAllUsers();

    List<UserResponse> getUsersByRole(UserRole role);

    UserResponse updateUser(Long id, UpdateUserRequest request);

    void deleteUser(Long id);

}
