import 'package:dio/dio.dart';
import 'package:letsworkout/config/application.dart';
import 'package:letsworkout/module/api/api_error_interceptor.dart';
import 'package:letsworkout/module/api/pretty_dio_logger.dart';

BaseOptions baseOptions = BaseOptions(
  baseUrl: Application.appMode.serverUrl,
  connectTimeout: 5000,
  receiveTimeout: 3000,
  contentType: Headers.jsonContentType,
  responseType: ResponseType.json,
);

Dio api = Dio(baseOptions)
  ..interceptors.addAll([
    ApiErrorInterceptor(),
    PrettyDioLogger(
      requestBody: true,
    ),
  ]);
