import { Body, Controller, Get, Post } from '@nestjs/common';
import { FitFlowService } from './fitflow.service';

@Controller()
export class FitFlowController {
  constructor(private readonly fitFlowService: FitFlowService) {}

  @Get('overview')
  getOverview() {
    return this.fitFlowService.getOverview();
  }

  @Get('workouts')
  getWeeklyPlan() {
    return this.fitFlowService.getWeeklyPlan();
  }

  @Get('nutrition')
  getNutritionSummary() {
    return this.fitFlowService.getNutritionSummary();
  }

  @Post('nutrition/meals')
  addMeal(@Body() payload: Record<string, unknown>) {
    return this.fitFlowService.addMeal(payload);
  }

  @Post('recommendations')
  createRecommendation(@Body() payload: Record<string, unknown>) {
    return this.fitFlowService.createRecommendation(payload);
  }

  @Get('progress')
  getProgress() {
    return this.fitFlowService.getProgress();
  }

  @Get('social-feed')
  getSocialFeed() {
    return this.fitFlowService.getSocialFeed();
  }
}
