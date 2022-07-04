import 'package:dio/dio.dart';
import 'package:letsworkout/model/diet.dart';
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
}
