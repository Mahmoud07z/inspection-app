# REST API List

## Authentication

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/auth/login | Authenticate a user |
| POST | /api/auth/register | Register a new user |

---

## Users

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/users | Get all users |
| GET | /api/users/{id} | Get user by ID |
| POST | /api/users | Create a user |
| PUT | /api/users/{id} | Update a user |
| DELETE | /api/users/{id} | Delete a user |

---

## Warehouses

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/warehouses | Get all warehouses |
| GET | /api/warehouses/{id} | Get warehouse by ID |
| POST | /api/warehouses | Create warehouse |
| PUT | /api/warehouses/{id} | Update warehouse |
| DELETE | /api/warehouses/{id} | Delete warehouse |

---

## Locations

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/locations | Get all locations |
| GET | /api/locations/{id} | Get location by ID |
| POST | /api/locations | Create location |
| PUT | /api/locations/{id} | Update location |
| DELETE | /api/locations/{id} | Delete location |

---

## Articles

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/articles | Get all articles |
| GET | /api/articles/{id} | Get article by ID |
| GET | /api/articles/barcode/{barcode} | Find article by barcode |
| POST | /api/articles | Create article |
| PUT | /api/articles/{id} | Update article |
| DELETE | /api/articles/{id} | Delete article |

---

## Inspections

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/inspections | Get all inspections |
| GET | /api/inspections/{id} | Get inspection by ID |
| POST | /api/inspections | Create a new inspection |
| PUT | /api/inspections/{id} | Update inspection |
| DELETE | /api/inspections/{id} | Delete inspection |

---

## Damage Reports

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/damage-reports | Get all damage reports |
| GET | /api/damage-reports/{id} | Get damage report by ID |
| POST | /api/damage-reports | Create damage report |
| PUT | /api/damage-reports/{id} | Update damage report |
| DELETE | /api/damage-reports/{id} | Delete damage report |

---

## Photo Upload

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/photos/upload | Upload damage photo |