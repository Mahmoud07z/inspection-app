# Inspection App — Project Summary

## Project Overview

**Inspection App** is a full-stack warehouse inspection management system designed to facilitate the creation, assignment, and execution of physical warehouse inspections. Inspectors use a Flutter mobile app to record damage reports; administrators manage warehouses, locations, articles, and users through the same interface. A Spring Boot REST API backs the entire system with JWT-based authentication.

---

## Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                      Flutter Mobile App                       │
│  (Riverpod + GoRouter + Dio + flutter_secure_storage)         │
└──────────────────────┬───────────────────────────────────────┘
                       │ HTTPS REST  (Bearer JWT)
                       ▼
┌──────────────────────────────────────────────────────────────┐
│                 Spring Boot 3.5 REST API                      │
│  Spring Security  │  Spring Data JPA  │  Bean Validation      │
└──────────────────────┬───────────────────────────────────────┘
                       │ JDBC
                       ▼
┌──────────────────────────────────────────────────────────────┐
│                    PostgreSQL 15+                             │
└──────────────────────────────────────────────────────────────┘
```

### Backend Layers

| Layer | Package | Responsibility |
|---|---|---|
| Controllers | `controller/` | HTTP request handling, input validation delegation |
| Services | `service/` | Business logic, transaction management |
| Repositories | `repository/` | Database queries (Spring Data JPA) |
| Entities | `entity/` | JPA-mapped domain objects |
| DTOs | `dto/request/` `dto/response/` | API contracts, Bean Validation |
| Security | `security/` | JWT generation/validation, filter chain |
| Config | `config/` | JPA auditing, CORS |
| Exception | `exception/` | Centralised error handling |

### Flutter Layers

| Layer | Directory | Responsibility |
|---|---|---|
| Core | `lib/core/` | Constants, theme, navigation, utilities |
| Shared | `lib/shared/` | Reusable models, services, widgets |
| Features | `lib/features/<name>/` | Self-contained vertical slices (model, service, provider, screens, widgets) |

---

## Technologies Used

### Backend

| Technology | Version | Purpose |
|---|---|---|
| Java | 25 (Temurin LTS) | Runtime |
| Spring Boot | 3.5.16 | Framework |
| Spring Security | 6.x | Authentication / authorisation |
| Spring Data JPA | 3.x | ORM / repositories |
| Hibernate | 6.x | JPA provider |
| JJWT | 0.12.6 | JWT generation & validation |
| PostgreSQL | 15+ | Production database |
| H2 | latest | In-memory test database |
| Lombok | 1.18.46 | Boilerplate reduction |
| Maven | 3.9.16 | Build tool |

### Mobile

| Technology | Version | Purpose |
|---|---|---|
| Flutter | ≥ 3.4.0 | Cross-platform UI framework |
| Dart | ≥ 3.4.0 | Language |
| flutter_riverpod | 2.5.1 | State management |
| go_router | 14.2.7 | Declarative navigation |
| Dio | 5.4.3+1 | HTTP client |
| flutter_secure_storage | 9.2.2 | JWT persistence (OS keychain) |
| intl | 0.19.0 | Date formatting |

---

## Folder Structure

```
inspection-app/
├── backend/
│   └── backend/
│       ├── pom.xml
│       └── src/
│           ├── main/
│           │   ├── java/com/inspectionapp/backend/
│           │   │   ├── InspectionAppBackendApplication.java
│           │   │   ├── config/         JpaConfig, WebConfig
│           │   │   ├── controller/     8 REST controllers
│           │   │   ├── dto/
│           │   │   │   ├── request/    13 request DTOs
│           │   │   │   └── response/   9 response DTOs
│           │   │   ├── entity/         6 entities + 4 enums
│           │   │   ├── exception/      4 exceptions + GlobalExceptionHandler
│           │   │   ├── repository/     6 repositories
│           │   │   ├── security/       JwtUtil, JwtFilter, UserDetailsService, SecurityConfig
│           │   │   └── service/        6 interfaces + 6 implementations
│           │   └── resources/
│           │       └── application.properties
│           └── test/
│               └── resources/
│                   └── application.properties
├── mobile/
│   └── mobile/
│       ├── pubspec.yaml
│       └── lib/
│           ├── main.dart
│           ├── app.dart
│           ├── core/
│           │   ├── constants/      api_constants.dart
│           │   ├── navigation/     app_router.dart, route_names.dart
│           │   ├── theme/          app_colors.dart, app_theme.dart
│           │   └── utils/          date_formatter.dart, validators.dart, extensions.dart
│           ├── shared/
│           │   ├── models/         api_error.dart
│           │   ├── services/       api_service.dart (Dio singleton)
│           │   └── widgets/        app_button, app_text_field, loading_indicator, error_display
│           └── features/
│               ├── auth/           login flow, JWT provider
│               ├── dashboard/      overview grid
│               ├── warehouses/     CRUD list + detail
│               ├── locations/      per-warehouse list
│               ├── articles/       searchable list
│               ├── inspections/    filter by status, detail, status transition
│               ├── damage_reports/ per-inspection list
│               └── users/          admin-managed user list
└── docs/
    ├── PROJECT_SUMMARY.md
    ├── SETUP.md
    ├── API_TESTING.md
    └── POSTMAN_COLLECTION.md
