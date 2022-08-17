import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class DietFoodWriteFloatingButton extends StatelessWidget {
  const DietFoodWriteFloatingButton({
    Key? key,
    required this.title,
    required this.enable,
    required this.onTap,
  }) : super(key: key);
  final String title;
  final bool enable;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enable ? 1 : 0.2,
      child: InkWell(
        onTap: enable ? onTap : null,
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width - 100,
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(title),
          ),
        ),
      ),
    );
  }
}
