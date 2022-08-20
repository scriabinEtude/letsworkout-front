import 'package:flutter/material.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/config/route.dart';
import 'package:letsworkout/model/food.dart';
import 'package:letsworkout/model/serving_size.dart';
import 'package:letsworkout/screen/diet/food_write/widgets.dart';
import 'package:letsworkout/util/string_util.dart';
import 'package:letsworkout/util/widget_util.dart';
import 'package:uuid/uuid.dart';

class DietFoodWrite5Servings extends StatefulWidget {
  const DietFoodWrite5Servings({Key? key}) : super(key: key);

  @override
  State<DietFoodWrite5Servings> createState() => _DietFoodWrite5ServingsState();
}

class _DietFoodWrite5ServingsState extends State<DietFoodWrite5Servings> {
  List<ServingSize> servings = [];
  String unit = AppBloc.foodWriteCubit.state.unit!;
  final Uuid uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('제공량 추가하기'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: DietFoodWriteFloatingButton(
        title: '완료',
        enable: true,
        onTap: () async {
          bool success =
              await AppBloc.foodWriteCubit.saveFood(servings: servings);

          if (success) {
            snack('음식 등록이 완료되었습니다!');
            Navigator.popUntil(
              context,
              (route) => route.settings.name == Routes.dietFoodSearchScreen,
            );
          }
        },
      ),
      body: Column(
        children: [
          Text('칼로리는 최초등록한 제공량 기준으로 자동 계산됩니다.'),
          servingAddButton(),
          ...servings.map((serving) => servingWidget(serving)),
        ],
      ),
    );
  }

  Widget servingWidget(ServingSize serving) {
    return Row(
      children: [
        Text('${serving.servingSize}${serving.display ?? ""}'),
        ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.red),
            onPressed: () {
              servings.remove(serving);
              setState(() {});
            },
            child: Text('삭제'))
      ],
    );
  }

  Widget servingAddButton() {
    Iterable<String> names = servings.map((serving) => serving.servingName);
    return InkWell(
      onTap: () async {
        ServingSize? result = await showDietFoodServingPicker(
            context: context,
            servingNames: [
              '100$unit',
              '1인분',
              '1회제공량',
              '개',
              '조각',
              '팩',
              '패키지',
              '봉지',
              '병',
              '캔',
              '잔',
              '포',
              '바',
              '모',
              '포기',
              '공기',
              '접시',
              '뚝배기',
              '움큼',
              '숟갈',
              '큰술',
              '작은술',
            ]
                .where((name) =>
                    name != AppBloc.foodWriteCubit.state.firstServingName! &&
                    !names.contains(name))
                .toList(),
            selectedUnit: unit);

        if (result != null) {
          servings.add(result);
          setState(() {});
        }
      },
      child: Text('+ 제공량 추가하기'),
    );
  }
}
