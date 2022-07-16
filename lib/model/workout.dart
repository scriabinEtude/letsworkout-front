import 'package:letsworkout/model/file_actions.dart';

class Workout {
  Workout({
    this.feedId,
    this.actType,
    this.id,
    required this.userId,
    this.workoutType,
    required this.time,
    this.endTime,
    this.description,
    this.images,
  });

  final int? feedId;
  final int? actType;
  final int? id;
  final int? userId;
  final int? workoutType;
  final String time;
  final String? endTime;
  final String? description;
  final FileActions? images;

  Workout copyWith({
    int? feedId,
    int? actType,
    int? id,
    int? userId,
    int? workoutType,
    String? time,
    String? endTime,
    String? description,
    FileActions? images,
  }) =>
      Workout(
        feedId: feedId ?? this.feedId,
        actType: actType ?? this.actType,
        id: id ?? this.id,
        userId: userId ?? this.userId,
        workoutType: workoutType ?? this.workoutType,
        time: time ?? this.time,
        endTime: endTime ?? this.endTime,
        description: description ?? this.description,
        images: images ?? this.images,
      );

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
      id: json["id"],
      actType: json['act_type'],
      userId: json["user_id"],
      feedId: json['feed_id'],
      workoutType: json['workout_type'],
      time: json["time"],
      endTime: json["end_time"],
      description: json["description"],
      images: FileActions.fromJsonList(json['images']));

  Map<String, dynamic> toJson() => {
        "id": id,
        'act_type': actType,
        "user_id": userId,
        "feed_id": feedId,
        'workout_type': workoutType,
        "time": time,
        "end_time": endTime,
        "description": description,
        "images": images?.toJson(),
      };
}
