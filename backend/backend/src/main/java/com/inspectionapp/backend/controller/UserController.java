package com.inspectionapp.backend.controller;

import com.inspectionapp.backend.dto.request.CreateUserRequest;
import com.inspectionapp.backend.dto.request.UpdateUserRequest;
import com.inspectionapp.backend.dto.response.UserResponse;
import com.inspectionapp.backend.entity.UserRole;
import com.inspectionapp.backend.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * REST controller for managing system users (administrators and inspectors).
 *
 * <p>Base path: {@code /api/v1/users}
 *
 * <p>Error responses follow the {@link com.inspectionapp.backend.dto.response.ErrorResponse}
 * schema produced by {@link com.inspectionapp.backend.exception.GlobalExceptionHandler}.
 */
@RestController
@RequestMapping("/api/v1/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    // -------------------------------------------------------------------------
    // GET
    // -------------------------------------------------------------------------

    /**
     * Returns all users, optionally filtered by role.
     *
     * <p>Examples:
     * <pre>
     *   GET /api/v1/users              → all users
     *   GET /api/v1/users?role=INSPECTOR → inspectors only
     * </pre>
     *
     * @param role optional role filter ({@code ADMIN} or {@code INSPECTOR})
     * @return 200 OK with the matching user list
     */
    @GetMapping
    public ResponseEntity<List<UserResponse>> getUsers(
            @RequestParam(required = false) UserRole role) {
        List<UserResponse> users = (role != null)
                ? userService.getUsersByRole(role)
                : userService.getAllUsers();
        return ResponseEntity.ok(users);
    }

    /**
     * Returns a single user by their database ID.
     *
     * @param id the user ID
     * @return 200 OK, or 404 if no user with that ID exists
     */
    @GetMapping("/{id}")
    public ResponseEntity<UserResponse> getUserById(@PathVariable Long id) {
        return ResponseEntity.ok(userService.getUserById(id));
    }

    // -------------------------------------------------------------------------
    // POST
    // -------------------------------------------------------------------------

    /**
     * Creates a new user.
     *
     * <p>Both {@code username} and {@code email} must be unique across the system.
     *
     * @param request validated user payload
     * @return 201 Created with the persisted user
     */
    @PostMapping
    public ResponseEntity<UserResponse> createUser(@Valid @RequestBody CreateUserRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(userService.createUser(request));
    }

    // -------------------------------------------------------------------------
    // PUT
    // -------------------------------------------------------------------------

    /**
     * Partially updates an existing user.
     *
     * <p>Only non-null fields in the request body are applied; omitting a field
     * leaves it unchanged. The user ID is immutable.
     *
     * @param id      the user to update
     * @param request fields to change
     * @return 200 OK with the updated user, or 404 if not found
     */
    @PutMapping("/{id}")
    public ResponseEntity<UserResponse> updateUser(
            @PathVariable Long id,
            @Valid @RequestBody UpdateUserRequest request) {
        return ResponseEntity.ok(userService.updateUser(id, request));
    }

    // -------------------------------------------------------------------------
    // DELETE
    // -------------------------------------------------------------------------

    /**
     * Deletes a user by ID.
     *
     * @param id the user to delete
     * @return 204 No Content, or 404 if not found
     */
    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
    }

}
