# FitFlow Redesign

FitFlow Redesign is the Lab Exercise 05 technology evaluation and prototype for a cross-platform fitness application. The repository keeps the selected architecture from the document and includes working sample code for the main client, API and recommendation-service workflows.

The prototype covers:

- dashboard summary for workouts, calories, water and streaks
- weekly workout planning
- local nutrition logging in the Flutter client
- NestJS REST endpoints for dashboard, workouts, nutrition, progress, social feed and recommendations
- FastAPI recommendation endpoint with input validation and rules-based weekly plan output
- documentation for the technology comparison, architecture decision and stack summary

## Selected Technology Stack

| Layer | Selected Technology | Purpose |
|---|---|---|
| Frontend | Flutter (Dart) | Cross-platform mobile and web user interface |
| Core API | NestJS (TypeScript) | Business workflows, validation, RBAC-ready API layer and real-time-ready service boundary |
| Recommendation Service | FastAPI (Python) | Independently scalable recommendation/inference endpoint |
| Database | Managed PostgreSQL | Relational source of truth for users, workouts, plans, meals, goals and social data |
| Authentication | Supabase Auth | JWT-based authentication with MFA/social-login support and PostgreSQL RLS integration |
| Cache | Redis | Cache hot data and short-lived recommendation results |
| Real-time | WebSockets | Live progress, workout and social updates |
| Storage | Object Storage | Profile images and social media assets through signed URLs |

## Repository Structure

```text
fitflow-redesign/
|-- .github/
|   `-- workflows/
|       `-- ci.yml
|-- frontend/
|   |-- lib/
|   |   `-- main.dart
|   |-- pubspec.yaml
|   `-- README.md
|-- backend/
|   |-- src/
|   |   |-- app.module.ts
|   |   |-- fitflow.controller.ts
|   |   |-- fitflow.service.ts
|   |   |-- health.controller.ts
|   |   `-- main.ts
|   |-- package.json
|   |-- tsconfig.json
|   `-- README.md
|-- ai-service/
|   |-- main.py
|   |-- requirements.txt
|   `-- README.md
|-- docs/
|   |-- architecture-diagram.png
|   |-- architecture-decision-record.md
|   |-- comparison-matrix.md
|   `-- tech-stack-summary.md
|-- .gitignore
`-- README.md
```

## Run Locally

### Frontend

```bash
cd frontend
flutter pub get
flutter run -d chrome
```

### Backend

```bash
cd backend
npm install
npm run build
npm run start:dev
```

Useful backend routes:

- `GET /health`
- `GET /overview`
- `GET /workouts`
- `GET /nutrition`
- `POST /nutrition/meals`
- `POST /recommendations`
- `GET /progress`
- `GET /social-feed`

### Recommendation Service

```bash
cd ai-service
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
uvicorn main:app --reload --port 8001
```

Useful service routes:

- `GET /health`
- `POST /recommendation`

Example recommendation request:

```json
{
  "goal": "strength",
  "experience_level": "beginner",
  "available_days": 4,
  "session_minutes": 45,
  "equipment": ["bodyweight", "dumbbells"]
}
```

## Documentation

- [Technology Comparison Matrix](docs/comparison-matrix.md)
- [Technology Stack Summary](docs/tech-stack-summary.md)
- [Architecture Decision Record](docs/architecture-decision-record.md)
- [High-Level Architecture Diagram](docs/architecture-diagram.png)

## Security Note

Do not commit API keys, database credentials, JWT signing secrets, Supabase service keys or other private values. Keep them in local environment files and GitHub repository/environment secrets.

## Current Status

This repository is a working lab prototype, not a production release. PostgreSQL, Supabase Auth, Redis, object storage and WebSockets are documented as the selected architecture and are represented by clean service boundaries and sample data until those external services are provisioned.
