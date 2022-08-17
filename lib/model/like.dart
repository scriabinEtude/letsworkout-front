class Like {
  final String userId;
  final String? tag;
  final String? name;
  final String feedId;

  Like({
    required this.userId,
    this.tag,
    this.name,
    required this.feedId,
  });

  factory Like.fromJson(Map json) => Like(
        userId: json['userId'],
        tag: json['tag'],
        name: json['name'],
        feedId: json['feedId'],
      );
}
