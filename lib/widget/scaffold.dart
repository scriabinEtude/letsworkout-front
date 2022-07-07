import 'package:flutter/material.dart';

///```
/// Scaffold.actions 에 하나의 위젯만 필요할 때
///```
List<Widget> scaffoldSingleAction({
  required void Function() onTap,
  required Widget child,
}) {
  return [
    InkWell(
      onTap: onTap,
      child: Center(child: child),
    ),
    const SizedBox(width: 20),
  ];
}
