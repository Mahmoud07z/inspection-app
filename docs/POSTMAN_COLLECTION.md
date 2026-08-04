# Postman Collection — Inspection App

## Overview

This document provides step-by-step instructions to recreate the **Inspection App** Postman collection from scratch. The collection covers all 8 resource groups with 40+ requests, collection-level Bearer auth, environment variables, and auto-save scripts.

---

## Step 1 — Create an Environment

1. In Postman, click **Environments → +** (or the gear icon).
2. Name it **Inspection App – Local**.
3. Add the following variables:

| Variable | Initial value | Current value | Notes |
|---|---|---|---|
| `baseUrl` | `http://localhost:8080` | `http://localhost:8080` | Change for staging/prod |
| `token` | *(leave blank)* | *(auto-filled on login)* | |
| `userId` | *(leave blank)* | *(auto-filled)* | |
| `warehouseId` | *(leave blank)* | *(auto-filled)* | |
| `locationId` | *(leave blank)* | *(auto-filled)* | |
| `articleId` | *(leave blank)* | *(auto-filled)* | |
| `inspectionId` | *(leave blank)* | *(auto-filled)* | |
| `damageReportId` | *(leave blank)* | *(auto-filled)* | |

4. Click **Save**.
5. Select **Inspection App – Local** as the active environment (top-right dropdown).

---

## Step 2 — Create the Collection

1. Click **Collections → +**.
2. Name it **Inspection App API**.
3. Under **Authorization** tab, select **Bearer Token** and set Token to `{{token}}`.

> This means every request inherits Bearer auth automatically unless overridden at the request level.

---

## Step 3 — Create Folders

Inside the collection, create these 8 folders (right-click collection → **Add folder**):

1. `🔐 Authentication`
2. `🏥 Health`
3. `👤 Users`
4. `🏭 Warehouses`
5. `📍 Locations`
6. `📦 Articles`
7. `📋 Inspections`
8. `💥 Damage Reports`

---

## Step 4 — Add Requests

### Folder: 🏥 Health

#### GET Health

| Field | Value |
|---|---|
| Method | GET |
| URL | `{{baseUrl}}/api/v1/health` |
| Auth | **No Auth** (override collection auth) |

---

### Folder: 🔐 Authentication

#### POST Login

| Field | Value |
|---|---|
| Method | POST |
| URL | `{{baseUrl}}/api/v1/auth/login` |
| Auth | **No Auth** (override collection auth) |
| Body | raw → JSON |

**Body**:
```json
{
  "username": "admin",
  "password": "Admin@1234"
}
```

**Tests tab** (auto-save token):
```javascript
if (pm.response.code === 200) {
    const data = pm.response.json();
    pm.environment.set("token", data.token);
    console.log("Token saved:", data.token.substring(0, 20) + "...");
}
pm.test("Login successful", () => pm.response.to.have.status(200));
pm.test("Token present", () => pm.expect(pm.response.json().token).to.be.a("string"));
```

---

### Folder: 👤 Users

All requests inherit Bearer auth from the collection.

#### GET All Users

| Field | Value |
|---|---|
| Method | GET |
| URL | `{{baseUrl}}/api/v1/users` |

Add query param `role` (optional): value `INSPECTOR` or `ADMIN`.

---

#### GET User by ID

| Field | Value |
|---|---|
| Method | GET |
| URL | `{{baseUrl}}/api/v1/users/{{userId}}` |

---

#### POST Create User

| Field | Value |
|---|---|
| Method | POST |
| URL | `{{baseUrl}}/api/v1/users` |
| Body | raw → JSON |

```json
{
  "username": "inspector1",
  "email": "inspector1@example.com",
  "fullName": "John Inspector",
  "role": "INSPECTOR",
  "password": "Secure@1234"
}
```

**Tests tab** (auto-save userId):
```javascript
if (pm.response.code === 201) {
    pm.environment.set("userId", pm.response.json().id);
}
pm.test("User created", () => pm.response.to.have.status(201));
```

---

#### PUT Update User

| Field | Value |
|---|---|
| Method | PUT |
| URL | `{{baseUrl}}/api/v1/users/{{userId}}` |
| Body | raw → JSON |

