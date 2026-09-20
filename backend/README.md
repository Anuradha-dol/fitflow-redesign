# FitFlow Core API

Selected backend: **NestJS (TypeScript)**.

The core API represents the business layer selected in the lab document. It exposes working REST routes for the main FitFlow workflows and keeps the code ready for later PostgreSQL, Supabase Auth, Redis and WebSocket integration.

## Run

```bash
npm install
npm run build
npm run start:dev
```

The API runs on `http://localhost:3000` by default.

## Routes

| Method | Route | Purpose |
|---|---|---|
| GET | `/health` | Service health and enabled features |
| GET | `/overview` | Dashboard summary |
| GET | `/workouts` | Weekly workout plan |
| GET | `/nutrition` | Meal list and macro totals |
| POST | `/nutrition/meals` | Add a meal to the in-memory tracker |
| POST | `/recommendations` | Create a rules-based training recommendation |
| GET | `/progress` | Progress trend and personal records |
| GET | `/social-feed` | Sample social activity feed |

## Example Request

```bash
curl -X POST http://localhost:3000/recommendations ^
  -H "Content-Type: application/json" ^
  -d "{\"goal\":\"strength\",\"experienceLevel\":\"beginner\",\"availableDays\":4,\"sessionMinutes\":45}"
```

The current implementation uses in-memory sample data so it can run without database credentials. In the full architecture, these routes would enforce JWT authorization, read and write PostgreSQL records, cache selected responses in Redis and publish live updates through WebSockets.
