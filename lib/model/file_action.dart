import 'package:letsworkout/enum/file_action_type.dart';
import 'package:letsworkout/model/signed_url.dart';

class FileAction {
  dynamic file;
  FileActionType type;
  SignedUrl? signedUrl;

  FileAction({
    required this.file,
    required this.type,
    this.signedUrl,
  });

  factory FileAction.fromJson(String filePath) => FileAction(
        file: filePath,
        type: FileActionType.none,
      );

  static List<FileAction> fromJsonList(List list) =>
      list.map((action) => FileAction.fromJson(action)).toList();

  Map<String, dynamic> toJson() {
    return {
      'file': file,
      'type': type.name,
      'signedUrl': signedUrl?.toJson(),
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
