import 'package:letsworkout/enum/workout_type.dart';
import 'package:letsworkout/model/feed.dart';
import 'package:letsworkout/model/file_actions.dart';
import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/module/error/letsworkout_error.dart';
import 'package:letsworkout/util/object_util.dart';

class Workout extends Feed {
  Workout({
    int? feedId,
    int? userId,
    int? actId,
    int? actType,
    int? likes,
    int? comments,
    User? user,
    FileActions? images,
    bool? isLiked,
    String? createdAt,
    this.workoutId,
    required this.workoutType,
    this.time,
    this.endTime,
    this.description,
  }) : super(
          feedId: feedId,
          userId: userId,
          actId: actId,
          actType: actType,
          likes: likes,
          comments: comments,
          user: user,
          images: images,
          isLiked: isLiked,
          createdAt: createdAt,
        );

  final int? workoutId;
  final int workoutType;
  final String? time;
  final String? endTime;
  final String? description;

  factory Workout.init() => Workout(
        workoutType: WorkoutType.none.index,
      );

  @override
  Workout copyWith({
    int? feedId,
    int? userId,
    int? actId,
    int? actType,
    int? likes,
    int? comments,
    User? user,
    FileActions? images,
    bool? isLiked,
    String? createdAt,
    int? workoutId,
    int? workoutType,
    String? time,
    String? endTime,
    String? description,
  }) =>
      Workout(
        feedId: feedId ?? this.feedId,
        userId: userId ?? this.userId,
        actId: actId ?? this.actId,
        actType: actType ?? this.actType,
        likes: likes ?? this.likes,
        comments: comments ?? this.comments,
        user: user ?? this.user,
        images: images ?? this.images,
        isLiked: isLiked ?? this.isLiked,
        createdAt: createdAt ?? this.createdAt,
        workoutId: workoutId ?? this.workoutId,
        workoutType: workoutType ?? this.workoutType,
        time: time ?? this.time,
        endTime: endTime ?? this.endTime,
        description: description ?? this.description,
      );

  factory Workout.fromJson(Map<String, dynamic> json) {
    try {
      return Workout(
        feedId: json["feed_id"],
        userId: json["user_id"],
        actId: json["act_id"],
        actType: json["act_type"],
        likes: json["likes"],
        comments: json["comments"],
        user: User.fromJson(json['user']),
        images: FileActions.fromJsonList(json['images']),
        isLiked: btb(json['is_liked']),
        createdAt: json["created_at"],
        workoutId: json["workout_id"],
        workoutType: json['workout_type'],
        time: json["time"],
        endTime: json["end_time"],
        description: json["description"],
      );
    } catch (e) {
      print(e);
      throw LetsworkoutError('Workout.fromJson', e);
    }
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        "workout_id": workoutId,
        'workout_type': workoutType,
        "time": time,
        "end_time": endTime,
        "description": description,
      };
}
