# FitFlow Frontend

Selected frontend: **Flutter (Dart)**.

The Flutter client is a working prototype for the FitFlow redesign. It includes dashboard, workout plan, nutrition, progress and community views that match the lab architecture.

## Run

```bash
flutter pub get
flutter run -d chrome
```

## Included Views

- Dashboard summary for training, calories, water and streaks
- Weekly workout plan with intensity and exercise details
- Nutrition tracker with local meal entry
- Progress view for adherence, body weight, training minutes and records
- Community feed for lightweight social sharing

The screen data is local sample data so the app can run without external credentials. The same workflows are exposed through the NestJS API for backend integration.
