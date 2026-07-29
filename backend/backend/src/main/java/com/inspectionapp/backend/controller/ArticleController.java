package com.inspectionapp.backend.controller;

import com.inspectionapp.backend.dto.request.CreateArticleRequest;
import com.inspectionapp.backend.dto.request.UpdateArticleRequest;
import com.inspectionapp.backend.dto.response.ArticleResponse;
import com.inspectionapp.backend.service.ArticleService;
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
 * REST controller for managing the article catalogue — the SKUs and EANs
 * that can be found damaged during an inspection.
 *
 * <p>Base path: {@code /api/v1/articles}
 */
@RestController
@RequestMapping("/api/v1/articles")
@RequiredArgsConstructor
public class ArticleController {

    private final ArticleService articleService;

    // -------------------------------------------------------------------------
    // GET
    // -------------------------------------------------------------------------

    /**
     * Returns all articles, with an optional combined search on code and name.
     *
     * <p>The search performs an exact match on {@code code} (barcode scan) OR a
     * partial case-insensitive match on {@code name} (free-text search) in a
     * single query.
     *
     * <p>Examples:
     * <pre>
     *   GET /api/v1/articles           → full catalogue
     *   GET /api/v1/articles?q=pallet  → articles whose code = "pallet" or name contains "pallet"
     * </pre>
     *
     * @param q optional search query applied to both code and name
     * @return 200 OK with the matching list
     */
    @GetMapping
    public ResponseEntity<List<ArticleResponse>> getArticles(
            @RequestParam(required = false) String q) {
        List<ArticleResponse> articles = (q != null && !q.isBlank())
                ? articleService.searchArticles(q)
                : articleService.getAllArticles();
        return ResponseEntity.ok(articles);
    }

    /**
     * Returns a single article by its database ID.
     *
     * @param id the article ID
     * @return 200 OK, or 404 if not found
     */
    @GetMapping("/{id}")
    public ResponseEntity<ArticleResponse> getArticleById(@PathVariable Long id) {
        return ResponseEntity.ok(articleService.getArticleById(id));
    }

    // -------------------------------------------------------------------------
    // POST
    // -------------------------------------------------------------------------

    /**
     * Creates a new article in the catalogue.
     *
     * <p>The {@code code} (SKU/EAN) is the immutable business key and must be
     * unique across the catalogue.
     *
     * @param request validated article payload
     * @return 201 Created with the persisted article
     */
    @PostMapping
    public ResponseEntity<ArticleResponse> createArticle(
            @Valid @RequestBody CreateArticleRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(articleService.createArticle(request));
    }

    // -------------------------------------------------------------------------
    // PUT
    // -------------------------------------------------------------------------

    /**
     * Partially updates an article's {@code name} and/or {@code description}.
     *
     * <p>The {@code code} is immutable after creation to preserve damage-report
     * traceability. Only non-null fields in the request body are applied.
     *
     * @param id      the article to update
     * @param request fields to change
     * @return 200 OK with the updated article, or 404 if not found
     */
    @PutMapping("/{id}")
    public ResponseEntity<ArticleResponse> updateArticle(
            @PathVariable Long id,
            @Valid @RequestBody UpdateArticleRequest request) {
        return ResponseEntity.ok(articleService.updateArticle(id, request));
    }

    // -------------------------------------------------------------------------
    // DELETE
    // -------------------------------------------------------------------------

    /**
     * Deletes an article by ID.
     *
     * <p>Existing damage reports that reference this article retain their
     * association for historical traceability.
     *
     * @param id the article to delete
     * @return 204 No Content, or 404 if not found
     */
    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteArticle(@PathVariable Long id) {
        articleService.deleteArticle(id);
    }

}
