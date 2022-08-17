import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/util/object_util.dart';

class Comment {
  Comment({
    this.feedCommentId,
    this.feedId,
    this.depth,
    this.parentId,
    this.likes,
    this.state,
    this.comment,
    this.isLiked,
    this.user,
    this.createdAt,
  });

  final String? feedCommentId;
  final String? feedId;
  final int? depth;
  final String? parentId;
  int? likes;
  final int? state;
  final String? comment;
  bool? isLiked;
  final User? user;
  final String? createdAt;

  Comment copyWith({
    String? feedCommentId,
    String? feedId,
    int? depth,
    String? parentId,
    int? likes,
    int? state,
    String? comment,
    bool? isLiked,
    User? user,
    String? createdAt,
  }) =>
      Comment(
        feedCommentId: feedCommentId ?? this.feedCommentId,
        feedId: feedId ?? this.feedId,
        depth: depth ?? this.depth,
        parentId: parentId ?? this.parentId,
        likes: likes ?? this.likes,
        state: state ?? this.state,
        comment: comment ?? this.comment,
        isLiked: isLiked ?? this.isLiked,
        user: user ?? this.user,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        feedCommentId: json["_id"],
        feedId: json["feedId"],
        depth: json["depth"],
        parentId: json["parentId"],
        likes: json["likes"],
        state: json["state"],
        comment: json["comment"],
        isLiked: btb(json["isLiked"]),
        user: User.fromJson(json['user']),
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "_id": feedCommentId,
        "feedId": feedId,
        "depth": depth,
        "parentId": parentId,
        "likes": likes,
        "state": state,
        "comment": comment,
        "isLiked": isLiked,
        'user': user?.toJson(),
        "createdAt": createdAt,
      };

  static List<Comment> fromJsonList(List list) =>
      list.map((e) => Comment.fromJson(e)).toList();
}
