import 'dart:io';

import 'package:letsworkout/enum/bucket_path.dart';
import 'package:letsworkout/enum/file_action_type.dart';
import 'package:letsworkout/model/file_action.dart';
import 'package:letsworkout/model/signed_url.dart';
import 'package:letsworkout/module/error/letsworkout_error.dart';
import 'package:letsworkout/repository/app_repository.dart';

class FileActions {
  final List<FileAction> _actions;

  FileActions(this._actions);

  void add(File file) {
    _actions.add(FileAction(
      file: file,
      type: FileActionType.insert,
    ));
  }

  void delete(FileAction action) {
    if (action.type == FileActionType.insert) {
      _actions.remove(action);
    } else {
      action.type = FileActionType.delete;
    }
  }

  FileActions init() {
    for (FileAction action in _actions) {
      action.type = FileActionType.none;
    }

    return this;
  }

  bool get isEmpty => _actions.isEmpty;
  bool get isNotEmpty => _actions.isNotEmpty;

  List<FileAction> get listShowable =>
      _actions.where((action) => action.type != FileActionType.delete).toList();

  List<String> get listNetworkUrls =>
      _actions.map<String>((action) => action.file).toList();

  List<FileAction> get listInsertTypeActions =>
      _actions.where((action) => action.type == FileActionType.insert).toList();

  List<dynamic> get listInserts =>
      listInsertTypeActions.map((action) => action.file).toList();

  List<String> get listDbInsertUrl =>
      listInsertTypeActions.map((action) => action.signedUrl!.url).toList();

  factory FileActions.fromJsonList(List? list) {
    if (list == null) return FileActions([]);
    return FileActions(FileAction.fromJsonList(list));
  }

  Future<bool> uploadInsertFiles(BucketPath bucketPath) async {
    if (listInsertTypeActions.isEmpty) return true;

    try {
      await _setSignedUrls(bucketPath);
      await _s3upload();

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future _setSignedUrls(BucketPath bucketPath) async {
    List<SignedUrl>? urls = await AppRepository.getSignedUrls(
      bucketPath: bucketPath,
      images: listInserts,
    );

    if (urls == null) throw LetsworkoutError('signedurl 생성 에러');

    for (var i = 0; i < urls.length; i++) {
      listInsertTypeActions[i].signedUrl = urls[i];
    }
  }

  Future _s3upload() async {
    int length = listInsertTypeActions.length;
    List<FileAction> list = listInsertTypeActions;

    for (var i = 0; i < length; i++) {
      bool success = await AppRepository.s3upload(
        url: list[i].signedUrl!,
        file: list[i].file,
      );
      if (!success) throw LetsworkoutError('s3 업로드 실패');

      list[i].file = list[i].signedUrl!.url;
    }
  }

  List<Map<String, dynamic>> toJson() {
    return _actions.map((action) => action.toJson()).toList();
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
