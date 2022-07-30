import 'package:flutter/material.dart';

///```
/// Scaffold.actions 에 하나의 위젯만 필요할 때
///```
List<Widget> appBarSingleAction({
  required void Function() onTap,
  required Widget child,
  bool enabled = true,
}) {
  return [
    InkWell(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.3,
        child: Center(child: child),
      ),
    ),
    const SizedBox(width: 20),
  ];
}
