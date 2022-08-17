import 'package:letsworkout/enum/loading_state.dart';

class FoodWriteState {
  final LoadingState loading;
  final String? companyName;
  final String? foodName;
  final String? unit;
  final String? firstServingName;
  final String? firstServingSize;
  final int? calorie;
  final int? carbohydrate;
  final int? protein;
  final int? fat;
  final int? sugar;
  final int? sodium;
  String? description;

  FoodWriteState({
    this.loading = LoadingState.init,
    this.companyName,
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
    String? companyName,
    String? foodName,
    String? unit,
    String? firstServingName,
    String? firstServingSize,
    int? calorie,
    int? carbohydrate,
    int? protein,
    int? fat,
    int? sugar,
    int? sodium,
    String? description,
  }) =>
      FoodWriteState(
        loading: loading ?? this.loading,
        companyName: companyName ?? this.companyName,
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
