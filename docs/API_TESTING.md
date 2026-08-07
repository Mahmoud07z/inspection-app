# API Testing Guide — Inspection App

## Base URL

```
http://localhost:8090
```

---

## Authentication

All endpoints except `GET /api/v1/health` and `POST /api/v1/auth/login` require a Bearer JWT token.

### How to obtain a token

1. Call `POST /api/v1/auth/login` with valid credentials.
2. Copy the `token` value from the response.
3. In Postman, set **Authorization → Bearer Token** to the copied value.

---

## Endpoint Reference

---

### 1. Health Check

#### `GET /api/v1/health`

| Field | Value |
|---|---|
| **Method** | GET |
| **URL** | `http://localhost:8080/api/v1/health` |
| **Auth required** | No |
| **Headers** | none |
| **Request body** | none |

**Expected response — 200 OK**

```json
{
  "status": "UP",
  "message": "Inspection App is running"
}
```

---

### 2. Authentication

#### `POST /api/v1/auth/login`

| Field | Value |
|---|---|
| **Method** | POST |
| **URL** | `http://localhost:8080/api/v1/auth/login` |
| **Auth required** | No |
| **Headers** | `Content-Type: application/json` |

**Request body**

```json
{
  "username": "admin",
  "password": "Admin@1234"
}
```

**Expected response — 200 OK**

```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "type": "Bearer",
  "username": "admin",
  "role": "ADMIN"
}
```

**Error responses**

| Status | Condition |
|---|---|
| 401 Unauthorized | Wrong username or password |
| 400 Bad Request | Missing/blank username or password |

---

### 3. Users

> All endpoints require `Authorization: Bearer <token>` with `ADMIN` role.

#### `GET /api/v1/users`

List all users. Optional filter by role.

```
GET /api/v1/users
GET /api/v1/users?role=INSPECTOR
GET /api/v1/users?role=ADMIN
```

**Expected response — 200 OK**

```json
[
  {
    "id": 1,
    "username": "admin",
    "email": "admin@example.com",
    "fullName": "Admin User",
    "role": "ADMIN",
    "createdAt": "2026-08-01T10:00:00Z",
    "updatedAt": "2026-08-01T10:00:00Z"
  }
]
```

---

#### `GET /api/v1/users/{id}`

```
GET /api/v1/users/1
```

**Expected response — 200 OK** — single user object (same shape as above)

**Error responses**

| Status | Condition |
|---|---|
| 404 Not Found | No user with that ID |

---

#### `POST /api/v1/users`

Create a new user.

**Headers**: `Content-Type: application/json`

**Request body**

```json
{
  "username": "inspector1",
  "email": "inspector1@example.com",
  "fullName": "John Inspector",
  "role": "INSPECTOR",
  "password": "Secure@1234"
}
```

**Validation rules**

| Field | Rules |
|---|---|
| `username` | Required, max 50 chars, alphanumeric + `_ . -` |
| `email` | Required, valid email format, max 100 chars |
| `fullName` | Optional, max 100 chars |
| `role` | Required, one of `ADMIN` \| `INSPECTOR` |
| `password` | Required, 8–100 chars |

**Expected response — 201 Created** — user object with hashed password omitted

**Error responses**

| Status | Condition |
|---|---|
| 400 Bad Request | Validation failure |
| 409 Conflict | Username or email already exists |

---

#### `PUT /api/v1/users/{id}`

Update fullName, email, or username (all optional).

**Request body** (all fields optional)

```json
{
  "fullName": "John Smith",
  "email": "newmail@example.com"
}
```

**Expected response — 200 OK** — updated user object

---

#### `DELETE /api/v1/users/{id}`

**Expected response — 204 No Content**

---

### 4. Warehouses

#### `GET /api/v1/warehouses`

```
GET /api/v1/warehouses
GET /api/v1/warehouses?name=main
```

**Expected response — 200 OK**

