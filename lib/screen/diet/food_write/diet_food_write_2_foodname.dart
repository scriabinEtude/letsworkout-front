import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/config/route.dart';
import 'package:letsworkout/model/food.dart';
import 'package:letsworkout/screen/diet/food_write/widgets.dart';
import 'package:letsworkout/util/widget_util.dart';
import 'package:letsworkout/widget/scaffold.dart';

class DietFoodWrite2FoodName extends StatefulWidget {
  const DietFoodWrite2FoodName({Key? key}) : super(key: key);

  @override
  State<DietFoodWrite2FoodName> createState() => _DietFoodWrite2FoodNameState();
}

class _DietFoodWrite2FoodNameState extends State<DietFoodWrite2FoodName> {
  final _foodNameController = TextEditingController();
  bool _validation = false;

  @override
  void dispose() {
    _foodNameController.dispose();
    super.dispose();
  }

  _validate() async {
    if (_foodNameController.text.isEmpty) {
      snack("음식 이름은 1글자 이상 기입해주세요");
      return;
    }

    unFocus();
    Food? food =
        await AppBloc.foodWriteCubit.validFoodName(_foodNameController.text);

    // food 가 없으면 다음 스탭 진행
    if (food == null) {
      Navigator.pushNamed(context, Routes.dietFoodWrite3UnitScreen);
      return;
    }

    // 있으면 정보수정 및 추가 제안 페이지로 이동
    else {
      OkCancelResult result = await showOkCancelAlertDialog(
        context: context,
        message: '이미 등록된 음식입니다\n음식 정보로 이동하시겠어요?',
        okLabel: '이동',
        cancelLabel: '취소',
      );

      if (result == OkCancelResult.ok) {
        // 이동
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이름 등록'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: DietFoodWriteFloatingButton(
        title: '다음',
        enable: _foodNameController.text.isNotEmpty,
        onTap: _validate,
      ),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(label: Text('음식 이름')),
            controller: _foodNameController,
            onChanged: (text) {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
