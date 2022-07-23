import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
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

ImageProvider<Object> getImageProvider(dynamic image) {
  if (image is String) {
    return CachedNetworkImageProvider(image);
  } else if (image is File) {
    return Image.file(image).image;
  } else if (image is XFile) {
    return Image.file(File(image.path)).image;
  } else {
    return Image.asset('assets/images/oops.png').image;
  }
}
