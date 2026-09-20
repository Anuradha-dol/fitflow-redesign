# FitFlow Redesign

FitFlow Redesign is a high-level redesign proposal for a cross-platform fitness application. The proposed solution supports workout planning, nutrition tracking, progress monitoring, social features, real-time updates, and personalized AI-assisted recommendations.

> This repository is for **IT3060 Human Computer Interaction – Lab Exercise 05**. It contains the technology evaluation, architecture documentation, and small starter-code placeholders for the selected technologies. It is **not intended to be a complete production application** at this stage.

## Recommended Technology Stack

| Layer | Selected Technology | Purpose |
|---|---|---|
| Frontend | Flutter (Dart) | Cross-platform mobile/web user interface |
| Core API | NestJS (TypeScript) | Business logic, validation, RBAC, REST/WebSocket APIs |
| AI Service | FastAPI (Python) | Personalized recommendation/inference endpoints |
| Database | Managed PostgreSQL | Relational system of record and analytics |
| Authentication | Supabase Auth | JWT-based authentication, MFA/social login support |
| Cache | Redis | Cache hot data and short-lived results |
| Real-time | WebSockets | Live updates and notifications |
| Storage | Object Storage | Profile and social media assets |

## Repository Structure

```text
fitflow-redesign/
├── .github/
│   └── workflows/
│       └── ci.yml
├── frontend/
│   ├── lib/
│   │   └── main.dart
│   ├── pubspec.yaml
│   └── README.md
├── backend/
│   ├── src/
│   │   ├── app.module.ts
│   │   ├── health.controller.ts
│   │   └── main.ts
│   ├── package.json
│   ├── tsconfig.json
│   └── README.md
├── ai-service/
│   ├── main.py
│   ├── requirements.txt
│   └── README.md
├── docs/
│   ├── architecture-diagram.png
│   ├── architecture-decision-record.md
│   ├── comparison-matrix.md
│   └── tech-stack-summary.md
├── .gitignore
└── README.md
```

## Starter Setup

### Frontend
The `frontend/` directory contains a minimal Flutter starter screen only. For a full Flutter project, install Flutter and run `flutter create .` inside the folder, then keep or merge the supplied `lib/main.dart`.

### Backend
The `backend/` directory contains a minimal NestJS starter API with a `/health` endpoint.

```bash
cd backend
npm install
npm run start:dev
```

### AI Service
The `ai-service/` directory contains a minimal FastAPI starter with `/health` and `/recommendation` endpoints.

```bash
cd ai-service
python -m venv .venv
# Windows: .venv\Scripts\activate
# macOS/Linux: source .venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload --port 8001
```

## Documentation

- [Technology Comparison Matrix](docs/comparison-matrix.md)
- [Technology Stack Summary](docs/tech-stack-summary.md)
- [Architecture Decision Record](docs/architecture-decision-record.md)
- [High-Level Architecture Diagram](docs/architecture-diagram.png)

## Security Note

Do **not** commit API keys, database credentials, JWT signing secrets, Supabase service keys, or other private values. Store them in local environment files and GitHub repository/environment secrets.

## Current Status

This repository currently represents the **architecture and technology-evaluation stage**. The included code is intentionally small and demonstrates where Flutter, NestJS, and FastAPI implementation would be placed as development continues.
