import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/model/food.dart';
import 'package:letsworkout/repository/diet_repository.dart';
import 'package:letsworkout/util/string_util.dart';
import 'package:letsworkout/util/widget_util.dart';

class DietFoodWriteScreen extends StatefulWidget {
  const DietFoodWriteScreen({Key? key}) : super(key: key);

  @override
  State<DietFoodWriteScreen> createState() => _DietFoodWriteScreenState();
}

class _DietFoodWriteScreenState extends State<DietFoodWriteScreen> {
  final DietRepository _dietRepository = DietRepository();

  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _calorieController = TextEditingController();
  final TextEditingController _carboController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _sugarController = TextEditingController();
  final TextEditingController _sodiumController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _nameCheckValidation = false;
  bool _nameConfirmed = false;
  bool _saveValidation = false;

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

  void _nameCheckValidate(text) {
    setState(() {
      _nameConfirmed = false;
      _saveValidation = false;
      _nameCheckValidation = _foodNameController.text.isNotEmpty;
    });
  }

  void _saveValidate() {
    setState(() {
      _saveValidation = _nameConfirmed && _calorieController.text.isNotEmpty;
    });
  }

  Future<Response> _foodWriteNameCheck() async {
    return await _dietRepository.foodWriteNameCheck(
      foodBrand: _brandNameController.text.trim(),
      foodName: _foodNameController.text.trim(),
    );
  }

  Future _nameCheck() async {
    try {
      unFocus();
      loadingShow();
      setState(() {
        _nameCheckValidation = false;
      });

      Response response = await _foodWriteNameCheck();

      int code = response.data['code'];
      String message = response.data['message'];
      switch (code) {
        case 101: // 음식 이름 입력 안 했을 때
          showOkAlertDialog(context: context, message: message);
          setState(() {
            _nameConfirmed = false;
          });
          break;
        case 102: // 음식 이름 있을 때
          Food food = Food.fromJson(response.data['food']);

          showOkAlertDialog(
            context: context,
            message:
                '$message\n\n칼로리:${food.calorie}kcal\n탄수화물:${food.carbohydrate ?? '등록안됨'}g\n단백질:${food.protein ?? '등록안됨'}g\n지방:${food.fat ?? '등록안됨'}g',
          );
          setState(() {
            _nameConfirmed = false;
          });
          break;
        case 103: // 저장가능할 때
          showOkAlertDialog(
            context: context,
            message: message,
          );
          setState(() {
            _nameConfirmed = true;
            _saveValidate();
          });
      }
    } catch (e) {
      print(e);
    } finally {
      loadingHide();
    }
  }

  Future _save() async {
    try {
      unFocus();
      loadingShow();
      setState(() {
        _nameCheckValidation = false;
        _nameConfirmed = false;
        _saveValidation = false;
      });

      Response response = await _dietRepository.foodWrite(
          food: Food(
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
      ));

      if (response.statusCode == 200) {
        snack('등록 완료!');
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
        appBar: AppBar(title: const Text('음식 등록')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text('이름이 겹쳐도 브랜드가 다르면 저장 됩니다.'),
              TextField(
                controller: _foodNameController,
                onChanged: _nameCheckValidate,
                decoration: const InputDecoration(
                  label: Text('* 이름'),
                ),
              ),
              TextField(
                controller: _brandNameController,
                onChanged: _nameCheckValidate,
                decoration: const InputDecoration(
                  label: Text('브랜드'),
                ),
              ),
              ElevatedButton(
                onPressed: _nameCheckValidation ? _nameCheck : null,
                child: const Text('브랜드 & 이름 확인'),
              ),
              TextField(
                controller: _calorieController,
                keyboardType: TextInputType.number,
                onChanged: (text) => _saveValidate(),
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
              ElevatedButton(
                onPressed: _saveValidation ? _save : null,
                child: const Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
