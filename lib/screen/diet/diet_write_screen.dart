import 'dart:developer';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/bloc/cubit/diet_cubit.dart';
import 'package:letsworkout/config/route.dart';
import 'package:letsworkout/model/diet.dart';
import 'package:letsworkout/model/file_actions.dart';
import 'package:letsworkout/model/food.dart';
import 'package:letsworkout/screen/diet/diet_food_widgets.dart';
import 'package:letsworkout/util/date_util.dart';
import 'package:letsworkout/util/string_util.dart';
import 'package:letsworkout/util/widget_util.dart';
import 'package:letsworkout/widget/photo_cards.dart';
import 'package:letsworkout/widget/scaffold.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DietWriteScreen extends StatefulWidget {
  const DietWriteScreen({Key? key}) : super(key: key);

  @override
  State<DietWriteScreen> createState() => _DietWriteScreenState();
}

class _DietWriteScreenState extends State<DietWriteScreen> {
  final DietCubit _dietCubit = DietCubit();

  DateTime _time = DateTime.now();

  final TextEditingController _calorieController = TextEditingController();
  final TextEditingController _carboController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _sugarController = TextEditingController();
  final TextEditingController _sodiumController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final FileActions _images = FileActions([]);
  final List<Food> _selectedFoods = [];
  bool _deleteActive = false;

  // selected food
  int _foodCalorie = 0;
  int _foodCarboHydrate = 0;
  int _foodProtein = 0;
  int _foodFat = 0;
  int _foodSugar = 0;
  int _foodSodium = 0;

  // user input
  int _userCalorie = 0;
  int _userCarboHydrate = 0;
  int _userProtein = 0;
  int _userFat = 0;
  int _userSugar = 0;
  int _userSodium = 0;

  // total
  int _totalCalorie = 0;
  int _totalCarboHydrate = 0;
  int _totalProtein = 0;
  int _totalFat = 0;
  int _totalSugar = 0;
  int _totalSodium = 0;

  @override
  void dispose() {
    _calorieController.dispose();
    _carboController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    _sugarController.dispose();
    _sodiumController.dispose();
    _descriptionController.dispose();
    _dietCubit.close();
    super.dispose();
  }

  Future save() async {
    bool success = await _dietCubit.createDiet(
      diet: Diet(
        userId: AppBloc.userCubit.user!.userId!,
        time: mysqlDateTimeFormat(_time),
        description: _descriptionController.text,
        calorie: _totalCalorie,
        carbohydrate: _totalCarboHydrate,
        protein: _totalProtein,
        fat: _totalFat,
        sugar: _totalSugar,
        sodium: _totalSodium,
        images: _images,
        foods: _selectedFoods,
      ),
    );
    if (success) Navigator.pop(context);
  }

  void _calSelectedFood() {
    _foodCalorie = 0;
    _foodCarboHydrate = 0;
    _foodProtein = 0;
    _foodFat = 0;
    _foodSugar = 0;
    _foodSodium = 0;

    _selectedFoods.forEach((food) {
      int Function(int?) multiply = _multiply(food.multiply);

      _foodCalorie += multiply(food.calorie);
      _foodCarboHydrate += multiply(food.carbohydrate);
      _foodProtein += multiply(food.protein);
      _foodFat += multiply(food.fat);
      _foodSugar += multiply(food.sugar);
      _foodSodium += multiply(food.sodium);
    });

    getTotalNutrition();
  }

  void _getTotalCalorie(String value) {
    _userCalorie = parseStringNumber(value);
    _totalCalorie = _foodCalorie + _userCalorie;
    setState(() {});
  }

  void _getTotalCarbohydrate(String value) {
    _userCarboHydrate = parseStringNumber(value);
    _totalCarboHydrate = _foodCarboHydrate + _userCarboHydrate;
    setState(() {});
  }

  void _getTotalProtein(String value) {
    _userProtein = parseStringNumber(value);
    _totalProtein = _foodProtein + _userProtein;
    setState(() {});
  }

  void _getTotalFat(String value) {
    _userFat = parseStringNumber(value);
    _totalFat = _foodFat + _userFat;
    setState(() {});
  }

  void _getTotalSugar(String value) {
    _userSugar = parseStringNumber(value);
    _totalSugar = _foodSugar + _userSugar;
    setState(() {});
  }

  void _getTotalSodium(String value) {
    _userSodium = parseStringNumber(value);
    _totalSodium = _foodSodium + _userSodium;
    setState(() {});
  }

  void getTotalNutrition() {
    _totalCalorie = _foodCalorie + _userCalorie;
    _totalCarboHydrate = _foodCarboHydrate + _userCarboHydrate;
    _totalProtein = _foodProtein + _userProtein;
    _totalFat = _foodFat + _userFat;
    _totalSugar = _foodSugar + _userSugar;
    _totalSodium = _foodSodium + _userSodium;
    setState(() {});
  }

  int Function(int?) _multiply(double multiply) {
    return (int? nutrition) {
      if (nutrition == null) return 0;
      return (nutrition * multiply).toInt();
    };
  }

  Future _foodOnTap(Food food) async {
    Food? updatedFood = await showCupertinoDialog<Food?>(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return FoodTagDialog(food: food);
        });

