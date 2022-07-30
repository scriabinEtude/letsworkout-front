class Like {
  final int userId;
  final String? tag;
  final String? name;
  final int feedId;

  Like({
    required this.userId,
    this.tag,
    this.name,
    required this.feedId,
  });

  factory Like.fromJson(Map json) => Like(
        userId: json['user_id'],
        tag: json['tag'],
        name: json['name'],
        feedId: json['feed_id'],
      );
}
