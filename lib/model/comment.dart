import 'package:letsworkout/util/object_util.dart';

class Comment {
  Comment({
    this.feedCommentId,
    this.userId,
    this.feedId,
    this.depth,
    this.parentId,
    this.likes,
    this.state,
    this.comment,
    this.createdAt,
    this.userImage,
    this.userName,
    this.isLiked,
  });

  final int? feedCommentId;
  final int? userId;
  final int? feedId;
  final int? depth;
  final int? parentId;
  int? likes;
  final int? state;
  final String? comment;
  final String? createdAt;
  final String? userImage;
  final String? userName;
  bool? isLiked;

  Comment copyWith({
    int? feedCommentId,
    int? userId,
    int? feedId,
    int? depth,
    int? parentId,
    int? likes,
    int? state,
    String? comment,
    String? createdAt,
    String? userImage,
    String? userName,
    bool? isLiked,
  }) =>
      Comment(
        feedCommentId: feedCommentId ?? this.feedCommentId,
        userId: userId ?? this.userId,
        feedId: feedId ?? this.feedId,
        depth: depth ?? this.depth,
        parentId: parentId ?? this.parentId,
        likes: likes ?? this.likes,
        state: state ?? this.state,
        comment: comment ?? this.comment,
        createdAt: createdAt ?? this.createdAt,
        userImage: userImage ?? this.userImage,
        userName: userName ?? this.userName,
        isLiked: isLiked ?? this.isLiked,
      );

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        feedCommentId: json["feed_comment_id"],
        userId: json["user_id"],
        feedId: json["feed_id"],
        depth: json["depth"],
        parentId: json["parent_id"],
        likes: json["likes"],
        state: json["state"],
        comment: json["comment"],
        createdAt: json["created_at"],
        userImage: json["user_image"],
        userName: json["user_name"],
        isLiked: btb(json["is_liked"]),
      );

  Map<String, dynamic> toJson() => {
        "feed_comment_id": feedCommentId,
        "user_id": userId,
        "feed_id": feedId,
        "depth": depth,
        "parent_id": parentId,
        "likes": likes,
        "state": state,
        "comment": comment,
        "created_at": createdAt,
        "user_image": userImage,
        "user_name": userName,
        "is_liked": isLiked,
      };

  static List<Comment> fromJsonList(List list) =>
      list.map((e) => Comment.fromJson(e)).toList();
}
