class Workout {
  Workout({
    this.feedId,
    this.actType,
    this.id,
    required this.userId,
    this.workoutType,
    required this.startTime,
    this.endTime,
    this.content,
  });

  final int? feedId;
  final int? actType;
  final int? id;
  final int? userId;
  final int? workoutType;
  final String startTime;
  final String? endTime;
  final String? content;

  Workout copyWith({
    int? feedId,
    int? actType,
    int? id,
    int? userId,
    int? workoutType,
    String? startTime,
    String? endTime,
    String? content,
  }) =>
      Workout(
        feedId: feedId ?? this.feedId,
        actType: actType ?? this.actType,
        id: id ?? this.id,
        userId: userId ?? this.userId,
        workoutType: workoutType ?? this.workoutType,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        content: content ?? this.content,
      );

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
        id: json["id"],
        actType: json['act_type'],
        userId: json["user_id"],
        feedId: json['feed_id'],
        workoutType: json['workout_type'],
        startTime: json["start_time"],
        endTime: json["end_time"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        'act_type': actType,
        "user_id": userId,
        "feed_id": feedId,
        'workout_type': workoutType,
        "start_time": startTime,
        "end_time": endTime,
        "content": content,
      };
}
