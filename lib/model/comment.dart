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

  final int? feedCommentId;
  final int? feedId;
  final int? depth;
  final int? parentId;
  int? likes;
  final int? state;
  final String? comment;
  bool? isLiked;
  final User? user;
  final String? createdAt;

  Comment copyWith({
    int? feedCommentId,
    int? feedId,
    int? depth,
    int? parentId,
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
        feedCommentId: json["feed_comment_id"],
        feedId: json["feed_id"],
        depth: json["depth"],
        parentId: json["parent_id"],
        likes: json["likes"],
        state: json["state"],
        comment: json["comment"],
        isLiked: btb(json["is_liked"]),
        user: User.fromJson(json['user']),
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "feed_comment_id": feedCommentId,
        "feed_id": feedId,
        "depth": depth,
        "parent_id": parentId,
        "likes": likes,
        "state": state,
        "comment": comment,
        "is_liked": isLiked,
        'user': user?.toJson(),
        "created_at": createdAt,
      };

  static List<Comment> fromJsonList(List list) =>
      list.map((e) => Comment.fromJson(e)).toList();
}