    if (updatedFood != null) {
      int index = _selectedFoods.indexWhere(
          (selectedFood) => selectedFood.dietFoodId == updatedFood.dietFoodId);
      _selectedFoods[index] = updatedFood;
      _calSelectedFood();
      setState(() {});
    }
  }

  Future _foodOnDelete(Food food) async {
    OkCancelResult result = await showOkCancelAlertDialog(
      context: context,
      message: '음식을 삭제하시겠습니까?',
      okLabel: "확인",
      cancelLabel: "취소",
    );

    if (result == OkCancelResult.ok) {
      _selectedFoods.removeWhere(
          (selectedFood) => selectedFood.dietFoodId == food.dietFoodId);
      _deleteActive = false;
      _calSelectedFood();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: unFocus,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('식단 등록'),
          centerTitle: true,
          actions: appBarSingleAction(onTap: save, child: const Text('저장')),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              PhotoCards(
                isViewMode: false,
                images: _images,
                onActions: () => setState(() {}),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
              ),
              Row(
                children: [
                  foodSearchButton(),
                  foodDeleteActivate(),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: _selectedFoods
                    .map((food) => FoodTag(
                          food: food,
                          onTap: () => _foodOnTap(food),
                          deleteActive: _deleteActive,
                          onDelete: _foodOnDelete,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 10),
              timeWidget(),
              calorieWidget(),
              descriptionWidget(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget foodSearchButton() {
    return InkWell(
      onTap: () async {
        Food? food = await Navigator.pushNamed<Food?>(
            context, Routes.dietFoodSearchScreen);
        if (food == null) return;

        int selectedindex = _selectedFoods.indexWhere(
            (selectedFood) => selectedFood.dietFoodId == food.dietFoodId);
        if (selectedindex != -1) {
          AppBloc.appCubit.appSnackBar('이미 추가한 음식입니다\n음식을 눌러 수량을 조절해주세요');
          return;
        }

        setState(() {
          _selectedFoods.add(food);
          _calSelectedFood();
        });
      },
      child: Container(
        color: const Color(0xffccd5ae),
        width: 200,
        height: 50,
        child: const Center(
          child: Text('음식 찾기'),
        ),
      ),
    );
  }

  Widget foodDeleteActivate() {
    return InkWell(
      onTap: () async {
        _deleteActive = !_deleteActive;
        setState(() {});
      },
      child: Container(
        color: const Color(0xffffb4a2),
        width: 200,
        height: 50,
        child: const Center(
          child: Text('음식 삭제'),
        ),
      ),
    );
  }

  Widget timeWidget() {
    return Row(
      children: [
        Text('시간'),
        InkWell(
          onTap: () {
            showCupertinoModalBottomSheet(
                context: context,
                builder: (context) {
                  return SizedBox(
                    height: 300,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      onDateTimeChanged: (d) {
                        setState(() {
                          _time = d;
                        });
                      },
                    ),
                  );
                });
            // showTimePicker(context: context, initialTime: TimeOfDay.now());
          },
          child: Container(
            height: 100,
            child: Text(
              DateFormat('jm').format(_time),
            ),
          ),
        ),
      ],
    );
  }

  Widget descriptionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('설명'),
        TextField(
          controller: _descriptionController,
          maxLength: 200,
          maxLines: null,
          decoration: const InputDecoration(
            counterText: "",
          ),
        ),
      ],
    );
  }

  Widget calorieWidget() {
    return Column(
      children: [
        NutritionField(
          title: '칼로리',
          foodNutrition: _foodCalorie,
          controller: _calorieController,
          onChanged: _getTotalCalorie,
          totalNutrition: _totalCalorie,
          suffix: 'Kcal',
        ),
        NutritionField(
          title: '탄수화물',
          foodNutrition: _foodCarboHydrate,
          controller: _carboController,
          onChanged: _getTotalCarbohydrate,
          totalNutrition: _totalCarboHydrate,
          suffix: 'g',
        ),
        NutritionField(
          title: '단백질',
          foodNutrition: _foodProtein,
          controller: _proteinController,
          onChanged: _getTotalProtein,
          totalNutrition: _totalProtein,
          suffix: 'g',
        ),
        NutritionField(
          title: '지방',
          foodNutrition: _foodFat,
          controller: _fatController,
          onChanged: _getTotalFat,
          totalNutrition: _totalFat,
          suffix: 'g',
        ),
        NutritionField(
          title: '당',
          foodNutrition: _foodSugar,
          controller: _sugarController,
          onChanged: _getTotalSugar,
          totalNutrition: _totalSugar,
          suffix: 'g',
        ),
        NutritionField(
          title: '나트륨',
          foodNutrition: _foodSodium,
          controller: _sodiumController,
          onChanged: _getTotalSodium,
          totalNutrition: _totalSodium,
          suffix: 'mg',
        ),
      ],
    );
  }
}

class NutritionField extends StatelessWidget {
  const NutritionField({
    Key? key,
    required this.title,
    required this.foodNutrition,
    required this.controller,
    required this.onChanged,
    required this.totalNutrition,
    required this.suffix,
  }) : super(key: key);

  final String title;
  final int foodNutrition;
  final TextEditingController controller;
  final void Function(String) onChanged;
  final int totalNutrition;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title),
        Text('$foodNutrition'),
        Text('+'),
        SizedBox(
          width: 60,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            onChanged: onChanged,
            maxLength: 4,
            decoration: const InputDecoration(
              counterText: "",
            ),
          ),
        ),
        Text('='),
        Text('$totalNutrition$suffix'),
      ],
    );
  }
}
