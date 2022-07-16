import 'package:flutter/material.dart';
import 'package:letsworkout/util/file_util.dart';

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
    return CircleAvatar(
      radius: size,
      backgroundImage: getImageProvider(image),
    );
  }
}
