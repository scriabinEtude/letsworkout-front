import 'package:flutter/material.dart';
import 'package:letsworkout/model/food.dart';
import 'package:letsworkout/util/string_util.dart';

class FoodTag extends StatelessWidget {
  const FoodTag({
    Key? key,
    required this.food,
    required this.onTap,
    this.deleteActive = false,
    this.onDelete,
  }) : super(key: key);
  final Food food;
  final void Function() onTap;
  final bool deleteActive;
  final void Function(Food)? onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (deleteActive) {
          onDelete!(food);
        } else {
          onTap();
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(food.foodName!),
                    Text(' ${cutFixIfZero(food.multiply)}개'),
                  ],
                ),
                FoodInfoTextWidget(
                  value: food.calorie,
                  prefix: '칼로리: ',
                  suffix: 'kcal',
                  multiply: food.multiply,
                  ifNullValueText: '-',
                ),
                FoodInfoTextWidget(
                  value: food.carbohydrate,
                  prefix: '탄수화물: ',
                  suffix: 'g',
                  multiply: food.multiply,
                  ifNullValueText: '-',
                ),
                FoodInfoTextWidget(
                  value: food.protein,
                  prefix: '단백질: ',
                  suffix: 'g',
                  multiply: food.multiply,
                  ifNullValueText: '-',
                ),
                FoodInfoTextWidget(
                  value: food.fat,
                  prefix: '지방: ',
                  suffix: 'g',
                  multiply: food.multiply,
                  ifNullValueText: '-',
                ),
                FoodInfoTextWidget(
                  value: food.sugar,
                  prefix: '당: ',
                  suffix: 'g',
                  multiply: food.multiply,
                  ifNullValueText: '-',
                ),
                FoodInfoTextWidget(
                  value: food.sodium,
                  prefix: '나트륨: ',
                  suffix: 'mg',
                  multiply: food.multiply,
                  ifNullValueText: '-',
                ),
              ],
            ),
          ),
          if (deleteActive)
            Positioned(
              top: -7,
              right: -7,
              child: InkWell(
                onTap: onDelete == null ? null : () => onDelete!(food),
                child: const Icon(
                  Icons.cancel,
                  size: 20,
                ),
              ),
            )
        ],
      ),
    );
  }
}

class FoodTagDialog extends StatefulWidget {
  const FoodTagDialog({
    Key? key,
    required this.food,
  }) : super(key: key);
  final Food food;

  @override
  State<FoodTagDialog> createState() => _FoodTagDialogState();
}

class _FoodTagDialogState extends State<FoodTagDialog> {
  late Food food;

  @override
  void initState() {
    food = widget.food;
    super.initState();
  }

  void addMultiply(double add) {
    if (food.multiply + add <= 0) return;

    setState(() {
      food = food.copyWith(multiply: food.multiply + add);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          width: 300,
          height: 550,
          child: Column(
            children: [
              SizedBox(
                width: 300,
                height: 500,
                child: ListView(
                  children: [
                    Text(food.foodName!),
                    if (food.foodBrand != null) Text(food.foodBrand!),
                    FoodInfoTextWidget(
                      value: food.calorie,
                      prefix: '칼로리: ',
                      suffix: 'kcal',
                      multiply: food.multiply,
                      ifNullValueText: '등록안됨',
                    ),
                    FoodInfoTextWidget(
                        value: food.carbohydrate,
                        prefix: '탄수화물: ',
                        suffix: 'g',
                        multiply: food.multiply),
                    FoodInfoTextWidget(
                        value: food.protein,
                        prefix: '단백질: ',
                        suffix: 'g',
                        multiply: food.multiply),
                    FoodInfoTextWidget(
                        value: food.fat,
                        prefix: '지방: ',
                        suffix: 'g',
                        multiply: food.multiply),
                    FoodInfoTextWidget(
                        value: food.sugar,
                        prefix: '당: ',
                        suffix: 'g',
                        multiply: food.multiply),
                    FoodInfoTextWidget(
                        value: food.sodium,
                        prefix: '나트륨: ',
                        suffix: 'mg',
                        multiply: food.multiply),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(food.multiply.toStringAsFixed(1)),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              multiplier(0.1),
                              multiplier(0.5),
                              multiplier(1),
                              multiplier(5),
                            ],
                          ),
                        )
                      ],
                    ),
                    Text(
                      food.description ?? "",
                      overflow: TextOverflow.clip,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        color: const Color(0xfffcd5ce),
                        height: 50,
                        child: Center(child: Text('취소')),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.pop(context, food),
                      child: Container(
                        color: const Color(0xff8ecae6),
                        height: 50,
                        child: Center(child: Text('확인')),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget multiplier(double add) {
    return Row(
      children: [
        InkWell(
          onTap: () => addMultiply(-add),
          child: const Icon(
            Icons.arrow_left,
            size: 30,
          ),
        ),
        Text('$add'),
        InkWell(
          onTap: () => addMultiply(add),
          child: const Icon(
            Icons.arrow_right,
            size: 30,
          ),
        ),
      ],
    );
  }
}

class FoodInfoTextWidget extends StatelessWidget {
  const FoodInfoTextWidget({
    Key? key,
    required this.value,
    required this.prefix,
    required this.suffix,
    this.multiply = 1,
    this.ifNullValueText,
  }) : super(key: key);

  final int? value;
  final String prefix;
  final String suffix;
  final double multiply;
  final String? ifNullValueText;

  @override
  Widget build(BuildContext context) {
    if (value == null) {
      if (ifNullValueText != null) {
        return Text('$prefix$ifNullValueText');
      } else {
        return const SizedBox.shrink();
      }
    } else {
      return Text(
        foodInfoText(
          value: (value! * multiply).toInt(),
          prefix: prefix,
          suffix: suffix,
        ),
      );
    }
  }
}

String foodInfoText({
  required int? value,
  required String prefix,
  required String suffix,
}) {
  if (value == null || value == 0) return "";
  return '$prefix$value$suffix';
}
