# Application Architecture

The Inspection App follows a three-tier architecture.

## Mobile Layer

The Flutter mobile application provides the user interface. It allows warehouse operators to authenticate, scan products, perform inspections, report damages, and synchronize data with the backend.

## Backend Layer

The backend is developed using Spring Boot and follows a layered architecture:

- Controller: Handles HTTP requests and responses.
- Service: Contains the business logic.
- Repository: Manages database access using Spring Data JPA.

## Database Layer

PostgreSQL stores all application data, including users, warehouses, locations, articles, inspections, and damage reports.

## Communication

The Flutter application communicates with the backend through secure REST APIs over HTTPS. The backend interacts with PostgreSQL using Spring Data JPA and Hibernate.