package com.inspectionapp.backend.repository;

import com.inspectionapp.backend.entity.Article;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository for {@link Article} entities.
 *
 * <p>Articles are catalogue items (SKUs). Lookups by code and name searches
 * are the most common access patterns.
 */
@Repository
public interface ArticleRepository extends JpaRepository<Article, Long> {

    // SELECT * FROM articles WHERE code = ?
    // Code is a unique business key (SKU/EAN) — preferred over ID in API calls.
    Optional<Article> findByCode(String code);

    // SELECT COUNT(*) > 0 FROM articles WHERE code = ?
    boolean existsByCode(String code);

    // Partial, case-insensitive name search.
    // Translates to: WHERE LOWER(name) LIKE LOWER('%?%')
    List<Article> findByNameContainingIgnoreCase(String name);

    // Combined code + name search — useful if a caller can supply either identifier.
    // Spring Data generates: WHERE code = ? OR LOWER(name) LIKE LOWER('%?%')
    List<Article> findByCodeOrNameContainingIgnoreCase(String code, String name);

}
