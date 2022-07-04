import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    Key? key,
    required this.size,
    this.image,
  }) : super(key: key);
  final dynamic image;
  final double size;

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object>? provider;

    if (image is String) {
      provider = Image.network(image).image;
    } else if (image is File) {
      provider = Image.file(image).image;
    } else if (image is XFile) {
      provider = Image.file(File((image as XFile).path)).image;
    }

    return CircleAvatar(
      radius: size,
      backgroundImage: provider,
    );
    ;
  }
}
