import 'package:letsworkout/model/food_company.dart';
import 'package:letsworkout/model/serving_size.dart';
import 'package:letsworkout/model/thanksto.dart';

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
  final FoodCompany company;
  final String unit;
  final double calorie;
  final double carbohydrate;
  final double protein;
  final double fat;
  final double sugar;
  final double sodium;
  String? description;
  List<Thanksto>? thanksto;
  List<ServingSize>? servingSizes;
  int refCount;
  final String? createdAt;
  final String? updatedAt;

  Food copyWith({
    String? dietFoodId,
    String? foodName,
    FoodCompany? company,
    String? unit,
    double? calorie,
    double? carbohydrate,
    double? protein,
    double? fat,
    double? sugar,
    double? sodium,
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
        company: FoodCompany.fromJson(json["company"]),
        unit: json['unit'],
        calorie: json["calorie"].toDouble(),
        carbohydrate: json["carbohydrate"].toDouble(),
        protein: json["protein"].toDouble(),
        fat: json["fat"].toDouble(),
        sugar: json["sugar"].toDouble(),
        sodium: json["sodium"].toDouble(),
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
        "thanksto": thanksto?.map((e) => e.toJson()).toList(),
        "servingSizes": servingSizes?.map((e) => e.toJson()).toList(),
        "refCount": refCount,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };

  static double g100FromSize(double value, int size) {
    return double.parse((value * 100 / size).toStringAsFixed(2));
  }

  static double sizeFrom100g(double value, int size) {
    return double.parse((value * (size / 100)).toStringAsFixed(2));
  }
}
