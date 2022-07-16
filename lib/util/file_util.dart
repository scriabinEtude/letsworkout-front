import 'dart:io';

import 'package:flutter/material.dart';
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

ImageProvider<Object>? getImageProvider(dynamic image) {
  ImageProvider<Object>? provider;

  if (image is String) {
    provider = Image.network(image).image;
  } else if (image is File) {
    provider = Image.file(image).image;
  } else if (image is XFile) {
    provider = Image.file(File(image.path)).image;
  }

  return provider;
}
