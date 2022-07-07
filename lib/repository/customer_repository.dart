import 'package:dio/dio.dart';
import 'package:letsworkout/model/customer_question.dart';
import 'package:letsworkout/module/api/api.dart';

class CustomerRepository {
  String _getUrl(String url) {
    return '/customer$url';
  }

  Future<bool> insertCustomerQuestion(
      {required CustomerQuestion customerQuestion}) async {
    try {
      Response result = await api.post(
        _getUrl('/question'),
        data: customerQuestion.toJson(),
      );

      return result.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
