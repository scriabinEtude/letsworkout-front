import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:letsworkout/config/application.dart';
import 'package:letsworkout/module/api/api_error_interceptor.dart';
import 'package:letsworkout/module/api/pretty_dio_logger.dart';

List<Interceptor> interceptors = [
  ApiErrorInterceptor(),
  PrettyDioLogger(requestBody: true, logPrint: (obj) => log(obj as String)),
];

BaseOptions baseOptions = BaseOptions(
  baseUrl: Application.appMode.serverUrl,
  connectTimeout: 5000,
  receiveTimeout: 3000,
  contentType: Headers.jsonContentType,
  responseType: ResponseType.json,
);

Dio api = Dio(baseOptions)..interceptors.addAll(interceptors);

BaseOptions jpgOptions = BaseOptions(
  baseUrl: Application.appMode.serverUrl,
  connectTimeout: 5000,
  receiveTimeout: 3000,
  contentType: 'image/jpeg',
  responseType: ResponseType.json,
);

Dio apiJpg = Dio(jpgOptions)..interceptors.addAll(interceptors);

BaseOptions pngOptions = BaseOptions(
  baseUrl: Application.appMode.serverUrl,
  connectTimeout: 5000,
  receiveTimeout: 3000,
  contentType: 'image/png',
  responseType: ResponseType.json,
);

Dio apiPng = Dio(pngOptions)..interceptors.addAll(interceptors);
