from enum import Enum
from typing import List

from fastapi import FastAPI
from pydantic import BaseModel, Field, field_validator


app = FastAPI(
    title="FitFlow Recommendation Service",
    version="1.0.0",
    description="Rules-based recommendation service for the FitFlow redesign prototype.",
)


class Goal(str, Enum):
    strength = "strength"
    fat_loss = "fat-loss"
    endurance = "endurance"
    mobility = "mobility"


class ExperienceLevel(str, Enum):
    beginner = "beginner"
    intermediate = "intermediate"
    advanced = "advanced"


class RecommendationRequest(BaseModel):
    goal: Goal = Field(default=Goal.strength)
    experience_level: ExperienceLevel = Field(default=ExperienceLevel.beginner)
    available_days: int = Field(default=3, ge=1, le=7)
    session_minutes: int = Field(default=45, ge=15, le=120)
    equipment: List[str] = Field(default_factory=lambda: ["bodyweight", "dumbbells"])
    limitations: List[str] = Field(default_factory=list)

    @field_validator("equipment", "limitations")
    @classmethod
    def remove_blank_values(cls, values: List[str]) -> List[str]:
        return [value.strip() for value in values if value.strip()]


class PlanDay(BaseModel):
    day_number: int
    focus: str
    duration_minutes: int
    equipment: str
    notes: str


class RecommendationResponse(BaseModel):
    message: str
    suggested_focus: List[str]
    weekly_structure: List[PlanDay]
    recovery_guidance: str
    safety_notes: List[str]


FOCUS_LIBRARY = {
    Goal.strength: [
        "compound strength",
        "upper-body push and pull",
        "lower-body strength",
        "core stability",
    ],
    Goal.fat_loss: [
        "full-body strength circuit",
        "zone 2 cardio",
        "metabolic conditioning",
        "mobility recovery",
    ],
    Goal.endurance: [
        "aerobic base",
        "tempo intervals",
        "easy recovery session",
        "long steady effort",
    ],
    Goal.mobility: [
        "hips and hamstrings",
        "thoracic rotation",
        "shoulder control",
        "breathing and recovery",
    ],
}


@app.get("/health")
def health():
    return {
        "service": "fitflow-recommendation-service",
        "status": "ok",
        "model": "rules-based-v1",
    }


@app.post("/recommendation", response_model=RecommendationResponse)
def create_recommendation(payload: RecommendationRequest):
    focus_options = FOCUS_LIBRARY[payload.goal]
    equipment = payload.equipment or ["bodyweight"]
    suggested_focus = focus_options[: min(3, len(focus_options))]

    weekly_structure = [
        PlanDay(
            day_number=day + 1,
            focus=focus_options[day % len(focus_options)],
            duration_minutes=payload.session_minutes,
            equipment=equipment[day % len(equipment)],
            notes=build_day_note(payload, day),
        )
        for day in range(payload.available_days)
    ]

    recovery_days = 2 if payload.experience_level == ExperienceLevel.beginner else 1
    if payload.available_days <= 3:
        recovery_days = 3

    return RecommendationResponse(
        message=(
            f"{payload.available_days}-day {payload.goal.value} plan for a "
            f"{payload.experience_level.value} member."
        ),
        suggested_focus=suggested_focus,
        weekly_structure=weekly_structure,
        recovery_guidance=(
            f"Keep at least {recovery_days} recovery day"
            f"{'' if recovery_days == 1 else 's'} with sleep, hydration and light mobility."
        ),
        safety_notes=[
            "Warm up before each session.",
            "Use controlled form before adding load or speed.",
            "Stop training and seek professional advice if pain or unusual symptoms appear.",
        ],
    )


def build_day_note(payload: RecommendationRequest, day_index: int) -> str:
    if payload.limitations:
        limitation_text = ", ".join(payload.limitations)
        return f"Adapt volume around: {limitation_text}."

    if payload.experience_level == ExperienceLevel.beginner:
        return "Use conservative loads and leave two reps in reserve."

    if day_index == payload.available_days - 1:
        return "Finish with mobility work and an easy cooldown."

    return "Track effort level and increase gradually week by week."
