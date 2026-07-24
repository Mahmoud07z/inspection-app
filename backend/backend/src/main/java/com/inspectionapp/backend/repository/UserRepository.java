package com.inspectionapp.backend.repository;

import com.inspectionapp.backend.entity.User;
import com.inspectionapp.backend.entity.UserRole;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository for {@link User} entities.
 *
 * <p>Extends {@link JpaRepository} which already provides:
 * save, findById, findAll, deleteById, count, existsById, and more.
 * The type parameters are the entity class and its primary key type.
 *
 * <p>Spring Data JPA generates SQL from method names automatically — no
 * implementation class is needed. The rule is:
 * {@code findBy<Field>[And|Or<Field>]*(<params>)}
 */
@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    // SELECT * FROM users WHERE username = ?
    // Returns Optional so callers are forced to handle the absent case
    // without risking a NullPointerException.
    Optional<User> findByUsername(String username);

    // SELECT * FROM users WHERE email = ?
    Optional<User> findByEmail(String email);

    // SELECT COUNT(*) > 0 FROM users WHERE username = ?
    // Existence checks avoid loading a full entity just to test presence.
    boolean existsByUsername(String username);

    // SELECT COUNT(*) > 0 FROM users WHERE email = ?
    boolean existsByEmail(String email);

    // SELECT * FROM users WHERE role = ?
    // Useful to list all inspectors for assignment dropdowns.
    List<User> findByRole(UserRole role);

    // LIKE search on the full name, case-insensitive.
    // Spring Data translates IgnoreCase to LOWER(...) LIKE LOWER(?) in SQL.
    List<User> findByFullNameContainingIgnoreCase(String name);

}
