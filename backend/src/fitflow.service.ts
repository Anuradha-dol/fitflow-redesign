import { BadRequestException, Injectable } from '@nestjs/common';

type Goal = 'strength' | 'fat-loss' | 'endurance' | 'mobility';
type ExperienceLevel = 'beginner' | 'intermediate' | 'advanced';

interface WorkoutSession {
  day: string;
  title: string;
  focus: string;
  durationMinutes: number;
  intensity: 'Low' | 'Moderate' | 'High';
  exercises: string[];
}

interface MealEntry {
  id: number;
  name: string;
  calories: number;
  protein: number;
  carbs: number;
  fat: number;
}

const GOALS: Goal[] = ['strength', 'fat-loss', 'endurance', 'mobility'];
const EXPERIENCE_LEVELS: ExperienceLevel[] = [
  'beginner',
  'intermediate',
  'advanced',
];

@Injectable()
export class FitFlowService {
  private readonly weeklyPlan: WorkoutSession[] = [
    {
      day: 'Monday',
      title: 'Full-body strength',
      focus: 'Compound lifting and core stability',
      durationMinutes: 45,
      intensity: 'High',
      exercises: ['Goblet squat', 'Push-up', 'Dumbbell row', 'Plank'],
    },
    {
      day: 'Wednesday',
      title: 'Zone 2 cardio',
      focus: 'Aerobic base and recovery',
      durationMinutes: 35,
      intensity: 'Moderate',
      exercises: ['Incline walk', 'Bike intervals', 'Hip mobility'],
    },
    {
      day: 'Friday',
      title: 'Lower-body power',
      focus: 'Glutes, hamstrings and balance',
      durationMinutes: 50,
      intensity: 'High',
      exercises: ['Romanian deadlift', 'Split squat', 'Calf raise', 'Side plank'],
    },
    {
      day: 'Sunday',
      title: 'Mobility reset',
      focus: 'Flexibility and joint control',
      durationMinutes: 25,
      intensity: 'Low',
      exercises: ['World greatest stretch', 'Thoracic rotation', 'Breathing drill'],
    },
  ];

  private mealId = 4;

  private readonly meals: MealEntry[] = [
    {
      id: 1,
      name: 'Oats, banana and whey',
      calories: 430,
      protein: 34,
      carbs: 58,
      fat: 8,
    },
    {
      id: 2,
      name: 'Chicken rice bowl',
      calories: 620,
      protein: 48,
      carbs: 74,
      fat: 14,
    },
    {
      id: 3,
      name: 'Greek yogurt with berries',
      calories: 210,
      protein: 22,
      carbs: 24,
      fat: 4,
    },
  ];

  getOverview() {
    return {
      user: {
        name: 'Maduvinda',
        goal: 'Build lean strength while improving consistency',
        weeklyTargetSessions: 4,
      },
      today: {
        calories: this.getNutritionTotals().calories,
        caloriesTarget: 2300,
        waterLitres: 2.1,
        waterTargetLitres: 3,
        nextWorkout: this.weeklyPlan[0],
      },
      progress: {
        workoutAdherencePercent: 86,
        bodyWeightKg: 72.4,
        weeklyTrainingMinutes: this.weeklyPlan.reduce(
          (total, item) => total + item.durationMinutes,
          0,
        ),
      },
      recentSocialActivity: [
        {
          author: 'Kasun',
          message: 'Finished a 5 km recovery run.',
          reactions: 12,
        },
        {
          author: 'Nethmi',
          message: 'Shared a high-protein lunch idea.',
          reactions: 8,
        },
      ],
    };
  }

  getWeeklyPlan() {
    return {
      selectedTechnology: 'Flutter client, NestJS API and FastAPI AI service',
      sessions: this.weeklyPlan,
    };
  }

  getNutritionSummary() {
    return {
      target: {
        calories: 2300,
        protein: 150,
        carbs: 250,
        fat: 70,
      },
      totals: this.getNutritionTotals(),
      meals: this.meals,
    };
  }

  addMeal(payload: Record<string, unknown>) {
    const name = typeof payload.name === 'string' ? payload.name.trim() : '';
    const calories = this.toNumber(payload.calories);
    const protein = this.toNumber(payload.protein ?? 0);
    const carbs = this.toNumber(payload.carbs ?? 0);
    const fat = this.toNumber(payload.fat ?? 0);

    if (!name) {
      throw new BadRequestException('Meal name is required.');
    }

    if (!this.isPositiveNumber(calories)) {
      throw new BadRequestException('Calories must be a positive number.');
    }

    for (const [label, value] of Object.entries({ protein, carbs, fat })) {
      if (!Number.isFinite(value) || value < 0) {
        throw new BadRequestException(`${label} must be zero or greater.`);
      }
    }

    const meal: MealEntry = {
      id: this.mealId++,
      name,
      calories,
      protein,
      carbs,
      fat,
    };

    this.meals.push(meal);

    return {
      meal,
      nutrition: this.getNutritionSummary(),
    };
  }

