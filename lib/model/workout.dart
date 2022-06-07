class Workout {
  Workout({
    this.id,
    this.userId,
    this.workoutType,
    required this.startTime,
    this.endTime,
    this.content,
  });

  final int? id;
  final int? userId;
  final int? workoutType;
  final String startTime;
  final String? endTime;
  final String? content;

  Workout copyWith({
    int? id,
    int? userId,
    int? workoutType,
    String? startTime,
    String? endTime,
    String? content,
  }) =>
      Workout(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        workoutType: workoutType ?? this.workoutType,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        content: content ?? this.content,
      );

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
        id: json["id"],
        userId: json["userId"],
        workoutType: json['workoutType'],
        startTime: json["startTime"],
        endTime: json["endTime"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        'workoutType': workoutType,
        "startTime": startTime,
        "endTime": endTime,
        "content": content,
      };
}
