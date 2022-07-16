import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letsworkout/enum/bucket_path.dart';
import 'package:letsworkout/model/signed_url.dart';
import 'package:letsworkout/module/api/api.dart';
import 'package:letsworkout/util/file_util.dart';

class AppRepository {
  static String _getUrl(String url) {
    return '/app$url';
  }

  static Future<SignedUrl?> getSignedUrl({
    required BucketPath bucketPath,
    required String filename,
    required dynamic image,
  }) async {
    try {
      String ext = getImageExt(image);

      Response result = await api.get(
        _getUrl('/signedurl'),
        queryParameters: {
          'path': '${bucketPath.path}/$filename.$ext',
          'ext': ext,
        },
      );

      return result.statusCode == 200 ? SignedUrl.fromJson(result.data) : null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  ///```
  ///
  /// @param path 버킷주소가 될 경로
  ///```
  static Future<List<SignedUrl>?> getSignedUrls({
    required BucketPath bucketPath,
    required List<dynamic> images,
  }) async {
    try {
      String exts = images.map((image) => getImageExt(image)).join(',');

      Response result = await api.get(
        _getUrl('/signedurls'),
        queryParameters: {
          'path': bucketPath.path,
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

  static Future<bool> s3upload(
      {required SignedUrl url, required dynamic file}) async {
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
