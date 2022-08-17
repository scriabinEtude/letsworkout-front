import 'package:flutter/material.dart';

enum FeedType {
  workout("운동", Color(0xFFCCF3FF)),
  diet("식단", Color(0xFFFFF3DD));

  final String title;
  final Color feedColor;

  const FeedType(this.title, this.feedColor);
}
