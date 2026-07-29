package com.inspectionapp.backend.service;

import com.inspectionapp.backend.dto.request.CreateArticleRequest;
import com.inspectionapp.backend.dto.request.UpdateArticleRequest;
import com.inspectionapp.backend.dto.response.ArticleResponse;

import java.util.List;

/**
 * Manages articles — the catalogue of items (SKUs / EANs) that can be damaged.
 *
 * <p>Responsibilities:
 * <ul>
 *   <li>Create articles with a unique-code guard (the code is the business key
 *       and is immutable after creation).</li>
 *   <li>Retrieve articles individually, in full, or via a combined code/name
 *       search.</li>
 *   <li>Apply partial updates to mutable fields (name, description).</li>
 *   <li>Delete an article by ID.</li>
 * </ul>
 */
public interface ArticleService {

    ArticleResponse createArticle(CreateArticleRequest request);

    ArticleResponse getArticleById(Long id);

    List<ArticleResponse> getAllArticles();

    /** Returns articles whose code equals {@code query} OR whose name contains it. */
    List<ArticleResponse> searchArticles(String query);

    ArticleResponse updateArticle(Long id, UpdateArticleRequest request);

    void deleteArticle(Long id);

}
