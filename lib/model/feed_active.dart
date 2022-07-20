import 'package:letsworkout/model/file_actions.dart';
import 'package:letsworkout/util/object_util.dart';

class FeedActive {
  FeedActive({
    this.workoutId,
    this.time,
    this.description,
    this.feedId,
    this.userId,
    this.tag,
    this.name,
    this.profileImage,
    this.images,
    this.isLiked,
  });

  final int? workoutId;
  final String? time;
  final String? description;
  final int? feedId;
  final int? userId;
  final String? tag;
  final String? name;
  final String? profileImage;
  final FileActions? images;
  final bool? isLiked;

  FeedActive copyWith({
    int? workoutId,
    String? time,
    String? description,
    int? feedId,
    int? userId,
    String? tag,
    String? name,
    String? profileImage,
    FileActions? images,
    bool? isLiked,
  }) =>
      FeedActive(
        workoutId: workoutId ?? this.workoutId,
        time: time ?? this.time,
        description: description ?? this.description,
        feedId: feedId ?? this.feedId,
        userId: userId ?? this.userId,
        tag: tag ?? this.tag,
        name: name ?? this.name,
        profileImage: profileImage ?? this.profileImage,
        images: images ?? this.images,
        isLiked: isLiked ?? this.isLiked,
      );

  factory FeedActive.fromJson(Map<String, dynamic> json) => FeedActive(
        workoutId: json["workout_id"],
        time: json["time"],
        description: json["description"],
        feedId: json["feed_id"],
        userId: json["user_id"],
        tag: json["tag"],
        name: json["name"],
        profileImage: json["profile_image"],
        images: FileActions.fromJsonList(json['images']),
        isLiked: btb(json['is_liked']),
      );

  Map<String, dynamic> toJson() => {
        "workout_id": workoutId,
        "time": time,
        "description": description,
        "feed_id": feedId,
        "user_id": userId,
        "tag": tag,
        "name": name,
        "profile_image": profileImage,
        "images": images?.toJson(),
        'is_liked': isLiked,
      };

  static List<FeedActive> fromJsonList(List list) =>
      list.map((e) => FeedActive.fromJson(e)).toList();
}
