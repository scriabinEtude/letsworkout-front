import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:letsworkout/config/route.dart';
import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/food.dart';
import 'package:letsworkout/repository/diet_repository.dart';
import 'package:letsworkout/screen/diet/diet_food_update_request_screen.dart';
import 'package:letsworkout/widget/scaffold.dart';
import 'package:substring_highlight/substring_highlight.dart';

class DietFoodSearchScreen extends StatefulWidget {
  const DietFoodSearchScreen({Key? key}) : super(key: key);

  @override
  State<DietFoodSearchScreen> createState() => _DietFoodSearchScreenState();
}

class _DietFoodSearchScreenState extends State<DietFoodSearchScreen> {
  final _foodNameController = TextEditingController();
  final _foodBrandController = TextEditingController();
  final DietRepository _dietRepository = DietRepository();
  List<Food> _searchFoods = [];
  LoadingState _state = LoadingState.init;

  @override
  void dispose() {
    EasyDebounce.cancel('search_food');
    _foodNameController.dispose();
    _foodBrandController.dispose();
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
      if (_foodBrandController.text.isEmpty &&
          _foodNameController.text.isEmpty) {
        setState(() {
          _state = LoadingState.init;
        });
        return;
      }

      _searchFoods = await _dietRepository.searchFood(
        foodBrand: _foodBrandController.text,
        foodName: _foodNameController.text,
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
          onTap: () => Navigator.pushNamed(context, Routes.dietFoodWriteScreen),
          child: const Text('등록'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: DietFoodSearchBar(
                    label: '음식',
                    controller: _foodNameController,
                    onChanged: (text) => _searchFoodDebouncer(),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: DietFoodSearchBar(
                    label: '브랜드',
                    controller: _foodBrandController,
                    onChanged: (text) => _searchFoodDebouncer(),
                  ),
                ),
              ],
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
        foodInfoText(value: food.fat, prefix: '지: ', suffix: 'g / ');

    foodInfo = foodInfo.substring(0, foodInfo.length - 3);

    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => Navigator.pop(context, food),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (food.foodBrand != null && food.foodBrand!.isNotEmpty)
                        SubstringHighlight(
                          term: _foodBrandController.text,
                          text: '${food.foodBrand} ',
                          textStyleHighlight:
                              const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      SubstringHighlight(
                        term: _foodNameController.text,
                        text: food.foodName!,
                        textStyleHighlight:
                            const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Text(
                    foodInfo,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DietFoodUpdateRequestScreen(food: food),
              ),
            ),
            child: Text('수정'),
          ),
        ],
      ),
    );
  }

  String foodInfoText({
    required int? value,
    required String prefix,
    required String suffix,
  }) {
    if (value == null) return "";
    return '$prefix$value$suffix';
  }

  Widget stateWidgetContainer({required Widget child}) {
    return Container(
      margin: EdgeInsets.only(top: 100),
      child: child,
    );
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
