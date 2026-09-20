# ADR-001: FitFlow Cross-Platform Application Architecture

**Status:** Accepted for Lab Exercise 05 design

## Context

FitFlow requires high-performance iOS/Android/web delivery, personalized workout planning, nutrition tracking, social sharing, real-time updates, and secure fitness/health data handling.

## Decision

Use:

- Flutter for clients
- NestJS for the core API
- FastAPI for AI/ML
- Managed PostgreSQL as the source of truth
- Supabase Auth for identity
- Redis for caching
- Object storage for media
- WebSockets/background jobs for real-time and asynchronous work

## Consequences

Benefits include high code reuse, relational integrity, clear service boundaries, and independent AI scaling.

Trade-offs include learning Dart and operating both TypeScript and Python services.

## Alternatives Considered

- Frontend: React Native, Kotlin Multiplatform, Swift/SwiftUI
- Backend: Go
- Database: MongoDB, Firestore, DynamoDB
- Authentication: Firebase Auth, AWS Cognito, Auth0
