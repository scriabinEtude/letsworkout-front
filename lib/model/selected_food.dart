class SelectedFood {
  SelectedFood({
    required this.foodName,
    required this.company,
    required this.unit,
    required this.selectedType,
    required this.multiply,
    required this.subFoodName,
    required this.servingName,
    required this.servingSize,
    required this.calorie,
    required this.carbohydrate,
    required this.protein,
    required this.fat,
    required this.sugar,
    required this.sodium,
  });

  final String foodName;
  final String company;
  final String unit;
  final String selectedType;
  final double multiply;
  final String subFoodName;
  final String servingName;
  final int servingSize;
  final int calorie;
  final int carbohydrate;
  final int protein;
  final int fat;
  final int sugar;
  final int sodium;

  SelectedFood copyWith({
    String? foodName,
    String? company,
    String? unit,
    String? selectedType,
    double? multiply,
    String? subFoodName,
    String? servingName,
    int? servingSize,
    int? calorie,
    int? carbohydrate,
    int? protein,
    int? fat,
    int? sugar,
    int? sodium,
  }) =>
      SelectedFood(
        foodName: foodName ?? this.foodName,
        company: company ?? this.company,
        unit: unit ?? this.unit,
        selectedType: selectedType ?? this.selectedType,
        multiply: multiply ?? this.multiply,
        subFoodName: subFoodName ?? this.subFoodName,
        servingName: servingName ?? this.servingName,
        servingSize: servingSize ?? this.servingSize,
        calorie: calorie ?? this.calorie,
        carbohydrate: carbohydrate ?? this.carbohydrate,
        protein: protein ?? this.protein,
        fat: fat ?? this.fat,
        sugar: sugar ?? this.sugar,
        sodium: sodium ?? this.sodium,
      );

  factory SelectedFood.fromJson(Map<String, dynamic> json) => SelectedFood(
        foodName: json["foodName"],
        company: json["company"],
        unit: json["unit"],
        selectedType: json["selectedType"],
        multiply: json["multiply"]?.toDouble(),
        subFoodName: json["subFoodName"],
        servingName: json["servingName"],
        servingSize: json["servingSize"],
        calorie: json["calorie"],
        carbohydrate: json["carbohydrate"],
        protein: json["protein"],
        fat: json["fat"],
        sugar: json["sugar"],
        sodium: json["sodium"],
      );

  static List<SelectedFood> fromJsonList(List? list) {
    return list == null
        ? []
        : list.map((e) => SelectedFood.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() => {
        "foodName": foodName,
        "company": company,
        "unit": unit,
        "selectedType": selectedType,
        "multiply": multiply,
        "subFoodName": subFoodName,
        "servingName": servingName,
        "servingSize": servingSize,
        "calorie": calorie,
        "carbohydrate": carbohydrate,
        "protein": protein,
        "fat": fat,
        "sugar": sugar,
        "sodium": sodium,
      };

  bool eq(SelectedFood food) {
    return foodName == food.foodName && company == food.company;
  }
}
