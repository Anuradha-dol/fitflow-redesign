from typing import List

from fastapi import FastAPI
from pydantic import BaseModel, Field

app = FastAPI(title="FitFlow AI Service", version="0.1.0")


class RecommendationRequest(BaseModel):
    goal: str = Field(..., examples=["strength"])
    experience_level: str = Field(..., examples=["beginner"])
    available_days: int = Field(..., ge=1, le=7)


class RecommendationResponse(BaseModel):
    message: str
    suggested_focus: List[str]


@app.get("/health")
def health():
    return {"service": "fitflow-ai-service", "status": "ok"}


@app.post("/recommendation", response_model=RecommendationResponse)
def create_recommendation(payload: RecommendationRequest):
    # Lab placeholder only. A trained recommendation model can replace this logic later.
    return RecommendationResponse(
        message=(
            f"Starter recommendation for a {payload.experience_level} user "
            f"with the goal '{payload.goal}' and {payload.available_days} training days."
        ),
        suggested_focus=["full-body strength", "mobility", "recovery"],
    )
