import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/food_company.dart';

class FoodWriteState {
  final LoadingState loading;
  final FoodCompany? company;
  final String? foodName;
  final String? unit;
  final String? firstServingName;
  final int? firstServingSize;
  final double? calorie;
  final double? carbohydrate;
  final double? protein;
  final double? fat;
  final double? sugar;
  final double? sodium;
  String? description;

  FoodWriteState({
    this.loading = LoadingState.init,
    this.company,
    this.foodName,
    this.unit,
    this.firstServingName,
    this.firstServingSize,
    this.calorie,
    this.carbohydrate,
    this.protein,
    this.fat,
    this.sugar,
    this.sodium,
    this.description,
  });

  FoodWriteState copyWith({
    LoadingState? loading,
    FoodCompany? company,
    String? foodName,
    String? unit,
    String? firstServingName,
    int? firstServingSize,
    double? calorie,
    double? carbohydrate,
    double? protein,
    double? fat,
    double? sugar,
    double? sodium,
    String? description,
  }) =>
      FoodWriteState(
        loading: loading ?? this.loading,
        company: company ?? this.company,
        foodName: foodName ?? this.foodName,
        unit: unit ?? this.unit,
        firstServingName: firstServingName ?? this.firstServingName,
        firstServingSize: firstServingSize ?? this.firstServingSize,
        calorie: calorie ?? this.calorie,
        carbohydrate: carbohydrate ?? this.carbohydrate,
        protein: protein ?? this.protein,
        fat: fat ?? this.fat,
        sugar: sugar ?? this.sugar,
        sodium: sodium ?? this.sodium,
        description: description ?? this.description,
      );
}
