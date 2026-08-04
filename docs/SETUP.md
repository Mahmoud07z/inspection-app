# Inspection App — Setup Guide

## Requirements

### Backend

| Requirement | Minimum version |
|---|---|
| JDK | 25 (Eclipse Temurin recommended) |
| Maven | 3.9.x (or use included wrapper) |
| PostgreSQL | 15+ |
| Git | Any recent version |

### Mobile

| Requirement | Minimum version |
|---|---|
| Flutter SDK | 3.4.0 |
| Dart SDK | 3.4.0 (bundled with Flutter) |
| Android Studio / Xcode | Latest stable |
| Android emulator or iOS simulator | API 26+ / iOS 13+ |

---

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/Mahmoud07z/inspection-app.git
cd inspection-app
git checkout mahmoud
```

### 2. Backend setup

```bash
cd backend/backend
```

#### Install JDK 25

Download from [Adoptium](https://adoptium.net/temurin/releases/) and install.  
Verify:

```bash
java -version
# Expected: openjdk version "25" ...
```

#### Set JAVA_HOME

**Windows (PowerShell)**:

```powershell
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-25.0.3.9-hotspot"
```

**macOS/Linux (bash/zsh)**:

```bash
export JAVA_HOME=/path/to/jdk-25
```

#### Install PostgreSQL

1. Download from [postgresql.org](https://www.postgresql.org/download/) or via package manager.
2. Start the PostgreSQL service.
3. Create the database:

```sql
CREATE DATABASE inspection_db;
CREATE USER inspection_user WITH PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE inspection_db TO inspection_user;
```

#### Configure environment variables

Copy the template and fill in your values:

```bash
# In backend/backend/src/main/resources/application.properties
# You can override any property via environment variables or a .env file
```

Required variables (see [Environment Variables](#environment-variables) below).

### 3. Flutter setup

```bash
cd mobile/mobile
flutter pub get
```

Verify:

```bash
flutter doctor
# All required checks should be green
```

---

## Environment Variables

### Backend (`src/main/resources/application.properties`)

```properties
# Database
spring.datasource.url=${DB_URL:jdbc:postgresql://localhost:5432/inspection_db}
spring.datasource.username=${DB_USER:postgres}
spring.datasource.password=${DB_PASSWORD:postgres}

# HikariCP connection pool
spring.datasource.hikari.maximum-pool-size=10
spring.datasource.hikari.minimum-idle=2
spring.datasource.hikari.connection-timeout=30000

# JPA / Hibernate
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=false
spring.jpa.open-in-view=false

# JWT
app.jwt.secret=${JWT_SECRET:YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXowMTIzNDU2Nzg5QUJDREVGR0hJSktM}
app.jwt.expiration-ms=${JWT_EXPIRATION_MS:86400000}
```

> **Security note**: Never commit real secrets. Use environment variables or a secrets manager in production. The `JWT_SECRET` must be at least 32 bytes (256 bits) when Base64-decoded.

### Mobile

The API base URL is set as a compile-time constant:

```dart
// lib/core/constants/api_constants.dart
static const String baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:8080', // Android emulator → host localhost
);
```

Override at build time:

```bash
# Android emulator (default)
flutter run

# iOS simulator
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8080

# Physical device / staging
flutter run --dart-define=API_BASE_URL=https://api.your-domain.com
```

---

## Database Setup

### Development (auto-managed)

With `spring.jpa.hibernate.ddl-auto=update`, Hibernate creates and migrates the schema automatically on first startup. No manual SQL needed.

### Reset the database

```sql
DROP DATABASE inspection_db;
CREATE DATABASE inspection_db;
```

Then restart the backend — Hibernate recreates all tables.

### Seed data (manual)

There is no seed script. Use the REST API to create the first admin user:

```bash
# Create the first user directly via the API (if you temporarily permit POST /users without auth in SecurityConfig)
curl -X POST http://localhost:8080/api/v1/users \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","email":"admin@example.com","fullName":"Admin User","role":"ADMIN","password":"Admin@1234"}'
```

Then use `POST /api/v1/auth/login` to obtain a JWT for all subsequent requests.

---

## How to Run the Backend

### Using the installed Maven

```bash
cd backend/backend
JAVA_HOME="/path/to/jdk-25" \
  /path/to/maven/bin/mvn spring-boot:run
```

**Windows (PowerShell)**:

```powershell
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-25.0.3.9-hotspot"
C:\Users\admin\.maven\maven-3.10.0-rc-1\bin\mvn spring-boot:run
```

The API starts at `http://localhost:8080`.

### Run tests only

```bash
JAVA_HOME="/path/to/jdk-25" mvn clean test
```

### Build a JAR

```bash
JAVA_HOME="/path/to/jdk-25" mvn clean package -DskipTests
java -jar target/backend-0.0.1-SNAPSHOT.jar
```

---

## How to Run the Flutter App

### Prerequisites

- A running backend (see above)
- Android emulator or iOS simulator connected

### Start the app

```bash
cd mobile/mobile

# List available devices
flutter devices

# Run on Android emulator (uses 10.0.2.2 for localhost by default)
flutter run

# Run on iOS simulator
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8080

# Run on a specific device
flutter run -d <device-id>
```

### Build a release APK

```bash
flutter build apk --release --dart-define=API_BASE_URL=https://api.your-domain.com
```

---

## Common Troubleshooting

### Backend won't start — `UnsatisfiedDependencyException`

**Symptom**: Spring fails to inject `PasswordEncoder` or `AuthenticationManager`.  
**Fix**: Ensure `SecurityConfig.java` is up to date — it must declare both `@Bean` methods. Pull latest from the `mahmoud` branch.

### `io.jsonwebtoken` packages not found

**Symptom**: Compilation error: `package io.jsonwebtoken does not exist`.  
**Fix**: The JJWT dependency was missing. Run:

```bash
mvn dependency:resolve
```

If still missing, check `pom.xml` for these entries:

```xml
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.12.6</version>
</dependency>
```

### Hibernate `AnnotationException` — mappedBy mismatch

**Symptom**: `Collection 'User.inspections' is 'mappedBy' a property named 'inspector' which does not exist`.  
**Fix**: The `Inspection` entity must have a `@ManyToOne User inspector` field. Pull latest from `mahmoud` branch.

### 401 on all endpoints (even after login)

**Symptom**: Every request returns 401.  
**Fix**: The JWT filter must be registered in `SecurityConfig`. Ensure `addFilterBefore(jwtAuthenticationFilter, ...)` is present.

### Flutter: `Connection refused` on emulator

**Symptom**: Dio throws `DioException: Connection refused`.  
**Fix**: Use `10.0.2.2` (not `localhost` or `127.0.0.1`) on Android emulators. For iOS simulators use `127.0.0.1`.

### Flutter: merge conflict markers in source files

**Symptom**: Dart analyser shows `<<<<<<< HEAD` as unexpected tokens.  
**Fix**:

```bash
cd mobile/mobile
git checkout -- lib/   # discard local changes and use the branch version
flutter pub get
```

### PostgreSQL connection refused

**Symptom**: `HikariPool-1 - Connection is not available`.  
**Fix**:
1. Verify PostgreSQL is running: `pg_isready -h localhost -p 5432`
2. Check credentials in `application.properties`
3. Confirm the database exists: `\l` in `psql`

### `flutter pub get` fails — SDK constraint

**Symptom**: `The current Dart SDK version is X.X.X. Because ... requires SDK >=3.4.0`.  
**Fix**: Upgrade Flutter: `flutter upgrade`
