import 'dart:io';

import 'package:image_picker/image_picker.dart';

String getImageExt(dynamic image) {
  if (image is File) {
    return image.path.substring(image.path.lastIndexOf(".") + 1);
  } else if (image is XFile) {
    return image.name.substring(image.name.lastIndexOf(".") + 1);
  } else {
    return "jpg";
  }
}
