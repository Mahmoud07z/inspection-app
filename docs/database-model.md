# Database Model

## User

Represents an authenticated user of the application.

| Field | Type | Description |
|------|------|-------------|
| id | Long | Unique identifier |
| fullName | String | User's full name |
| email | String | Login email |
| password | String | Encrypted password |
| role | Enum | User role (ADMIN or OPERATOR) |

---

## Warehouse

Represents a warehouse where inspections are performed.

| Field | Type | Description |
|------|------|-------------|
| id | Long | Unique identifier |
| name | String | Warehouse name |
| address | String | Warehouse address |

---

## Location

Represents a storage location inside a warehouse.

| Field | Type | Description |
|------|------|-------------|
| id | Long | Unique identifier |
| code | String | Storage location code (e.g. A01, B15) |
| warehouseId | Long | Reference to the warehouse |

---

## Article

Represents a product stored in a warehouse.

| Field | Type | Description |
|------|------|-------------|
| id | Long | Unique identifier |
| code | String | Internal product code |
| designation | String | Product name |
| barcode | String | Barcode or QR code |
| locationId | Long | Storage location |

---

## Inspection

Represents an inventory inspection.

| Field | Type | Description |
|------|------|-------------|
| id | Long | Unique identifier |
| inspectionDate | DateTime | Inspection date |
| quantity | Integer | Quantity found |
| observation | String | Inspector comments |
| status | String | Inspection status |
| articleId | Long | Inspected article |
| inspectorId | Long | User who performed the inspection |

---

## DamageReport

Represents damaged products found during an inspection.

| Field | Type | Description |
|------|------|-------------|
| id | Long | Unique identifier |
| description | String | Damage description |
| quantity | Integer | Damaged quantity |
| photoUrl | String | Photo path |
| inspectionId | Long | Related inspection |

---

# Relationships

- One Warehouse has many Locations.
- One Location contains many Articles.
- One Article can have many Inspections.
- One Inspection can have zero or many Damage Reports.
- One User can perform many Inspections.