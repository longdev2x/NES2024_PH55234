class StepsEntity {
  final DateTime date;
  final int steps;
  final int calories;
  final int metre;
  final int minutes;

  StepsEntity({
    required this.date,
    this.steps = 0,
    this.calories = 0,
    this.metre = 0,
    this.minutes = 0,
  });

  StepsEntity copyWith({
    DateTime? date,
    int? steps,
    int? calories,
    int? metre,
    int? minutes,
  }) =>
      StepsEntity(
        date: date ?? this.date,
        steps: steps ?? this.steps,
        calories: calories ?? this.calories,
        metre: metre ?? this.metre,
        minutes: minutes ?? this.minutes,
      );
}
