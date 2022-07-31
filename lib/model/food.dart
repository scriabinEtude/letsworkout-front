class Food {
  Food({
    this.dietFoodId,
    this.foodName,
    this.foodBrand,
    this.calorie,
    this.carbohydrate,
    this.protein,
    this.fat,
    this.sugar,
    this.sodium,
    this.multiply = 1,
    this.description,
    this.refCount,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  final int? dietFoodId;
  final String? foodName;
  final String? foodBrand;
  final int? calorie;
  final int? carbohydrate;
  final int? protein;
  final int? fat;
  final int? sugar;
  final int? sodium;
  final double multiply;
  final String? description;
  final int? refCount;
  final int? userId;
  final String? createdAt;
  final String? updatedAt;

  Food copyWith({
    int? dietFoodId,
    String? foodName,
    String? foodBrand,
    int? calorie,
    int? carbohydrate,
    int? protein,
    int? fat,
    int? sugar,
    int? sodium,
    double? multiply,
    String? description,
    int? refCount,
    int? userId,
    String? createdAt,
    String? updatedAt,
  }) =>
      Food(
        dietFoodId: dietFoodId ?? this.dietFoodId,
        foodName: foodName ?? this.foodName,
        foodBrand: foodBrand ?? this.foodBrand,
        calorie: calorie ?? this.calorie,
        carbohydrate: carbohydrate ?? this.carbohydrate,
        protein: protein ?? this.protein,
        fat: fat ?? this.fat,
        sugar: sugar ?? this.sugar,
        sodium: sodium ?? this.sodium,
        multiply: multiply ?? this.multiply,
        description: description ?? this.description,
        refCount: refCount ?? this.refCount,
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Food.fromJson(Map<String, dynamic> json) => Food(
        dietFoodId: json["diet_food_id"],
        foodName: json["food_name"],
        foodBrand: json["food_brand"],
        calorie: json["calorie"],
        carbohydrate: json["carbohydrate"],
        protein: json["protein"],
        fat: json["fat"],
        sugar: json["sugar"],
        sodium: json["sodium"],
        multiply: json["multiply"] ?? 1,
        description: json["description"],
        refCount: json["ref_count"],
        userId: json['user_id'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  static List<Food> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((e) => Food.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() => {
        "diet_food_id": dietFoodId,
        "food_name": foodName,
        "food_brand": foodBrand,
        "calorie": calorie,
        "carbohydrate": carbohydrate,
        "protein": protein,
        "fat": fat,
        "sugar": sugar,
        "sodium": sodium,
        "multiply": multiply,
        "description": description,
        "ref_count": refCount,
        "user_id": userId,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
