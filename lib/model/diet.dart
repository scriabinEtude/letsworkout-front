import 'package:letsworkout/model/feed.dart';
import 'package:letsworkout/model/file_actions.dart';
import 'package:letsworkout/model/food.dart';
import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/util/object_util.dart';

class Diet extends Feed {
  Diet({
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
    this.dietId,
    this.time,
    this.description,
    this.calorie,
    this.carbohydrate,
    this.protein,
    this.fat,
    this.sugar,
    this.sodium,
    this.foods,
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

  final int? dietId;
  final String? time;
  final String? description;
  final int? calorie;
  final int? carbohydrate;
  final int? protein;
  final int? fat;
  final int? sugar;
  final int? sodium;
  final List<Food>? foods;

  @override
  Diet copyWith({
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
    int? dietId,
    String? time,
    String? description,
    int? calorie,
    int? carbohydrate,
    int? protein,
    int? fat,
    int? sugar,
    int? sodium,
    List<Food>? foods,
  }) =>
      Diet(
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
        dietId: dietId ?? this.dietId,
        time: time ?? this.time,
        description: description ?? this.description,
        calorie: calorie ?? this.calorie,
        carbohydrate: carbohydrate ?? this.carbohydrate,
        protein: protein ?? this.protein,
        fat: fat ?? this.fat,
        sugar: sugar ?? this.sugar,
        sodium: sodium ?? this.sodium,
        foods: foods ?? this.foods,
      );

  factory Diet.fromJson(Map<String, dynamic> json) => Diet(
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
        dietId: json["diet_id"],
        time: json["time"],
        description: json["description"],
        calorie: json["calorie"],
        carbohydrate: json["carbohydrate"],
        protein: json["protein"],
        fat: json["fat"],
        sugar: json["sugar"],
        sodium: json["sodium"],
        foods: json["foods"],
      );

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        "diet_id": dietId,
        "time": time,
        "description": description,
        "calorie": calorie,
        "carbohydrate": carbohydrate,
        "protein": protein,
        "fat": fat,
        "sugar": sugar,
        "sodium": sodium,
        "foods": foods?.map((food) => food.toJson()).toList(),
      };
}
