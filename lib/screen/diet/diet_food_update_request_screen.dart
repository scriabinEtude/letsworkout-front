import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/model/food.dart';
import 'package:letsworkout/repository/diet_repository.dart';
import 'package:letsworkout/util/string_util.dart';
import 'package:letsworkout/util/widget_util.dart';
import 'package:letsworkout/widget/scaffold.dart';

class DietFoodUpdateRequestScreen extends StatefulWidget {
  const DietFoodUpdateRequestScreen({
    Key? key,
    required this.food,
  }) : super(key: key);
  final Food food;

  @override
  State<DietFoodUpdateRequestScreen> createState() =>
      _DietFoodUpdateRequestScreenState();
}

class _DietFoodUpdateRequestScreenState
    extends State<DietFoodUpdateRequestScreen> {
  final DietRepository _dietRepository = DietRepository();
  late final TextEditingController _brandNameController;
  late final TextEditingController _foodNameController;
  late final TextEditingController _calorieController;
  late final TextEditingController _carboController;
  late final TextEditingController _proteinController;
  late final TextEditingController _fatController;
  late final TextEditingController _sugarController;
  late final TextEditingController _sodiumController;
  late final TextEditingController _descriptionController;
  bool _validation = true;

  @override
  void initState() {
    _brandNameController = TextEditingController(text: widget.food.foodBrand);
    _foodNameController = TextEditingController(text: widget.food.foodName);
    _calorieController =
        TextEditingController(text: intToString(widget.food.calorie));
    _carboController =
        TextEditingController(text: intToString(widget.food.calorie));
    _proteinController =
        TextEditingController(text: intToString(widget.food.calorie));
    _fatController =
        TextEditingController(text: intToString(widget.food.calorie));
    _sugarController =
        TextEditingController(text: intToString(widget.food.sugar));
    _sodiumController =
        TextEditingController(text: intToString(widget.food.sodium));
    _descriptionController =
        TextEditingController(text: widget.food.description);
    super.initState();
  }

  @override
  void dispose() {
    _brandNameController.dispose();
    _foodNameController.dispose();
    _calorieController.dispose();
    _carboController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    _sugarController.dispose();
    _sodiumController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _validate(String value) {
    setState(() {
      _validation = value.isNotEmpty;
    });
  }

  Future request() async {
    try {
      unFocus();
      loadingShow();

      Response response = await _dietRepository.requestFoodUpdate(
        food: Food(
          dietFoodId: widget.food.dietFoodId,
          foodBrand: _brandNameController.text.trim(),
          foodName: _foodNameController.text.trim(),
          calorie: parseStringNumber(_calorieController.text),
          carbohydrate: parseStringNumber(_carboController.text),
          protein: parseStringNumber(_proteinController.text),
          fat: parseStringNumber(_fatController.text),
          sugar: parseStringNumber(_sugarController.text),
          sodium: parseStringNumber(_sodiumController.text),
          description: _descriptionController.text,
          userId: AppBloc.userCubit.user!.userId,
        ),
      );

      if (response.statusCode == 200) {
        snack('수정 요청이 등록되었습니다. 감사합니다!');
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    } finally {
      loadingHide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: unFocus,
      child: Scaffold(
        appBar: AppBar(
          title: Text('수정요청'),
          actions: appBarSingleAction(
            enabled: _validation,
            onTap: request,
            child: const Text('요청'),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _foodNameController,
                enabled: false,
                decoration: const InputDecoration(
                  label: Text('* 이름'),
                ),
              ),
              TextField(
                controller: _brandNameController,
                enabled: false,
                decoration: const InputDecoration(
                  label: Text('브랜드'),
                ),
              ),
              TextField(
                controller: _calorieController,
                keyboardType: TextInputType.number,
                onChanged: (text) => _validate(text),
                decoration: const InputDecoration(
                  label: Text('* 칼로리'),
                ),
              ),
              TextField(
                controller: _carboController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text('탄수화물'),
                ),
              ),
              TextField(
                controller: _proteinController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text('단백질'),
                ),
              ),
              TextField(
                controller: _fatController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text('지방'),
                ),
              ),
              TextField(
                controller: _sugarController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text('당'),
                ),
              ),
              TextField(
                controller: _sodiumController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text('나트륨'),
                ),
              ),
              TextField(
                controller: _descriptionController,
                maxLength: 400,
                maxLines: null,
                decoration: const InputDecoration(
                  label: Text('설명'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
