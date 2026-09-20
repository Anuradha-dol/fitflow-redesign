import 'package:flutter/material.dart';

void main() {
  runApp(const FitFlowApp());
}

class FitFlowApp extends StatelessWidget {
  const FitFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E7D63),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F8F7),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xFFE2E8E5)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFD4DDD8)),
          ),
        ),
      ),
      home: const FitFlowShell(),
    );
  }
}

class FitFlowShell extends StatefulWidget {
  const FitFlowShell({super.key});

  @override
  State<FitFlowShell> createState() => _FitFlowShellState();
}

class _FitFlowShellState extends State<FitFlowShell> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    WorkoutsPage(),
    NutritionPage(),
    ProgressPage(),
    SocialPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: const Row(
          children: [
            Icon(Icons.fitness_center),
            SizedBox(width: 10),
            Text('FitFlow'),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: _HeaderPill(label: 'Prototype', icon: Icons.verified_outlined),
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Workouts',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_outlined),
            selectedIcon: Icon(Icons.restaurant),
            label: 'Nutrition',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart_outlined),
            selectedIcon: Icon(Icons.show_chart),
            label: 'Progress',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            label: 'Social',
          ),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PageFrame(
      title: 'Today',
      subtitle: 'Plan the session, meals and recovery work from one place.',
      children: [
        _MetricGrid(
          metrics: [
            Metric('Training', '4 / 5', 'weekly sessions', Icons.bolt),
            Metric('Calories', '1,260', 'of 2,300 kcal', Icons.local_fire_department),
            Metric('Water', '2.1 L', 'of 3.0 L target', Icons.water_drop_outlined),
            Metric('Streak', '9 days', 'activity logged', Icons.timeline),
          ],
        ),
        SizedBox(height: 18),
        _TwoColumn(
          left: _TodayWorkoutPanel(),
          right: _RecommendationPanel(),
        ),
        SizedBox(height: 18),
        _SectionHeader(title: 'Nutrition snapshot', icon: Icons.pie_chart_outline),
        SizedBox(height: 10),
        _MacroPanel(),
      ],
    );
  }
}

class WorkoutsPage extends StatelessWidget {
  const WorkoutsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _PageFrame(
      title: 'Workout plan',
      subtitle: 'Four planned sessions balance strength, cardio and recovery.',
      children: [
        const _SectionHeader(title: 'This week', icon: Icons.calendar_month_outlined),
        const SizedBox(height: 10),
        ...sampleWorkouts.map(
          (workout) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _WorkoutCard(workout: workout),
          ),
        ),
      ],
    );
  }
}

class NutritionPage extends StatefulWidget {
  const NutritionPage({super.key});

  @override
  State<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  final List<Meal> _meals = [...sampleMeals];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totals = MacroTotals.fromMeals(_meals);

    return _PageFrame(
      title: 'Nutrition',
      subtitle: 'Track meals against daily calorie and macro targets.',
      children: [
        _NutritionTotals(totals: totals),
        const SizedBox(height: 18),
        _TwoColumn(
          left: _AddMealPanel(
            nameController: _nameController,
            caloriesController: _caloriesController,
            proteinController: _proteinController,
            carbsController: _carbsController,
            fatController: _fatController,
            onAddMeal: _addMeal,
          ),
          right: _MealListPanel(meals: _meals),
        ),
      ],
    );
  }

  void _addMeal() {
    final name = _nameController.text.trim();
    final calories = int.tryParse(_caloriesController.text.trim());
    final protein = int.tryParse(_proteinController.text.trim()) ?? 0;
    final carbs = int.tryParse(_carbsController.text.trim()) ?? 0;
    final fat = int.tryParse(_fatController.text.trim()) ?? 0;

    if (name.isEmpty || calories == null || calories <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a meal name and valid calories.')),
      );
      return;
    }

    setState(() {
      _meals.add(
        Meal(
          name: name,
          calories: calories,
          protein: protein,
          carbs: carbs,
          fat: fat,
        ),
      );
    });

    _nameController.clear();
    _caloriesController.clear();
    _proteinController.clear();
    _carbsController.clear();
    _fatController.clear();
  }
}

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PageFrame(
      title: 'Progress',
      subtitle: 'Weekly trends make training consistency easier to review.',
      children: [
        _MetricGrid(
          metrics: [
            Metric('Adherence', '86%', 'planned workouts completed', Icons.task_alt),
            Metric('Weight', '72.4 kg', '0.8 kg down this month', Icons.monitor_weight_outlined),
            Metric('Training', '155 min', 'this week', Icons.timer_outlined),
            Metric('Sleep', '7 h 20 m', 'average nightly', Icons.bedtime_outlined),
          ],
        ),
        SizedBox(height: 18),
        _TwoColumn(left: _TrendPanel(), right: _RecordsPanel()),
      ],
    );
  }
}

