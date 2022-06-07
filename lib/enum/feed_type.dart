import 'package:flutter/material.dart';

enum FeedType {
  workout(Color(0xFFCCF3FF)),
  diet(Color(0xFFFFF3DD));

  final Color feedColor;

  const FeedType(this.feedColor);
}