  createRecommendation(payload: Record<string, unknown>) {
    const goal = this.normalizeGoal(payload.goal);
    const experienceLevel = this.normalizeExperience(payload.experienceLevel);
    const availableDays = this.normalizeDays(payload.availableDays);
    const sessionMinutes = this.normalizeSessionMinutes(payload.sessionMinutes);
    const equipment = this.normalizeEquipment(payload.equipment);
    const selectedEquipment = equipment.length
      ? equipment
      : ['bodyweight', 'dumbbells'];

    const focusByGoal: Record<Goal, string[]> = {
      strength: ['progressive overload', 'compound strength', 'core bracing'],
      'fat-loss': ['full-body circuits', 'zone 2 cardio', 'protein target'],
      endurance: ['aerobic base', 'tempo intervals', 'recovery pacing'],
      mobility: ['joint control', 'flexibility', 'movement quality'],
    };

    const recoveryDays =
      experienceLevel === 'beginner' ? 2 : availableDays >= 5 ? 1 : 2;

    return {
      inputs: {
        goal,
        experienceLevel,
        availableDays,
        sessionMinutes,
        equipment: selectedEquipment,
      },
      summary: `A ${availableDays}-day ${goal} plan for a ${experienceLevel} member.`,
      weeklyStructure: Array.from({ length: availableDays }, (_, index) => ({
        dayNumber: index + 1,
        focus: focusByGoal[goal][index % focusByGoal[goal].length],
        minutes: sessionMinutes,
        equipment: selectedEquipment[index % selectedEquipment.length],
      })),
      recoveryGuidance: `${recoveryDays} recovery day${recoveryDays === 1 ? '' : 's'} with sleep, hydration and light mobility work.`,
      safetyNotes: [
        'Warm up before each session.',
        'Stop if pain, dizziness or unusual symptoms occur.',
        'Use professional medical advice for health conditions or injury history.',
      ],
    };
  }

  getProgress() {
    return {
      weightTrendKg: [73.2, 72.9, 72.7, 72.4],
      completedSessions: 18,
      currentStreakDays: 9,
      personalRecords: [
        { movement: 'Goblet squat', value: '28 kg x 8' },
        { movement: 'Push-up', value: '24 reps' },
        { movement: 'Plank', value: '2 min 10 sec' },
      ],
    };
  }

  getSocialFeed() {
    return {
      posts: [
        {
          id: 1,
          author: 'Maduvinda',
          title: 'Friday lower-body session complete',
          body: 'Kept the same load and improved control on split squats.',
          reactions: 18,
        },
        {
          id: 2,
          author: 'Coach Team',
          title: 'Weekly reminder',
          body: 'Log meals soon after eating for more accurate nutrition trends.',
          reactions: 31,
        },
      ],
    };
  }

  private getNutritionTotals() {
    return this.meals.reduce(
      (totals, meal) => ({
        calories: totals.calories + meal.calories,
        protein: totals.protein + meal.protein,
        carbs: totals.carbs + meal.carbs,
        fat: totals.fat + meal.fat,
      }),
      { calories: 0, protein: 0, carbs: 0, fat: 0 },
    );
  }

  private normalizeGoal(value: unknown): Goal {
    const goal =
      typeof value === 'string' ? (value.toLowerCase() as Goal) : undefined;
    return goal && GOALS.includes(goal) ? goal : 'strength';
  }

  private normalizeExperience(value: unknown): ExperienceLevel {
    const level =
      typeof value === 'string'
        ? (value.toLowerCase() as ExperienceLevel)
        : undefined;
    return level && EXPERIENCE_LEVELS.includes(level) ? level : 'beginner';
  }

  private normalizeDays(value: unknown): number {
    const days = this.toNumber(value ?? 3);
    if (!Number.isInteger(days) || days < 1 || days > 7) {
      throw new BadRequestException('availableDays must be between 1 and 7.');
    }
    return days;
  }

  private normalizeSessionMinutes(value: unknown): number {
    const minutes = this.toNumber(value ?? 45);
    if (!Number.isInteger(minutes) || minutes < 15 || minutes > 120) {
      throw new BadRequestException('sessionMinutes must be between 15 and 120.');
    }
    return minutes;
  }

  private isPositiveNumber(value: number): boolean {
    return Number.isFinite(value) && value > 0;
  }

  private normalizeEquipment(value: unknown): string[] {
    if (!Array.isArray(value)) {
      return [];
    }

    return value
      .filter((item): item is string => typeof item === 'string')
      .map((item) => item.trim())
      .filter(Boolean);
  }

  private toNumber(value: unknown): number {
    if (typeof value === 'number') {
      return value;
    }

    if (typeof value === 'string' && value.trim()) {
      return Number(value);
    }

    return Number.NaN;
  }
}
