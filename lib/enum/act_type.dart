import 'package:flutter/material.dart';

enum ActType {
  workout(Color(0xFFCCF3FF)),
  diet(Color(0xFFFFF3DD));

  final Color feedColor;

  const ActType(this.feedColor);
}
