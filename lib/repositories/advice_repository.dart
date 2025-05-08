import 'dart:math';

/// Represents the three cycle phases we track.
enum CyclePhase { period, fertile, safe }

class AdviceRepository {
  AdviceRepository._privateConstructor();
  static final AdviceRepository instance = AdviceRepository._privateConstructor();

  final _random = Random();

  // Advice entries for each phase
  final Map<CyclePhase, List<String>> _advice = {
    CyclePhase.period: [
      'Stay hydrated to reduce headaches and bloating.',
      'Try gentle yoga or walking to ease cramps.',
      'Sip warm herbal tea (like chamomile) to relax muscles.',
      'Use a heating pad on your lower abdomen for pain relief.',
      'Take rest breaks and practice deep breathing exercises.',
    ],
    CyclePhase.fertile: [
      'Track your cycle and basal body temperature for accuracy.',
      'Include estrogen‑balancing foods such as flaxseeds and whole grains.',
      'Keep stress low with meditation or breathing exercises.',
      'Maintain a healthy weight to support ovulation.',
      'Reduce alcohol and excessive caffeine intake.',
    ],
    CyclePhase.safe: [
      'Enjoy a balanced diet rich in whole grains and lean proteins.',
      'Stay active with moderate exercise like cycling or swimming.',
      'Practice mindfulness or yoga for stress relief.',
      'Hydrate consistently throughout the day.',
      'Include healthy fats like avocados and nuts.',
    ],
  };

  // Health tip entries for each phase
  final Map<CyclePhase, List<String>> _tips = {
    CyclePhase.period: [
      'Include iron‑rich foods like spinach and beans to replenish nutrients.',
      'Eat vitamin C–rich fruits to enhance iron absorption.',
      'Avoid cold drinks if you notice worsened cramps.',
      'Incorporate magnesium‑rich foods (e.g., almonds, bananas).',
      'Opt for calcium‑rich snacks like yogurt or broccoli.',
    ],
    CyclePhase.fertile: [
      'Snack on antioxidant‑rich berries and leafy greens.',
      'Add healthy fats (olive oil, nuts) to support hormone production.',
      'Ensure adequate protein intake with lean meats or legumes.',
      'Try whole grains such as oats for steady energy release.',
      'Stay at a healthy BMI to optimize fertility.',
    ],
    CyclePhase.safe: [
      'Focus on fiber‑rich carbs like sweet potatoes and brown rice.',
      'Keep proteins lean—chicken, turkey, or tofu.',
      'Include a colorful variety of vegetables for micronutrients.',
      'Enjoy herbal teas like peppermint for digestion.',
      'Limit processed foods and refined sugars.',
    ],
  };

  /// Returns the current cycle phase based on last period date, cycle length, and period length.
  CyclePhase determinePhase({
    required DateTime lastPeriod,
    required int cycleLength,
    required int periodLength,
    DateTime? today,
  }) {
    final now = today ?? DateTime.now();
    final periodEnd = lastPeriod.add(Duration(days: periodLength));
    final ovulationDay = lastPeriod.add(Duration(days: cycleLength - 14));
    final fertileStart = ovulationDay.subtract(Duration(days: 5));
    final fertileEnd = ovulationDay.add(Duration(days: 1));

    if (!now.isBefore(lastPeriod) && !now.isAfter(periodEnd)) {
      return CyclePhase.period;
    } else if (!now.isBefore(fertileStart) && !now.isAfter(fertileEnd)) {
      return CyclePhase.fertile;
    } else {
      return CyclePhase.safe;
    }
  }

  /// Picks a random advice string for the given phase.
  String getRandomAdvice(CyclePhase phase) {
    final list = _advice[phase]!;
    return list[_random.nextInt(list.length)];
  }

  /// Picks a random health tip string for the given phase.
  String getRandomTip(CyclePhase phase) {
    final list = _tips[phase]!;
    return list[_random.nextInt(list.length)];
  }
}