```json
[
  {
    "id": 1,
    "code": "WH-001",
    "name": "Main Warehouse",
    "address": "123 Industrial St",
    "createdAt": "2026-08-01T10:00:00Z",
    "updatedAt": "2026-08-01T10:00:00Z"
  }
]
```

---

#### `GET /api/v1/warehouses/{id}`

**Expected response — 200 OK** — single warehouse object

---

#### `POST /api/v1/warehouses`

**Request body**

```json
{
  "code": "WH-001",
  "name": "Main Warehouse",
  "address": "123 Industrial St, City"
}
```

**Validation rules**

| Field | Rules |
|---|---|
| `code` | Required, max 50 chars, must start with alphanumeric |
| `name` | Required, max 100 chars |
| `address` | Optional, 1–255 chars |

**Expected response — 201 Created**

**Error responses**: 400 (validation), 409 (duplicate code)

---

#### `PUT /api/v1/warehouses/{id}`

Only `name` and `address` can be updated (code is immutable).

```json
{
  "name": "Updated Warehouse Name",
  "address": "456 New Street"
}
```

**Expected response — 200 OK**

---

#### `DELETE /api/v1/warehouses/{id}`

Cascades to all locations inside the warehouse.

**Expected response — 204 No Content**

---

### 5. Locations

#### `GET /api/v1/locations`

```
GET /api/v1/locations
GET /api/v1/locations?warehouseId=1
```

**Expected response — 200 OK**

```json
[
  {
    "id": 1,
    "code": "AISLE-A1",
    "description": "First aisle, section A",
    "warehouseId": 1,
    "warehouseCode": "WH-001",
    "createdAt": "2026-08-01T10:00:00Z",
    "updatedAt": "2026-08-01T10:00:00Z"
  }
]
```

---

#### `POST /api/v1/locations`

```json
{
  "code": "AISLE-A1",
  "description": "First aisle, section A",
  "warehouseId": 1
}
```

**Error responses**: 400 (validation), 409 (code+warehouseId not unique), 404 (warehouse not found)

---

#### `PUT /api/v1/locations/{id}` | `DELETE /api/v1/locations/{id}`

Standard update/delete — same patterns as warehouses.

---

### 6. Articles

#### `GET /api/v1/articles`

```
GET /api/v1/articles
GET /api/v1/articles?q=pallet
```

**Expected response — 200 OK**

```json
[
  {
    "id": 1,
    "code": "ART-001",
    "name": "Wooden Pallet",
    "description": "Standard EUR pallet",
    "createdAt": "2026-08-01T10:00:00Z",
    "updatedAt": "2026-08-01T10:00:00Z"
  }
]
```

---

#### `POST /api/v1/articles`

```json
{
  "code": "ART-001",
  "name": "Wooden Pallet",
  "description": "Standard EUR pallet"
}
```

---

### 7. Inspections

#### `GET /api/v1/inspections`

```
GET /api/v1/inspections
GET /api/v1/inspections?warehouseId=1
GET /api/v1/inspections?inspectorId=2
GET /api/v1/inspections?status=PLANNED
GET /api/v1/inspections?warehouseId=1&status=IN_PROGRESS
```

**Expected response — 200 OK**

```json
[
  {
    "id": 1,
    "inspectionCode": "INS-2026-001",
    "warehouseId": 1,
    "warehouseCode": "WH-001",
    "inspectorId": 2,
    "inspectorName": "inspector1",
    "status": "PLANNED",
    "scheduledDate": "2026-09-01",
    "notes": "Annual safety inspection",
    "damageReportCount": 0,
    "createdAt": "2026-08-01T10:00:00Z",
    "updatedAt": "2026-08-01T10:00:00Z"
  }
]
```

---

#### `POST /api/v1/inspections`

```json
{
  "inspectionCode": "INS-2026-001",
  "warehouseId": 1,
  "inspectorId": 2,
  "scheduledDate": "2026-09-01",
  "notes": "Annual safety inspection"
}
```

**Validation rules**