class SocialPage extends StatelessWidget {
  const SocialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _PageFrame(
      title: 'Community',
      subtitle: 'Share training updates and keep social encouragement lightweight.',
      children: [
        const _SectionHeader(title: 'Feed', icon: Icons.groups_outlined),
        const SizedBox(height: 10),
        ...samplePosts.map(
          (post) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SocialPostCard(post: post),
          ),
        ),
      ],
    );
  }
}

class _PageFrame extends StatelessWidget {
  const _PageFrame({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth >= 900 ? 32 : 16,
              vertical: 18,
            ),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.black.withValues(alpha: 0.64),
                            ),
                      ),
                      const SizedBox(height: 20),
                      ...children,
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HeaderPill extends StatelessWidget {
  const _HeaderPill({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4EF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFC9DED5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 16, color: const Color(0xFF1E7D63)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.metrics});

  final List<Metric> metrics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 980
            ? 4
            : constraints.maxWidth >= 560
                ? 2
                : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: metrics.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 132,
          ),
          itemBuilder: (context, index) {
            return _MetricCard(metric: metrics[index]);
          },
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final Metric metric;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(metric.icon, color: const Color(0xFF1E7D63)),
            const Spacer(),
            Text(
              metric.value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              '${metric.label} - ${metric.description}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _TwoColumn extends StatelessWidget {
  const _TwoColumn({required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 760) {
          return Column(
            children: [
              left,
              const SizedBox(height: 12),
              right,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: left),
            const SizedBox(width: 12),
            Expanded(child: right),
          ],
        );
      },
    );
  }
}

class _TodayWorkoutPanel extends StatelessWidget {
  const _TodayWorkoutPanel();

  @override
  Widget build(BuildContext context) {
    final workout = sampleWorkouts.first;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(title: 'Next workout', icon: Icons.fitness_center),
            const SizedBox(height: 16),
            Text(
              workout.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
            ),
            const SizedBox(height: 8),
            Text(workout.focus),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoChip(icon: Icons.calendar_today_outlined, label: workout.day),
                _InfoChip(icon: Icons.timer_outlined, label: '${workout.minutes} min'),
                _InfoChip(icon: Icons.speed_outlined, label: workout.intensity),
              ],
            ),
            const SizedBox(height: 16),
            ...workout.exercises.map(
              (exercise) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, size: 18, color: Color(0xFF1E7D63)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(exercise)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendationPanel extends StatelessWidget {
  const _RecommendationPanel();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFFAF0),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(title: 'Recommendation', icon: Icons.psychology_outlined),
            const SizedBox(height: 16),
            Text(
              'This week is weighted toward compound strength with one aerobic recovery session.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Keep two recovery days, log protein at each meal, and avoid increasing load if form breaks.',
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Refresh plan'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroPanel extends StatelessWidget {
  const _MacroPanel();

  @override
  Widget build(BuildContext context) {
    final totals = MacroTotals.fromMeals(sampleMeals);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _MacroBar(label: 'Protein', value: totals.protein, target: 150, color: const Color(0xFF1E7D63)),
            const SizedBox(height: 14),
            _MacroBar(label: 'Carbs', value: totals.carbs, target: 250, color: const Color(0xFF3C6EAD)),
            const SizedBox(height: 14),
            _MacroBar(label: 'Fat', value: totals.fat, target: 70, color: const Color(0xFFC77719)),
          ],
        ),
      ),
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  const _WorkoutCard({required this.workout});

  final WorkoutSession workout;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 78,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.day,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  _IntensityBadge(label: workout.intensity),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(workout.focus),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _InfoChip(icon: Icons.timer_outlined, label: '${workout.minutes} min'),
                      ...workout.exercises.take(3).map(
                            (exercise) => _InfoChip(
                              icon: Icons.check_outlined,
                              label: exercise,
                            ),
                          ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NutritionTotals extends StatelessWidget {
  const _NutritionTotals({required this.totals});

  final MacroTotals totals;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(title: 'Today totals', icon: Icons.restaurant_menu),
            const SizedBox(height: 16),
            _MacroBar(
              label: 'Calories',
              value: totals.calories,
              target: 2300,
              color: const Color(0xFF1E7D63),
              unit: 'kcal',
            ),
            const SizedBox(height: 14),
            _MacroBar(label: 'Protein', value: totals.protein, target: 150, color: const Color(0xFF3C6EAD)),
            const SizedBox(height: 14),
            _MacroBar(label: 'Carbs', value: totals.carbs, target: 250, color: const Color(0xFFC77719)),
            const SizedBox(height: 14),
            _MacroBar(label: 'Fat', value: totals.fat, target: 70, color: const Color(0xFF7F4AB8)),
          ],
        ),
      ),
    );
  }
}

