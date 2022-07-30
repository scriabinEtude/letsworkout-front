import 'package:flutter/material.dart';
import 'package:letsworkout/model/food.dart';

class FoodTag extends StatelessWidget {
  const FoodTag({
    Key? key,
    required this.food,
  }) : super(key: key);
  final Food food;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 1,
            color: Colors.grey[400]!,
          )
        ],
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(food.foodName!),
        ],
      ),
    );
  }
}
