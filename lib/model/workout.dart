class Workout {
  Workout({
    this.workoutType,
    this.endTime,
  });

  final int? workoutType;
  final String? endTime;

  Workout copyWith({
    int? workoutType,
    String? endTime,
  }) =>
      Workout(
        workoutType: workoutType ?? this.workoutType,
        endTime: endTime ?? this.endTime,
      );

  static Workout? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return Workout(
      workoutType: json["workoutType"],
      endTime: json["endTime"],
    );
  }

  Map<String, dynamic> toJson() => {
        "workoutType": workoutType,
        "endTime": endTime,
      };
}
