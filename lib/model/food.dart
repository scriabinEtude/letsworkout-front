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

class ServingSize {
  ServingSize({
    required this.servingName,
    required this.servingSize,
  });

  final String servingName;
  final int servingSize;

  ServingSize copyWith({
    String? servingName,
    int? servingSize,
  }) =>
      ServingSize(
        servingName: servingName ?? this.servingName,
        servingSize: servingSize ?? this.servingSize,
      );

  factory ServingSize.fromJson(Map<String, dynamic> json) => ServingSize(
        servingName: json["servingName"],
        servingSize: json["servingSize"],
      );
  static List<ServingSize> fromJsonList(List? list) {
    return list == null
        ? []
        : list.map((e) => ServingSize.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() => {
        "servingName": servingName,
        "servingSize": servingSize,
      };
}

class Food {
  Food({
    this.dietFoodId,
    required this.foodName,
    required this.company,
    required this.unit,
    required this.calorie,
    required this.carbohydrate,
    required this.protein,
    required this.fat,
    required this.sugar,
    required this.sodium,
    this.description,
    this.refCount = 0,
    this.thanksto = const [],
    this.servingSizes = const [],
    this.createdAt,
    this.updatedAt,
  });

  final String? dietFoodId;
  final String foodName;
  final String company;
  final String unit;
  final int calorie;
  final int carbohydrate;
  final int protein;
  final int fat;
  final int sugar;
  final int sodium;
  String? description;
  List<Thanksto>? thanksto;
  List<ServingSize>? servingSizes;
  int refCount;
  final String? createdAt;
  final String? updatedAt;

  Food copyWith({
    String? dietFoodId,
    String? foodName,
    String? company,
    String? unit,
    int? calorie,
    int? carbohydrate,
    int? protein,
    int? fat,
    int? sugar,
    int? sodium,
    String? description,
    List<Thanksto>? thanksto,
    List<ServingSize>? servingSizes,
    int? refCount,
    String? createdAt,
    String? updatedAt,
  }) =>
      Food(
        dietFoodId: dietFoodId ?? this.dietFoodId,
        foodName: foodName ?? this.foodName,
        company: company ?? this.company,
        unit: unit ?? this.unit,
        calorie: calorie ?? this.calorie,
        carbohydrate: carbohydrate ?? this.carbohydrate,
        protein: protein ?? this.protein,
        fat: fat ?? this.fat,
        sugar: sugar ?? this.sugar,
        sodium: sodium ?? this.sodium,
        description: description ?? this.description,
        thanksto: thanksto ?? this.thanksto,
        servingSizes: servingSizes ?? this.servingSizes,
        refCount: refCount ?? this.refCount,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Food.fromJson(Map<String, dynamic> json) => Food(
        dietFoodId: json["_id"],
        foodName: json["foodName"],
        company: json["company"],
        unit: json['unit'],
        calorie: json["calorie"],
        carbohydrate: json["carbohydrate"],
        protein: json["protein"],
        fat: json["fat"],
        sugar: json["sugar"],
        sodium: json["sodium"],
        description: json["description"],
        thanksto: Thanksto.fromJsonList(json['thanksto']),
        servingSizes: ServingSize.fromJsonList(json['servingSizes']),
        refCount: json["refCount"],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
      );

  static List<Food> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((e) => Food.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() => {
        "_id": dietFoodId,
        "foodName": foodName,
        "company": company,
        "unit": unit,
        "calorie": calorie,
        "carbohydrate": carbohydrate,
        "protein": protein,
        "fat": fat,
        "sugar": sugar,
        "sodium": sodium,
        "description": description,
        "thanksto": thanksto?.map((e) => e.toJson()),
        "servingSizes": servingSizes?.map((e) => e.toJson()),
        "refCount": refCount,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
