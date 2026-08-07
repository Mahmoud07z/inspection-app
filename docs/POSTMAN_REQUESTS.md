# Postman Requests

Base URL: `http://localhost:8090`

All protected endpoints require the header:
```
Authorization: Bearer <token>
```
Get the token from **Step 2 – Login**.

---

## Step 1 – Create First User (no auth required)

**POST** `http://localhost:8090/api/v1/users`

Headers:
```
Content-Type: application/json
```

Body:
```json
{
  "username": "admin",
  "email": "admin@example.com",
  "fullName": "Admin User",
  "role": "ADMIN",
  "password": "Admin1234"
}
```

Expected: `201 Created`
```json
{
  "id": 1,
  "username": "admin",
  "email": "admin@example.com",
  "fullName": "Admin User",
  "role": "ADMIN"
}
```

---

## Step 2 – Login (get JWT token)

**POST** `http://localhost:8090/api/v1/auth/login`

Headers:
```
Content-Type: application/json
```

Body:
```json
{
  "username": "admin",
  "password": "Admin1234"
}
```

Expected: `200 OK`
```json
{
  "token": "eyJhbGci...",
  "type": "Bearer",
  "username": "admin",
  "role": "ADMIN"
}
```

Copy the `token` value and use it as `Bearer <token>` in all requests below.

---

## Users

### GET all users
**GET** `http://localhost:8090/api/v1/users`
Headers: `Authorization: Bearer <token>`

### GET user by ID
**GET** `http://localhost:8090/api/v1/users/1`
Headers: `Authorization: Bearer <token>`

### GET users by role
**GET** `http://localhost:8090/api/v1/users?role=INSPECTOR`
Headers: `Authorization: Bearer <token>`

### PUT update user
**PUT** `http://localhost:8090/api/v1/users/1`
Headers: `Authorization: Bearer <token>`, `Content-Type: application/json`
```json
{
  "fullName": "Updated Name",
  "email": "updated@example.com"
}
```

### DELETE user
**DELETE** `http://localhost:8090/api/v1/users/1`
Headers: `Authorization: Bearer <token>`
Expected: `204 No Content`

---

## Warehouses

### POST create warehouse
**POST** `http://localhost:8090/api/v1/warehouses`
Headers: `Authorization: Bearer <token>`, `Content-Type: application/json`
```json
{
  "code": "WH-001",
  "name": "Main Warehouse",
  "address": "123 Industrial Street"
}
```
Expected: `201 Created`

### GET all warehouses
**GET** `http://localhost:8090/api/v1/warehouses`
Headers: `Authorization: Bearer <token>`

### GET warehouse by ID
**GET** `http://localhost:8090/api/v1/warehouses/1`
Headers: `Authorization: Bearer <token>`

### PUT update warehouse
**PUT** `http://localhost:8090/api/v1/warehouses/1`
Headers: `Authorization: Bearer <token>`, `Content-Type: application/json`
```json
{
  "name": "Updated Warehouse Name",
  "address": "456 New Address"
}
```

### DELETE warehouse
**DELETE** `http://localhost:8090/api/v1/warehouses/1`
Headers: `Authorization: Bearer <token>`
Expected: `204 No Content`

---

## Locations

### POST create location
**POST** `http://localhost:8090/api/v1/locations`
Headers: `Authorization: Bearer <token>`, `Content-Type: application/json`
```json
{
  "code": "AISLE-1",
  "description": "Aisle 1 near entrance",
  "warehouseId": 1
}
```
Expected: `201 Created`

### GET all locations
**GET** `http://localhost:8090/api/v1/locations`
Headers: `Authorization: Bearer <token>`

### GET location by ID
**GET** `http://localhost:8090/api/v1/locations/1`
Headers: `Authorization: Bearer <token>`

### PUT update location
**PUT** `http://localhost:8090/api/v1/locations/1`
Headers: `Authorization: Bearer <token>`, `Content-Type: application/json`
```json
{
  "description": "Updated description"
}
```

### DELETE location
**DELETE** `http://localhost:8090/api/v1/locations/1`
Headers: `Authorization: Bearer <token>`
Expected: `204 No Content`

---

## Articles

### POST create article
**POST** `http://localhost:8090/api/v1/articles`
Headers: `Authorization: Bearer <token>`, `Content-Type: application/json`
```json
{
  "code": "ART-001",
  "name": "Steel Beam",
  "description": "Standard 6m steel beam"
}
```
Expected: `201 Created`

