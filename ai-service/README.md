# FitFlow Recommendation Service

Selected recommendation service: **FastAPI (Python)**.

This service provides a working recommendation endpoint for the FitFlow prototype. It uses validated input and deterministic rules to return a weekly training structure, focus areas, recovery guidance and safety notes.

## Run

```bash
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
uvicorn main:app --reload --port 8001
```

## Routes

| Method | Route | Purpose |
|---|---|---|
| GET | `/health` | Service health check |
| POST | `/recommendation` | Generate a weekly recommendation |

## Example Request

```json
{
  "goal": "fat-loss",
  "experience_level": "intermediate",
  "available_days": 4,
  "session_minutes": 40,
  "equipment": ["bodyweight", "resistance bands"],
  "limitations": []
}
```

The service intentionally avoids claiming a trained model is included. A future production version can replace the rules with a trained recommender while keeping the same API contract.
