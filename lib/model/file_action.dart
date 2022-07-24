import 'package:letsworkout/enum/file_action_type.dart';
import 'package:letsworkout/model/signed_url.dart';

class FileAction {
  int? fileId;
  dynamic file;
  FileActionType type;
  SignedUrl? signedUrl;

  FileAction({
    this.fileId,
    required this.file,
    required this.type,
    this.signedUrl,
  });

  factory FileAction.fromJson(Map json) => FileAction(
        fileId: json['file_id'],
        file: json['image'],
        type: FileActionType.none,
      );

  static List<FileAction> fromJsonList(List list) =>
      list.map((action) => FileAction.fromJson(action)).toList();

  Map<String, dynamic> toJson() {
    return {
      'file_id': fileId,
      'file': file,
      'type': type.name,
      'signed_url': signedUrl?.toJson(),
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