### GET all articles
**GET** `http://localhost:8090/api/v1/articles`
Headers: `Authorization: Bearer <token>`

### GET article by ID
**GET** `http://localhost:8090/api/v1/articles/1`
Headers: `Authorization: Bearer <token>`

### PUT update article
**PUT** `http://localhost:8090/api/v1/articles/1`
Headers: `Authorization: Bearer <token>`, `Content-Type: application/json`
```json
{
  "name": "Updated Steel Beam",
  "description": "Heavy duty 6m steel beam"
}
```

### DELETE article
**DELETE** `http://localhost:8090/api/v1/articles/1`
Headers: `Authorization: Bearer <token>`
Expected: `204 No Content`

---

## Inspections

> Requires a warehouse (ID 1) and an inspector user (ID 1) to exist first.

### POST create inspection
**POST** `http://localhost:8090/api/v1/inspections`
Headers: `Authorization: Bearer <token>`, `Content-Type: application/json`
```json
{
  "inspectionCode": "INS-2026-001",
  "warehouseId": 1,
  "inspectorId": 1,
  "scheduledDate": "2026-09-01",
  "notes": "Monthly routine check"
}
```
Expected: `201 Created`

### GET all inspections
**GET** `http://localhost:8090/api/v1/inspections`
Headers: `Authorization: Bearer <token>`

### GET inspection by ID
**GET** `http://localhost:8090/api/v1/inspections/1`
Headers: `Authorization: Bearer <token>`

### PUT update inspection
**PUT** `http://localhost:8090/api/v1/inspections/1`
Headers: `Authorization: Bearer <token>`, `Content-Type: application/json`
```json
{
  "scheduledDate": "2026-09-15",
  "notes": "Rescheduled",
  "status": "IN_PROGRESS"
}
```

### DELETE inspection
**DELETE** `http://localhost:8090/api/v1/inspections/1`
Headers: `Authorization: Bearer <token>`
Expected: `204 No Content`

---

## Damage Reports

> Requires an inspection (ID 1), article (ID 1), and location (ID 1) to exist first.

### POST create damage report
**POST** `http://localhost:8090/api/v1/damage-reports`
Headers: `Authorization: Bearer <token>`, `Content-Type: application/json`
```json
{
  "inspectionId": 1,
  "articleId": 1,
  "locationId": 1,
  "severity": "HIGH",
  "description": "Large crack found on the beam",
  "photoUrl": "https://example.com/photo1.jpg"
}
```

Severity values: `LOW`, `MEDIUM`, `HIGH`, `CRITICAL`

Expected: `201 Created`

### GET all damage reports
**GET** `http://localhost:8090/api/v1/damage-reports`
Headers: `Authorization: Bearer <token>`

### GET damage report by ID
**GET** `http://localhost:8090/api/v1/damage-reports/1`
Headers: `Authorization: Bearer <token>`

### PUT update damage report
**PUT** `http://localhost:8090/api/v1/damage-reports/1`
Headers: `Authorization: Bearer <token>`, `Content-Type: application/json`
```json
{
  "severity": "CRITICAL",
  "description": "Crack has widened, immediate repair needed"
}
```

### DELETE damage report
**DELETE** `http://localhost:8090/api/v1/damage-reports/1`
Headers: `Authorization: Bearer <token>`
Expected: `204 No Content`

---

## Health Check (no auth)

**GET** `http://localhost:8090/api/v1/health`
Expected: `200 OK`

---

## Testing Order

Run requests in this order to avoid foreign-key errors:

1. POST `/api/v1/users` — create admin user
2. POST `/api/v1/auth/login` — get token
3. POST `/api/v1/warehouses` — create warehouse
4. POST `/api/v1/locations` — create location (needs warehouse ID)
5. POST `/api/v1/articles` — create article
6. POST `/api/v1/inspections` — create inspection (needs warehouse + user IDs)
7. POST `/api/v1/damage-reports` — create damage report (needs inspection + article + location IDs)
8. GET each resource to verify data is stored in PostgreSQL

---

## Start the Backend

```cmd
cd backend\backend
C:\Users\admin\apache-maven-3.9.6\bin\mvn.cmd spring-boot:run
```

Server runs on `http://localhost:8090`.
