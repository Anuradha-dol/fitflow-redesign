import { Controller, Get } from '@nestjs/common';

@Controller('health')
export class HealthController {
  @Get()
  getHealth() {
    return {
      service: 'fitflow-core-api',
      status: 'ok',
      uptimeSeconds: Math.round(process.uptime()),
      features: [
        'dashboard overview',
        'workout planning',
        'nutrition tracking',
        'progress summary',
        'recommendations',
      ],
    };
  }
}
