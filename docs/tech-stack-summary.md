# FitFlow Recommended Technology Stack

| Layer | Selected Technology | Justification |
|---|---|---|
| Frontend | Flutter (Dart) | Single app-focused codebase for iOS, Android and web with strong performance and consistent UX. |
| Core API | NestJS (TypeScript) | Structured modular backend with validation, RBAC, WebSockets and good maintainability. |
| AI Service | FastAPI (Python) | Direct access to the Python ML ecosystem and independently scalable inference endpoints. |
| Database | Managed PostgreSQL | Relational integrity, advanced SQL, analytics and JSONB flexibility. |
| Authentication | Supabase Auth | JWT/MFA/social login with PostgreSQL RLS integration. |
| Cache | Redis | Reduces database load and improves latency for hot data. |
| Real-time | WebSockets / managed real-time channel | Live workout-plan, progress and social updates. |
| Storage | Object storage | Efficient media storage with signed URLs and lifecycle policies. |

## Main Data Flow

1. Flutter authenticates the user through Supabase Auth.
2. The client sends API requests with a valid JWT to NestJS.
3. NestJS validates the request, applies authorization rules, and reads/writes data in PostgreSQL.
4. Recommendation requests can be sent from NestJS to the FastAPI AI service using a minimized feature set.
5. Redis may cache frequently requested or short-lived data.
6. WebSockets provide live updates and notifications.
7. Object storage holds profile/social media assets using signed URLs.
