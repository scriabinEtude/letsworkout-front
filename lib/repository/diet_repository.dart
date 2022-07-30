import 'package:dio/dio.dart';
import 'package:letsworkout/model/diet.dart';
import 'package:letsworkout/model/food.dart';
import 'package:letsworkout/module/api/api.dart';

class DietRepository {
  String _getUrl(String url) {
    return '/diet$url';
  }

  Future<bool> insertDiet(Diet diet) async {
    try {
      Response result = await api.post(_getUrl('/'), data: diet.toJson());
      return result.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Food>> searchFood(
      {required String foodBrand, required String foodName}) async {
    Response result = await api.get(_getUrl('/food/search'),
        queryParameters: {'food_name': foodName, 'food_brand': foodBrand});

    return Food.fromJsonList(result.data);
  }

  Future<Response> foodWriteNameCheck({
    required String foodBrand,
    required String foodName,
  }) async {
    return await api.get(_getUrl('/food/name'), queryParameters: {
      'food_brand': foodBrand,
      'food_name': foodName,
    });
  }

  Future<Response> foodWrite({required Food food}) async {
    return await api.post(_getUrl('/food'), data: food.toJson());
  }

  Future<Response> requestFoodUpdate({required Food food}) async {
    return await api.post(_getUrl('/food/request'), data: food.toJson());
  }
}
