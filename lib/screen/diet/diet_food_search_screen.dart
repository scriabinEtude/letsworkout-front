import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:letsworkout/config/route.dart';
import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/food.dart';
import 'package:letsworkout/repository/food_repository.dart';
import 'package:letsworkout/screen/diet/diet_food_widgets.dart';
import 'package:letsworkout/widget/scaffold.dart';
import 'package:substring_highlight/substring_highlight.dart';

class DietFoodSearchScreen extends StatefulWidget {
  const DietFoodSearchScreen({Key? key}) : super(key: key);

  @override
  State<DietFoodSearchScreen> createState() => _DietFoodSearchScreenState();
}

class _DietFoodSearchScreenState extends State<DietFoodSearchScreen> {
  final _foodNameController = TextEditingController();
  final _foodRepository = FoodRepository();
  List<Food> _searchFoods = [];
  LoadingState _state = LoadingState.init;

  @override
  void dispose() {
    EasyDebounce.cancel('search_food');
    _foodNameController.dispose();
    super.dispose();
  }

  _searchFoodDebouncer() async {
    EasyDebounce.debounce(
      'search_food',
      const Duration(milliseconds: 400),
      () => _searchFood(),
    );
  }

  _searchFood() async {
    try {
      if (_foodNameController.text.trim().isEmpty) {
        setState(() {
          _state = LoadingState.init;
        });
        return;
      }

      _searchFoods = await _foodRepository.searchFood(
        foodName: _foodNameController.text.trim(),
      );
      setState(() {
        _state = LoadingState.done;
      });
    } catch (e) {
      print(e);
      setState(() {
        _state = LoadingState.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('음식 찾기'),
        actions: appBarSingleAction(
          onTap: () =>
              Navigator.pushNamed(context, Routes.dietFoodWrite1CompanyScreen),
          child: const Text('등록'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              DietFoodSearchBar(
                label: '음식',
                controller: _foodNameController,
                onChanged: (text) => _searchFoodDebouncer(),
              ),
              if (_state == LoadingState.init)
                initWidget()
              else if (_state == LoadingState.done && _searchFoods.isEmpty)
                emptyWidget()
              else if (_state == LoadingState.done)
                ..._searchFoods.map((food) => foodWidget(food))
              else if (_state == LoadingState.error)
                errorWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget initWidget() {
    return stateWidgetContainer(
      child: Text('검색해주세요'),
    );
  }

  Widget emptyWidget() {
    return stateWidgetContainer(
      child: Text('검색 결과 없음'),
    );
  }

  Widget errorWidget() {
    return stateWidgetContainer(
      child: Text('에러'),
    );
  }

  Widget foodWidget(Food food) {
    String foodInfo = foodInfoText(
            value: food.calorie, prefix: '칼: ', suffix: 'kcal / ') +
        foodInfoText(value: food.carbohydrate, prefix: '탄: ', suffix: 'g / ') +
        foodInfoText(value: food.protein, prefix: '단: ', suffix: 'g / ') +
        foodInfoText(value: food.fat, prefix: '지: ', suffix: 'g / ') +
        foodInfoText(value: food.sugar, prefix: '당: ', suffix: 'g / ') +
        foodInfoText(value: food.sodium, prefix: '나: ', suffix: 'mg / ');

    foodInfo = foodInfo.substring(0, foodInfo.length - 3);

    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => Navigator.pushNamed(
                  context, Routes.dietFoodDetailScreen,
                  arguments: {'food': food}),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SubstringHighlight(
                        term: _foodNameController.text,
                        text: food.foodName,
                        textStyleHighlight:
                            const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text('🙌 : ${food.refCount}'),
                    ],
                  ),
                  Row(
                    children: [
                      Text(food.company.name + " | "),
                      Text(
                        food.servingSizes!
                            .map((serving) =>
                                "${serving.servingName} (${serving.servingSize}${food.unit})")
                            .toList()
                            .join(", "),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "${food.servingSizes![0].servingName} (${food.servingSizes![0].servingSize}${food.unit}) 기준 "),
                      Text(
                          '${Food.sizeFrom100g(food.calorie, food.servingSizes![0].servingSize)} kcal'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NutiritionContainer(
                          title: '탄수화물',
                          unit: 'g',
                          nutrition: Food.sizeFrom100g(food.carbohydrate,
                              food.servingSizes![0].servingSize)),
                      NutiritionContainer(
                          title: '단백질',
                          unit: 'g',
                          nutrition: Food.sizeFrom100g(
                              food.protein, food.servingSizes![0].servingSize)),
                      NutiritionContainer(
                          title: '지방',
                          unit: 'g',
                          nutrition: Food.sizeFrom100g(
                              food.fat, food.servingSizes![0].servingSize)),
                      NutiritionContainer(
                          title: '당',
                          unit: 'g',
                          nutrition: Food.sizeFrom100g(
                              food.sugar, food.servingSizes![0].servingSize)),
                      NutiritionContainer(
                          title: '나트륨',
                          unit: 'mg',
                          nutrition: Food.sizeFrom100g(
                              food.sodium, food.servingSizes![0].servingSize)),
                    ],
                  ),

                  // InkWell(
                  //   onTap: () => Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) =>
                  //           DietFoodDetailScreen(food: food),
                  //     ),
                  //   ),
                  //   child: Text('정보       '),
                  // ),
                  // InkWell(
                  //   onTap: () => Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) =>
                  //           DietFoodUpdateRequestScreen(food: food),
                  //     ),
                  //   ),
                  //   child: Text('수정'),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget stateWidgetContainer({required Widget child}) {
    return Container(
      margin: EdgeInsets.only(top: 100),
      child: child,
    );
  }
}

class NutiritionContainer extends StatelessWidget {
  const NutiritionContainer({
    Key? key,
    required this.title,
    required this.unit,
    required this.nutrition,
  }) : super(key: key);

  final String title;
  final String unit;
  final double nutrition;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Text(title),
      Text(nutrition.toString() + unit),
    ]));
  }
}

class DietFoodSearchBar extends StatelessWidget {
  const DietFoodSearchBar({
    Key? key,
    required this.label,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);
  final String label;
  final TextEditingController controller;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(label: Text(label)),
      controller: controller,
      onChanged: onChanged,
    );
  }
}
