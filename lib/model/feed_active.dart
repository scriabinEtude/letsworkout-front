class FeedActive {
  FeedActive({
    this.workoutId,
    this.time,
    this.description,
    this.userId,
    this.tag,
    this.name,
    this.profileImage,
  });

  final int? workoutId;
  final String? time;
  final String? description;
  final int? userId;
  final String? tag;
  final String? name;
  final String? profileImage;

  FeedActive copyWith({
    int? workoutId,
    String? time,
    String? description,
    int? userId,
    String? tag,
    String? name,
    String? profileImage,
  }) =>
      FeedActive(
        workoutId: workoutId ?? this.workoutId,
        time: time ?? this.time,
        description: description ?? this.description,
        userId: userId ?? this.userId,
        tag: tag ?? this.tag,
        name: name ?? this.name,
        profileImage: profileImage ?? this.profileImage,
      );

  factory FeedActive.fromJson(Map<String, dynamic> json) => FeedActive(
        workoutId: json["workout_id"],
        time: json["time"],
        description: json["description"],
        userId: json["user_id"],
        tag: json["tag"],
        name: json["name"],
        profileImage: json["profile_image"],
      );

  Map<String, dynamic> toJson() => {
        "workout_id": workoutId,
        "time": time,
        "description": description,
        "user_id": userId,
        "tag": tag,
        "name": name,
        "profile_image": profileImage,
      };

  static List<FeedActive> fromJsonList(List list) =>
      list.map((e) => FeedActive.fromJson(e)).toList();
}
