import 'package:letsworkout/model/food.dart';
import 'package:letsworkout/model/selected_food.dart';

class Diet {
  Diet({
    this.calorie,
    this.carbohydrate,
    this.protein,
    this.fat,
    this.sugar,
    this.sodium,
    this.selectedFoods,
  });

  final int? calorie;
  final int? carbohydrate;
  final int? protein;
  final int? fat;
  final int? sugar;
  final int? sodium;
  final List<SelectedFood>? selectedFoods;

  Diet copyWith({
    String? description,
    int? calorie,
    int? carbohydrate,
    int? protein,
    int? fat,
    int? sugar,
    int? sodium,
    List<SelectedFood>? selectedFoods,
  }) =>
      Diet(
        calorie: calorie ?? this.calorie,
        carbohydrate: carbohydrate ?? this.carbohydrate,
        protein: protein ?? this.protein,
        fat: fat ?? this.fat,
        sugar: sugar ?? this.sugar,
        sodium: sodium ?? this.sodium,
        selectedFoods: selectedFoods ?? this.selectedFoods,
      );

  static Diet? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    return Diet(
      calorie: json["calorie"],
      carbohydrate: json["carbohydrate"],
      protein: json["protein"],
      fat: json["fat"],
      sugar: json["sugar"],
      sodium: json["sodium"],
      selectedFoods: SelectedFood.fromJsonList(json["foods"]),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "calorie": calorie,
        "carbohydrate": carbohydrate,
        "protein": protein,
        "fat": fat,
        "sugar": sugar,
        "sodium": sodium,
        "foods": selectedFoods?.map((food) => food.toJson()).toList(),
      };
}
