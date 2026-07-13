# Application Mobile d'Inspection d'Entrepot

> Stage de developpement - Encadrant : **Bader-Eddine Rachidy**

## Description

Application mobile permettant aux operateurs d'entrepot de realiser des inspections de stock et des controles qualite directement depuis un smartphone.

## Fonctionnalites

- Authentification securisee (JWT)
- Consultation des entrepots et emplacements
- Scan de QR Code et Code-Barres
- Creation d'inspections (quantite, observations, photos)
- Declaration d'anomalies / produits endommages
- Synchronisation avec le serveur
- Mode hors-ligne

## Stack Technique

| Couche | Technologie |
|---|---|
| Backend | Java 21 + Spring Boot + Spring Security + Spring Data JPA |
| Base de donnees | PostgreSQL |
| Mobile | Flutter (Dart) |
| Auth | JWT |
| Documentation API | Swagger / OpenAPI |
| Versioning | Git / GitHub |

## Architecture

```
Application Flutter
       |
API REST Spring Boot  (Controller -> Service -> Repository)
       |
   PostgreSQL
```

## Structure du Projet

```
inspection-app/
|-- backend/          # Projet Spring Boot
|-- mobile/           # Projet Flutter
|-- docs/
    |-- db-model.md   # Modele de donnees (ERD)
    |-- api-list.md   # Liste des endpoints API
    |-- uml/          # Diagrammes UML
```

## Installation

### Prerequis
- Java 21
- Maven
- PostgreSQL 15+
- Flutter SDK 3.x
- Git

### Backend

```bash
cd backend
mvn spring-boot:run
```

### Mobile

```bash
cd mobile
flutter pub get
flutter run
```

## Planning (6 semaines)

| Semaine | Focus |
|---|---|
| S1 | Analyse & Conception (UML, DB, API) |
| S2 | Developpement Backend (JWT, Swagger) |
| S3 | Modules Metier (CRUD, Postman) |
| S4 | Developpement Mobile (Flutter, Auth) |
| S5 | Fonctionnalites Avancees (Scanner, Photos) |
| S6 | Finalisation & Presentation |

## Bonnes Pratiques Git

- Committer au moins **1 fois par jour**
- Messages de commit clairs : `feat:`, `fix:`, `docs:`, `refactor:`
- Ne jamais committer de fichiers sensibles (mots de passe, cles API)

---
*Projet de stage - Application d'inspection d'entrepot*