class _AddMealPanel extends StatelessWidget {
  const _AddMealPanel({
    required this.nameController,
    required this.caloriesController,
    required this.proteinController,
    required this.carbsController,
    required this.fatController,
    required this.onAddMeal,
  });

  final TextEditingController nameController;
  final TextEditingController caloriesController;
  final TextEditingController proteinController;
  final TextEditingController carbsController;
  final TextEditingController fatController;
  final VoidCallback onAddMeal;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(title: 'Add meal', icon: Icons.add_circle_outline),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Meal name'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: caloriesController,
              decoration: const InputDecoration(labelText: 'Calories'),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: proteinController,
                    decoration: const InputDecoration(labelText: 'Protein'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: carbsController,
                    decoration: const InputDecoration(labelText: 'Carbs'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: fatController,
                    decoration: const InputDecoration(labelText: 'Fat'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onAddMeal,
                icon: const Icon(Icons.add),
                label: const Text('Add meal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MealListPanel extends StatelessWidget {
  const _MealListPanel({required this.meals});

  final List<Meal> meals;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(title: 'Logged meals', icon: Icons.list_alt_outlined),
            const SizedBox(height: 12),
            ...meals.map(
              (meal) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.radio_button_checked, size: 18, color: Color(0xFF1E7D63)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meal.name,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${meal.calories} kcal - P ${meal.protein}g / C ${meal.carbs}g / F ${meal.fat}g',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendPanel extends StatelessWidget {
  const _TrendPanel();

  @override
  Widget build(BuildContext context) {
    final points = [0.88, 0.72, 0.78, 0.86];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(title: 'Workout adherence', icon: Icons.stacked_line_chart),
            const SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var index = 0; index < points.length; index++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: _BarPoint(
                        label: 'W${index + 1}',
                        value: points[index],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RecordsPanel extends StatelessWidget {
  const _RecordsPanel();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(title: 'Personal records', icon: Icons.emoji_events_outlined),
            const SizedBox(height: 14),
            ...sampleRecords.map(
              (record) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_upward, size: 18, color: Color(0xFFC77719)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${record.label}: ${record.value}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialPostCard extends StatelessWidget {
  const _SocialPostCard({required this.post});

  final SocialPost post;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFEAF4EF),
                  child: Text(post.author.characters.first),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.author,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Text(post.timeAgo),
                    ],
                  ),
                ),
                _InfoChip(icon: Icons.favorite_outline, label: '${post.reactions}'),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              post.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 6),
            Text(post.body),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF1E7D63)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                ),
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD9E3DF)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntensityBadge extends StatelessWidget {
  const _IntensityBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final color = switch (label) {
      'High' => const Color(0xFFB84D3A),
      'Moderate' => const Color(0xFFC77719),
      _ => const Color(0xFF1E7D63),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _MacroBar extends StatelessWidget {
  const _MacroBar({
    required this.label,
    required this.value,
    required this.target,
    required this.color,
    this.unit = 'g',
  });

  final String label;
  final int value;
  final int target;
  final Color color;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final percent = (value / target).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            Text('$value / $target $unit'),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 12,
            backgroundColor: const Color(0xFFE9EFEC),
            color: color,
          ),
        ),
      ],
    );
  }
}

