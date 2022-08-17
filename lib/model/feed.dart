import 'package:letsworkout/model/diet.dart';
import 'package:letsworkout/model/file_actions.dart';
import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/model/workout.dart';

class Feed {
  final String? feedId;
  final int? feedType;
  final Workout? workout;
  final Diet? diet;
  final String? time;
  final String? description;
  final User? user;
  final FileActions? images;
  int? likes;
  int? comments;
  bool? isLiked;
  final int? year;
  final int? month;
  final int? day;
  final int? week;
  final String? createdAt;
  final String? updatedAt;

  Feed({
    this.feedId,
    this.feedType,
    this.workout,
    this.diet,
    this.time,
    this.description,
    this.user,
    this.images,
    this.likes = 0,
    this.comments = 0,
    this.isLiked,
    this.year,
    this.month,
    this.day,
    this.week,
    this.createdAt,
    this.updatedAt,
  });

  Feed copyWith({
    String? feedId,
    int? feedType,
    Workout? workout,
    Diet? diet,
    User? user,
    int? year,
    int? month,
    int? day,
    int? week,
    int? likes,
    int? comments,
    String? description,
    FileActions? images,
    String? time,
    String? createdAt,
    String? updatedAt,
  }) =>
      Feed(
        feedId: feedId ?? this.feedId,
        feedType: feedType ?? this.feedType,
        workout: workout ?? this.workout,
        diet: diet ?? this.diet,
        user: user ?? this.user,
        year: year ?? this.year,
        month: month ?? this.month,
        day: day ?? this.day,
        week: week ?? this.week,
        likes: likes ?? this.likes,
        comments: comments ?? this.comments,
        description: description ?? this.description,
        images: images ?? this.images,
        time: time ?? this.time,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Feed.fromJson(Map<String, dynamic> json) => Feed(
        feedId: json["_id"],
        feedType: json["feedType"],
        workout: Workout.fromJson(json['workout']),
        diet: Diet.fromJson(json['diet']),
        user: User.fromJson(json['user']),
        year: json["year"],
        month: json["month"],
        day: json["day"],
        week: json["week"],
        likes: json["likes"],
        comments: json["comments"],
        description: json["description"],
        images: FileActions.fromJsonList(json['images']),
        time: json["time"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "_id": feedId,
        "feedType": feedType,
        "workout": workout?.toJson(),
        "diet": diet?.toJson(),
        "user": user?.toJson(),
        "year": year,
        "month": month,
        "day": day,
        "week": week,
        "likes": likes,
        "comments": comments,
        "description": description,
        "images": images?.toJson(),
        "time": time,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };

  static List<Feed> fromJsonList(List list) {
    return list.map((feed) => Feed.fromJson(feed)).toList();
  }
}