| Field | Rules |
|---|---|
| `inspectionCode` | Required, max 50 chars, alphanumeric + `- _ .` |
| `warehouseId` | Required, must exist |
| `inspectorId` | Required, must exist |
| `scheduledDate` | Required, today or future (`YYYY-MM-DD`) |
| `notes` | Optional, max 500 chars |

**Expected response — 201 Created**

**Error responses**: 400 (validation), 404 (warehouse/inspector not found), 409 (duplicate code)

---

#### `PUT /api/v1/inspections/{id}`

Update status, scheduledDate, or notes.

```json
{
  "status": "IN_PROGRESS",
  "scheduledDate": "2026-09-05",
  "notes": "Rescheduled"
}
```

**Expected response — 200 OK**

---

#### `PATCH /api/v1/inspections/{id}/status`

Lightweight status-only update.

```json
{
  "status": "COMPLETED"
}
```

Valid status values: `PLANNED` → `IN_PROGRESS` → `COMPLETED` | `CANCELLED`

**Expected response — 200 OK**

---

#### `DELETE /api/v1/inspections/{id}`

Cascades to all damage reports of this inspection.

**Expected response — 204 No Content**

---

### 8. Damage Reports

#### `GET /api/v1/damage-reports`

```
GET /api/v1/damage-reports?inspectionId=1
GET /api/v1/damage-reports?articleId=3
```

**Expected response — 200 OK**

```json
[
  {
    "id": 1,
    "inspectionId": 1,
    "inspectionCode": "INS-2026-001",
    "articleId": 3,
    "articleCode": "ART-001",
    "articleName": "Wooden Pallet",
    "locationId": 2,
    "locationCode": "AISLE-A1",
    "severity": "HIGH",
    "description": "Pallet split in half, load-bearing failure",
    "photoUrl": null,
    "createdAt": "2026-08-01T10:00:00Z",
    "updatedAt": "2026-08-01T10:00:00Z"
  }
]
```

---

#### `POST /api/v1/damage-reports`

```json
{
  "inspectionId": 1,
  "articleId": 3,
  "locationId": 2,
  "severity": "HIGH",
  "description": "Pallet split in half, load-bearing failure",
  "photoUrl": "https://storage.example.com/photo-uuid.jpg"
}
```

**Severity values**: `LOW` | `MEDIUM` | `HIGH` | `CRITICAL`

**Expected response — 201 Created**

---

#### `PUT /api/v1/damage-reports/{id}`

```json
{
  "severity": "CRITICAL",
  "description": "Updated: complete structural failure",
  "photoUrl": "https://storage.example.com/updated-photo.jpg"
}
```

---

#### `DELETE /api/v1/damage-reports/{id}`

**Expected response — 204 No Content**

---

## Common Error Response Format

All errors return a consistent JSON structure:

```json
{
  "status": 400,
  "message": "Validation failed",
  "timestamp": "2026-08-01T10:00:00Z",
  "errors": [
    "username: Username is required",
    "password: Password must be at least 8 characters"
  ]
}
```

| Status | Meaning |
|---|---|
| 400 | Validation error or bad request |
| 401 | Missing or invalid JWT |
| 403 | Authenticated but not authorized |
| 404 | Resource not found |
| 409 | Duplicate / conflict |
| 500 | Unexpected server error |

---

## Testing Workflow (Recommended Order)

1. **Health** — `GET /health` to verify the server is up
2. **Create admin user** — `POST /users` (temporarily open the endpoint or use direct DB insert)
3. **Login** — `POST /auth/login`, save the token
4. **Warehouses** — create at least one warehouse
5. **Locations** — create locations inside the warehouse
6. **Articles** — create at least one article
7. **Users** — create an inspector user
8. **Inspections** — create an inspection referencing the warehouse and inspector
9. **Damage Reports** — create damage reports referencing the inspection, article, and location
10. **Status transitions** — `PATCH /inspections/{id}/status` through all states
