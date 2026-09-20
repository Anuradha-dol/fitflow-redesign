import { Module } from '@nestjs/common';
import { FitFlowController } from './fitflow.controller';
import { FitFlowService } from './fitflow.service';
import { HealthController } from './health.controller';

@Module({
  imports: [],
  controllers: [HealthController, FitFlowController],
  providers: [FitFlowService],
})
export class AppModule {}
