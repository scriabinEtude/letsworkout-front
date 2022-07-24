import 'dart:convert';

import 'package:letsworkout/enum/act_type.dart';
import 'package:letsworkout/model/diet.dart';
import 'package:letsworkout/model/file_actions.dart';
import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/model/workout.dart';
import 'package:letsworkout/util/object_util.dart';

class Feed {
  final int? feedId;
  final int? userId;
  final int? actId;
  final int? actType;
  int? likes;
  int? comments;
  final User? user;
  final FileActions? images;
  bool? isLiked;
  final String? createdAt;

  Feed({
    this.feedId,
    this.userId,
    this.actType,
    this.actId,
    this.likes,
    this.comments,
    this.user,
    this.images,
    this.isLiked,
    this.createdAt,
  });

  Feed copyWith({
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
  }) =>
      Feed(
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

  factory Feed.fromFcmData(Map<String, dynamic> data) {
    data['user'] = nullCheck(
      data['user'],
      convertFcmMapToDynamic(jsonDecode(data['user'])),
    );
    return Feed.fromJson(data);
  }

  factory Feed.fromJson(Map<String, dynamic> json) {
    try {
      switch (ActType.values[json['act_type']]) {
        case ActType.workout:
          return Workout.fromJson(json);
        case ActType.diet:
          return Diet.fromJson(json);
      }
    } catch (e) {
      return Feed(
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
      );
    }
  }

  Map<String, dynamic> toJson() => {
        "feed_id": feedId,
        "user_id": userId,
        "act_id": actId,
        "act_type": actType,
        "likes": likes,
        "comments": comments,
        'user': user?.toJson(),
        "images": images?.toJson(),
        "is_liked": isLiked,
        "created_at": createdAt,
      };

  static List<Feed> fromJsonList(List list) {
    return list.map((feed) => Feed.fromJson(feed)).toList();
  }
}