```

---

## Backend Explanation

### Entities and Relationships

```
User ──< Inspection >── Warehouse
                │
                └──< DamageReport >── Article
                                  └── Location >── Warehouse
```

- **User**: accounts with role `ADMIN` or `INSPECTOR`.
- **Warehouse**: physical warehouse with a unique business code and multiple locations.
- **Location**: aisle/shelf inside a warehouse; code is unique *per warehouse*.
- **Article**: a product or item type that can be damaged.
- **Inspection**: a scheduled inspection of a warehouse, assigned to one inspector, producing damage reports.
- **DamageReport**: a record of damage to a specific article at a specific location during an inspection.

### Authentication Flow

1. Client `POST /api/v1/auth/login` with `{username, password}`.
2. `DaoAuthenticationProvider` verifies BCrypt hash.
3. `JwtUtil.generateToken()` creates an HS256 JWT (24h expiry, includes `roles` claim).
4. JWT returned as `{token, type: "Bearer", username, role}`.
5. Client stores token in `flutter_secure_storage`.
6. Every subsequent request carries `Authorization: Bearer <token>`.
7. `JwtAuthenticationFilter` validates the token and populates `SecurityContextHolder`.

### API Structure

Base path: `/api/v1`

| Resource | Base path | Operations |
|---|---|---|
| Auth | `/auth` | `POST /login` |
| Health | `/health` | `GET /` |
| Users | `/users` | Full CRUD |
| Warehouses | `/warehouses` | Full CRUD + search by name |
| Locations | `/locations` | Full CRUD + filter by warehouse |
| Articles | `/articles` | Full CRUD + search |
| Inspections | `/inspections` | Full CRUD + filter (warehouseId, inspectorId, status) + `PATCH /{id}/status` |
| Damage Reports | `/damage-reports` | Full CRUD + filter by inspection/article |

---

## Database Explanation

### Schema (auto-generated by Hibernate)

| Table | Key columns |
|---|---|
| `users` | id, username (unique), email (unique), full_name, role, password |
| `warehouses` | id, code (unique), name, address |
| `locations` | id, code, warehouse_id (FK), description — UNIQUE(code, warehouse_id) |
| `articles` | id, code (unique), name, description |
| `inspections` | id, inspection_code (unique), warehouse_id (FK), inspector_id (FK), status, scheduled_date, notes |
| `damage_reports` | id, inspection_id (FK), article_id (FK), location_id (FK), severity, description, photo_url |

All tables include `created_at` and `updated_at` columns managed by Spring Data JPA auditing (`@EnableJpaAuditing`).

### DDL Strategy

- Development/test: `spring.jpa.hibernate.ddl-auto=update` (auto-migrate schema)
- Production recommendation: switch to `validate` and use a migration tool (Flyway/Liquibase)

---

## Current Project Status

### ✅ Complete

- Java 25 + Spring Boot 3.5.16 backend with full CRUD for all 6 resources
- JWT authentication (login → token → protected endpoints)
- Bean Validation on all request DTOs
- Global exception handling (12 handlers)
- PostgreSQL production config + H2 test config
- Flutter mobile app with feature-based architecture (8 features)
- Riverpod state management with `AsyncNotifierProvider` and `FamilyAsyncNotifier`
- GoRouter with auth guard
- Dio HTTP client with JWT interceptor and error interceptor
- Secure token storage with `flutter_secure_storage`

### 🔄 Remaining TODOs

| Item | Priority | Notes |
|---|---|---|
| Create/Edit forms for all entities | High | Only read/delete is wired; `// TODO: create form` comments in every FAB |
| Postman collection (JSON file) | High | API guide exists; collection JSON in `docs/` pending |
| Pagination support | Medium | Backend returns full lists; add `Pageable` for large datasets |
| Role-based UI (ADMIN vs INSPECTOR) | Medium | `role` in JWT but Flutter doesn't gate screens yet |
| Production Dockerfile | Medium | App runs locally; containerisation not configured |
| Database migration tool | Medium | Switch DDL to `validate` + Flyway for production |
| Photo upload for DamageReport | Low | `photoUrl` field accepts a URL; direct S3/blob upload not implemented |
| Integration/E2E tests | Low | Only one Spring context load test exists |
| Flutter widget tests | Low | No Flutter tests written yet |
