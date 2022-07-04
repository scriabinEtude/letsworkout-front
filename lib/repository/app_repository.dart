import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letsworkout/model/signed_url.dart';
import 'package:letsworkout/module/api/api.dart';
import 'package:letsworkout/util/other_util.dart';

class AppRepository {
  String _getUrl(String url) {
    return '/app$url';
  }

  Future<SignedUrl?> getSignedUrl({
    required String path,
    required String filename,
    required dynamic image,
  }) async {
    try {
      String ext = getImageExt(image);

      Response result = await api.get(
        _getUrl('/signedurl'),
        queryParameters: {
          'path': '$path/$filename.$ext',
          'ext': ext,
        },
      );

      return result.statusCode == 200 ? SignedUrl.fromJson(result.data) : null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<SignedUrl>?> getSignedUrls({
    required String path,
    required List<dynamic> images,
  }) async {
    try {
      String exts = images.map((image) => getImageExt(image)).join(',');

      Response result = await api.get(
        _getUrl('/signedurls'),
        queryParameters: {
          'path': path,
          'exts': exts,
        },
      );

      return result.statusCode == 200
          ? SignedUrl.fromJsonList(result.data['urls'])
          : null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> s3upload({required SignedUrl url, required dynamic file}) async {
    try {
      File image = file is XFile ? File(file.path) : file;

      Dio imageApi;

      if (url.ext == "png") {
        imageApi = apiPng;
      } else {
        imageApi = apiJpg;
      }

      Response result = await imageApi.putUri<void>(
        Uri.parse(url.signedUrl),
        data: image.openRead(),
        options: Options(headers: <String, dynamic>{
          HttpHeaders.contentLengthHeader: image.lengthSync(),
        }),
      );

      return result.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
