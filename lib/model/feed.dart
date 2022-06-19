class Feed {
  final int? id;
  final int? userId;
  final int? actId;
  final int? actType;
  final String? createdAt;

  Feed({
    this.id,
    this.userId,
    this.actType,
    this.actId,
    this.createdAt,
  });

  factory Feed.fromJson(Map<String, dynamic> json) => Feed(
        id: json["id"],
        userId: json["user_id"],
        actId: json["act_id"],
        actType: json["act_type"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "act_id": actId,
        "act_type": actType,
        "created_at": createdAt,
      };

  static List<Feed> fromJsonList(List list) {
    return list.map((feed) => Feed.fromJson(feed)).toList();
  }
}