```json
{
  "fullName": "John Updated"
}
```

---

#### DELETE User

| Field | Value |
|---|---|
| Method | DELETE |
| URL | `{{baseUrl}}/api/v1/users/{{userId}}` |

---

### Folder: 🏭 Warehouses

#### GET All Warehouses

```
GET {{baseUrl}}/api/v1/warehouses
```

Optional query param: `name=main`

---

#### GET Warehouse by ID

```
GET {{baseUrl}}/api/v1/warehouses/{{warehouseId}}
```

---

#### POST Create Warehouse

```json
{
  "code": "WH-001",
  "name": "Main Warehouse",
  "address": "123 Industrial Street, City"
}
```

**Tests tab**:
```javascript
if (pm.response.code === 201) {
    pm.environment.set("warehouseId", pm.response.json().id);
}
pm.test("Warehouse created", () => pm.response.to.have.status(201));
```

---

#### PUT Update Warehouse

```json
{
  "name": "Updated Main Warehouse",
  "address": "456 New Street"
}
```

---

#### DELETE Warehouse

```
DELETE {{baseUrl}}/api/v1/warehouses/{{warehouseId}}
```

---

### Folder: 📍 Locations

#### GET All Locations (filtered by warehouse)

```
GET {{baseUrl}}/api/v1/locations?warehouseId={{warehouseId}}
```

---

#### GET Location by ID

```
GET {{baseUrl}}/api/v1/locations/{{locationId}}
```

---

#### POST Create Location

```json
{
  "code": "AISLE-A1",
  "description": "First aisle, section A",
  "warehouseId": "{{warehouseId}}"
}
```

> Note: `warehouseId` must be a number. If using the env var, Postman sends it as a string — use a **Pre-request Script** to cast:
> ```javascript
> pm.variables.set("warehouseIdInt", parseInt(pm.environment.get("warehouseId")));
> ```
> Then use `{{warehouseIdInt}}` in the body.

**Tests tab**:
```javascript
if (pm.response.code === 201) {
    pm.environment.set("locationId", pm.response.json().id);
}
```

---

#### PUT Update Location

```json
{
  "code": "AISLE-A2",
  "description": "Updated description"
}
```

---

#### DELETE Location

```
DELETE {{baseUrl}}/api/v1/locations/{{locationId}}
```

---

### Folder: 📦 Articles

#### GET All Articles

```
GET {{baseUrl}}/api/v1/articles
GET {{baseUrl}}/api/v1/articles?q=pallet
```

---

#### POST Create Article

```json
{
  "code": "ART-001",
  "name": "Wooden Pallet",
  "description": "Standard EUR 120×80cm wooden pallet"
}
```

**Tests tab**:
```javascript
if (pm.response.code === 201) {
    pm.environment.set("articleId", pm.response.json().id);
}
```

---

#### PUT Update Article

```json
{
  "name": "Wooden Pallet (Standard)",
  "description": "Updated description"
}
```

---

### Folder: 📋 Inspections

#### GET All Inspections

```
GET {{baseUrl}}/api/v1/inspections
GET {{baseUrl}}/api/v1/inspections?status=PLANNED
GET {{baseUrl}}/api/v1/inspections?warehouseId={{warehouseId}}
GET {{baseUrl}}/api/v1/inspections?warehouseId={{warehouseId}}&status=IN_PROGRESS
```

---

#### GET Inspection by ID

```
GET {{baseUrl}}/api/v1/inspections/{{inspectionId}}
```

---

#### POST Create Inspection

**Pre-request Script** (cast env vars to numbers):
```javascript
pm.variables.set("warehouseIdInt", parseInt(pm.environment.get("warehouseId")));
pm.variables.set("inspectorIdInt", parseInt(pm.environment.get("userId")));
```

**Body**:
```json
{
  "inspectionCode": "INS-2026-001",
  "warehouseId": {{warehouseIdInt}},
  "inspectorId": {{inspectorIdInt}},
  "scheduledDate": "2026-09-15",
  "notes": "Annual safety inspection — full walkthrough"
}
```

