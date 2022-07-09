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

  Future<List<CustomerQuestion>?> getCustomerQuestions() async {
    try {
      Response result = await api.get(
        _getUrl('/question'),
      );

      if (result.statusCode == 200) {
        return CustomerQuestion.fromJsonList(result.data);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
