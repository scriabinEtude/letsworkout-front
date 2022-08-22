import 'package:dio/dio.dart';
import 'package:letsworkout/model/food.dart';
import 'package:letsworkout/model/food_company.dart';
import 'package:letsworkout/module/api/api.dart';

class FoodRepository {
  static String _getUrl(String url) {
    return '/food$url';
  }

  Future<List<FoodCompany>> companySearch({
    required String company,
  }) async {
    try {
      Response result = await api.get(
        _getUrl('/company'),
        queryParameters: {'company': company},
      );

      return FoodCompany.fromJsonList(result.data);
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<Food?> validateFood({
    required String companyName,
    required String foodName,
  }) async {
    Response result = await api.get(_getUrl('/validate'), queryParameters: {
      'companyName': companyName,
      'foodName': foodName,
    });

    return (result.data == null || result.data == "")
        ? null
        : Food.fromJson(result.data);
  }

  Future<bool> saveFood(Food food) async {
    Response result = await api.post(
      _getUrl('/'),
      data: food.toJson(),
    );

    return result.statusCode == 200;
  }

  Future<List<Food>> searchFood({required String foodName}) async {
    Response result = await api
        .get(_getUrl('/search'), queryParameters: {'foodName': foodName});

    return Food.fromJsonList(result.data);
  }
}
