package com.inspectionapp.backend.entity;

// Jakarta Persistence — the standard JPA API (replaces javax.persistence in Jakarta EE 9+)
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

// Lombok — reduces boilerplate by generating code at compile time
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

// Marks this class as a JPA-managed entity mapped to a relational table.
@Entity
// Overrides the default table name (which would be "user" — a reserved SQL keyword).
// Always quote or rename entities whose class names are SQL reserved words.
@Table(name = "users")
// Generates getters for all fields. Avoids writing getter methods manually.
@Getter
// Generates setters for all fields. Required by JPA's reflection-based hydration.
@Setter
// Generates a builder pattern: User.builder().username("...").build()
@Builder
// JPA requires a no-argument constructor. AccessLevel.PROTECTED prevents direct
// instantiation from outside the class while still satisfying the JPA spec.
@NoArgsConstructor(access = AccessLevel.PROTECTED)
// Generates an all-argument constructor that Lombok's @Builder delegates to internally.
@AllArgsConstructor
public class User extends BaseEntity {

    // @Column maps the field to a column. nullable = false adds a NOT NULL constraint.
    // unique = true adds a UNIQUE constraint. length controls VARCHAR size.
    @Column(nullable = false, unique = true, length = 50)
    private String username;

    @Column(nullable = false, unique = true, length = 100)
    private String email;

    @Column(nullable = false, length = 100)
    private String fullName;

    // @Enumerated(EnumType.STRING) stores the enum constant name ("ADMIN", "INSPECTOR")
    // in the column instead of its ordinal index (0, 1). STRING is preferred because
    // adding/reordering enum values will not corrupt existing rows.
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private UserRole role;

    // BCrypt-hashed password — the plain-text password is NEVER stored.
    // @Column length is not set because BCrypt hashes are always exactly 60
    // characters; the default VARCHAR(255) is fine.
    @Column(nullable = false)
    private String password;

    // @OneToMany — one User can have many Inspections.
    // mappedBy = "inspector" tells JPA that the Inspection.inspector field owns the
    // foreign key column, so no join table is created here.
    // fetch = FetchType.LAZY — the collection is NOT loaded from the database until
    // explicitly accessed. This is the default for @OneToMany, but stating it
    // explicitly makes the intent clear and avoids performance surprises.
    // cascade: no cascade here — inspections have their own independent lifecycle.
    @OneToMany(mappedBy = "inspector", fetch = FetchType.LAZY)
    // @Builder.Default ensures that when this entity is created via the builder
    // the list is initialized to an empty ArrayList instead of null.
    @Builder.Default
    private List<Inspection> inspections = new ArrayList<>();

}
