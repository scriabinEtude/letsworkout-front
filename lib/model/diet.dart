class Diet {
  Diet({
    this.id,
    this.userId,
    this.feedId,
    this.actType,
    this.time,
    this.description,
    this.calorie,
    this.carbohydrate,
    this.protein,
    this.fat,
    this.images,
  });

  final int? id;
  final int? userId;
  final int? feedId;
  final int? actType;
  final String? time;
  final String? description;
  final int? calorie;
  final int? carbohydrate;
  final int? protein;
  final int? fat;
  final List<String>? images;

  Diet copyWith({
    int? id,
    int? userId,
    int? feedId,
    int? actType,
    String? time,
    String? description,
    int? calorie,
    int? carbohydrate,
    int? protein,
    int? fat,
    List<String>? images,
  }) =>
      Diet(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        feedId: feedId ?? this.feedId,
        actType: actType ?? this.actType,
        time: time ?? this.time,
        description: description ?? this.description,
        calorie: calorie ?? this.calorie,
        carbohydrate: carbohydrate ?? this.carbohydrate,
        protein: protein ?? this.protein,
        fat: fat ?? this.fat,
        images: images ?? this.images,
      );

  factory Diet.fromJson(Map<String, dynamic> json) => Diet(
        id: json["id"],
        userId: json["user_id"],
        feedId: json["feed_id"],
        actType: json["act_type"],
        time: json["time"],
        description: json["description"],
        calorie: json["calorie"],
        carbohydrate: json["carbohydrate"],
        protein: json["protein"],
        fat: json["fat"],
        images: List<String>.from(json["images"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "feed_id": feedId,
        "act_type": actType,
        "time": time,
        "description": description,
        "calorie": calorie,
        "carbohydrate": carbohydrate,
        "protein": protein,
        "fat": fat,
        "images": images,
      };
}
