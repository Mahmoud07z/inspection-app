package com.inspectionapp.backend.service.impl;

import com.inspectionapp.backend.dto.request.CreateArticleRequest;
import com.inspectionapp.backend.dto.request.UpdateArticleRequest;
import com.inspectionapp.backend.dto.response.ArticleResponse;
import com.inspectionapp.backend.entity.Article;
import com.inspectionapp.backend.exception.DuplicateResourceException;
import com.inspectionapp.backend.exception.ResourceNotFoundException;
import com.inspectionapp.backend.repository.ArticleRepository;
import com.inspectionapp.backend.service.ArticleService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Manages the article catalogue (SKUs / EANs that can be damaged).
 *
 * <p>The article {@code code} is the immutable business key. Once an article
 * has damage reports referencing it, renaming the code would break historical
 * traceability, so updates are restricted to {@code name} and {@code description}.
 *
 * <p>{@link #searchArticles(String)} performs a combined lookup: an exact match
 * on {@code code} (useful when scanning a barcode) OR a partial, case-insensitive
 * match on {@code name} (useful in free-text search boxes).
 */
@SuppressWarnings("null")
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ArticleServiceImpl implements ArticleService {

    private final ArticleRepository articleRepository;

    @Override
    @Transactional
    public ArticleResponse createArticle(CreateArticleRequest request) {
        if (articleRepository.existsByCode(request.code())) {
            throw new DuplicateResourceException("Article code already exists: " + request.code());
        }

        Article article = Article.builder()
                .code(request.code())
                .name(request.name())
                .description(request.description())
                .build();

        return toResponse(articleRepository.save(article));
    }

    @Override
    public ArticleResponse getArticleById(Long id) {
        return articleRepository.findById(id)
                .map(this::toResponse)
                .orElseThrow(() -> new ResourceNotFoundException("Article not found with id: " + id));
    }

    @Override
    public List<ArticleResponse> getAllArticles() {
        return articleRepository.findAll()
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Override
    public List<ArticleResponse> searchArticles(String query) {
        return articleRepository.findByCodeOrNameContainingIgnoreCase(query, query)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Override
    @Transactional
    public ArticleResponse updateArticle(Long id, UpdateArticleRequest request) {
        Article article = articleRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Article not found with id: " + id));

        if (request.name() != null) {
            article.setName(request.name());
        }
        if (request.description() != null) {
            article.setDescription(request.description());
        }

        return toResponse(articleRepository.save(article));
    }

    @Override
    @Transactional
    public void deleteArticle(Long id) {
        if (!articleRepository.existsById(id)) {
            throw new ResourceNotFoundException("Article not found with id: " + id);
        }
        articleRepository.deleteById(id);
    }

    // -------------------------------------------------------------------------
    // Mapping
    // -------------------------------------------------------------------------

    private ArticleResponse toResponse(Article article) {
        return new ArticleResponse(
                article.getId(),
                article.getCode(),
                article.getName(),
                article.getDescription(),
                article.getCreatedAt(),
                article.getUpdatedAt()
        );
    }

}
