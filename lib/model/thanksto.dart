class Thanksto {
  Thanksto({
    required this.userId,
    required this.tag,
    required this.description,
  });

  final String userId;
  final String tag;
  final String description;

  Thanksto copyWith({
    String? userId,
    String? tag,
    String? description,
  }) =>
      Thanksto(
        userId: userId ?? this.userId,
        tag: tag ?? this.tag,
        description: description ?? this.description,
      );

  factory Thanksto.fromJson(Map<String, dynamic> json) => Thanksto(
        userId: json['userId'],
        tag: json["tag"],
        description: json["description"],
      );
  static List<Thanksto> fromJsonList(List? list) {
    return list == null ? [] : list.map((e) => Thanksto.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "tag": tag,
        "description": description,
      };
}