**Tests tab**:
```javascript
if (pm.response.code === 201) {
    pm.environment.set("inspectionId", pm.response.json().id);
}
pm.test("Inspection created", () => pm.response.to.have.status(201));
pm.test("Status is PLANNED", () => pm.expect(pm.response.json().status).to.equal("PLANNED"));
```

---

#### PUT Update Inspection

```json
{
  "notes": "Rescheduled — moved to October",
  "scheduledDate": "2026-10-01"
}
```

---

#### PATCH Update Status

```
PATCH {{baseUrl}}/api/v1/inspections/{{inspectionId}}/status
```

```json
{
  "status": "IN_PROGRESS"
}
```

**Tests tab** (verify transition):
```javascript
pm.test("Status updated", () => pm.expect(pm.response.json().status).to.equal("IN_PROGRESS"));
```

Repeat with `"status": "COMPLETED"` to close the inspection.

---

#### DELETE Inspection

```
DELETE {{baseUrl}}/api/v1/inspections/{{inspectionId}}
```

---

### Folder: 💥 Damage Reports

#### GET Reports by Inspection

```
GET {{baseUrl}}/api/v1/damage-reports?inspectionId={{inspectionId}}
```

---

#### GET Report by ID

```
GET {{baseUrl}}/api/v1/damage-reports/{{damageReportId}}
```

---

#### POST Create Damage Report

**Pre-request Script**:
```javascript
pm.variables.set("inspectionIdInt", parseInt(pm.environment.get("inspectionId")));
pm.variables.set("articleIdInt",    parseInt(pm.environment.get("articleId")));
pm.variables.set("locationIdInt",   parseInt(pm.environment.get("locationId")));
```

**Body**:
```json
{
  "inspectionId": {{inspectionIdInt}},
  "articleId":    {{articleIdInt}},
  "locationId":   {{locationIdInt}},
  "severity": "HIGH",
  "description": "Pallet split in half, complete load-bearing failure observed",
  "photoUrl": null
}
```

**Tests tab**:
```javascript
if (pm.response.code === 201) {
    pm.environment.set("damageReportId", pm.response.json().id);
}
pm.test("Report created", () => pm.response.to.have.status(201));
```

---

#### PUT Update Damage Report

```json
{
  "severity": "CRITICAL",
  "description": "Full structural collapse — area cordoned off"
}
```

---

#### DELETE Damage Report

```
DELETE {{baseUrl}}/api/v1/damage-reports/{{damageReportId}}
```

---

## Step 5 — Recommended Testing Workflow

Run requests in this order on a fresh database:

```
1.  GET  /health                            ← verify server up
2.  POST /auth/login                        ← get token (auto-saved)
3.  POST /users         (create inspector)  ← userId auto-saved
4.  POST /warehouses    (create WH-001)     ← warehouseId auto-saved
5.  POST /locations     (create AISLE-A1)   ← locationId auto-saved
6.  POST /articles      (create ART-001)    ← articleId auto-saved
7.  POST /inspections   (create INS-001)    ← inspectionId auto-saved
8.  PATCH /inspections/{{id}}/status        ← set IN_PROGRESS
9.  POST /damage-reports (create report)    ← damageReportId auto-saved
10. GET  /inspections/{{id}}                ← verify damageReportCount = 1
11. PATCH /inspections/{{id}}/status        ← set COMPLETED
12. GET  /inspections?status=COMPLETED      ← filter test
```

---

## Step 6 — Export and Share

Once all requests are created:

1. Right-click the collection → **Export**.
2. Choose **Collection v2.1**.
3. Save as `docs/InspectionApp.postman_collection.json`.
4. Teammates import it via **Import → Upload Files**.
5. They must also import or recreate the **Inspection App – Local** environment.

---

## Authorization Quick Reference

| Request | Auth method |
|---|---|
| GET `/health` | None |
| POST `/auth/login` | None |
| All other endpoints | Bearer `{{token}}` (inherited from collection) |

The token expires after **24 hours** (configurable via `app.jwt.expiration-ms`). Re-run the login request to refresh it.