class _BarPoint extends StatelessWidget {
  const _BarPoint({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: value,
              widthFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E7D63),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class Metric {
  const Metric(this.label, this.value, this.description, this.icon);

  final String label;
  final String value;
  final String description;
  final IconData icon;
}

class WorkoutSession {
  const WorkoutSession({
    required this.day,
    required this.title,
    required this.focus,
    required this.minutes,
    required this.intensity,
    required this.exercises,
  });

  final String day;
  final String title;
  final String focus;
  final int minutes;
  final String intensity;
  final List<String> exercises;
}

class Meal {
  const Meal({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
}

class MacroTotals {
  const MacroTotals({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  static MacroTotals fromMeals(List<Meal> meals) {
    return meals.fold(
      const MacroTotals(calories: 0, protein: 0, carbs: 0, fat: 0),
      (totals, meal) => MacroTotals(
        calories: totals.calories + meal.calories,
        protein: totals.protein + meal.protein,
        carbs: totals.carbs + meal.carbs,
        fat: totals.fat + meal.fat,
      ),
    );
  }
}

class RecordItem {
  const RecordItem(this.label, this.value);

  final String label;
  final String value;
}

class SocialPost {
  const SocialPost({
    required this.author,
    required this.timeAgo,
    required this.title,
    required this.body,
    required this.reactions,
  });

  final String author;
  final String timeAgo;
  final String title;
  final String body;
  final int reactions;
}

const sampleWorkouts = [
  WorkoutSession(
    day: 'Mon',
    title: 'Full-body strength',
    focus: 'Compound lifting and core stability',
    minutes: 45,
    intensity: 'High',
    exercises: ['Goblet squat', 'Push-up', 'Dumbbell row', 'Plank'],
  ),
  WorkoutSession(
    day: 'Wed',
    title: 'Zone 2 cardio',
    focus: 'Aerobic base and recovery',
    minutes: 35,
    intensity: 'Moderate',
    exercises: ['Incline walk', 'Bike intervals', 'Hip mobility'],
  ),
  WorkoutSession(
    day: 'Fri',
    title: 'Lower-body power',
    focus: 'Glutes, hamstrings and balance',
    minutes: 50,
    intensity: 'High',
    exercises: ['Romanian deadlift', 'Split squat', 'Calf raise', 'Side plank'],
  ),
  WorkoutSession(
    day: 'Sun',
    title: 'Mobility reset',
    focus: 'Flexibility and joint control',
    minutes: 25,
    intensity: 'Low',
    exercises: ['World greatest stretch', 'Thoracic rotation', 'Breathing drill'],
  ),
];

const sampleMeals = [
  Meal(name: 'Oats, banana and whey', calories: 430, protein: 34, carbs: 58, fat: 8),
  Meal(name: 'Chicken rice bowl', calories: 620, protein: 48, carbs: 74, fat: 14),
  Meal(name: 'Greek yogurt with berries', calories: 210, protein: 22, carbs: 24, fat: 4),
];

const sampleRecords = [
  RecordItem('Goblet squat', '28 kg x 8'),
  RecordItem('Push-up', '24 reps'),
  RecordItem('Plank', '2 min 10 sec'),
];

const samplePosts = [
  SocialPost(
    author: 'Maduvinda',
    timeAgo: 'Today',
    title: 'Friday lower-body session complete',
    body: 'Kept the same load and improved control on split squats.',
    reactions: 18,
  ),
  SocialPost(
    author: 'Coach Team',
    timeAgo: 'Yesterday',
    title: 'Weekly reminder',
    body: 'Log meals soon after eating for more accurate nutrition trends.',
    reactions: 31,
  ),
  SocialPost(
    author: 'Kasun',
    timeAgo: '2 days ago',
    title: 'Recovery run done',
    body: 'Finished an easy 5 km run and stayed in zone 2 for most of it.',
    reactions: 12,
  ),
];
