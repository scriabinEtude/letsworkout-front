import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:letsworkout/bloc/cubit/diet_cubit.dart';
import 'package:letsworkout/model/file_action.dart';
import 'package:letsworkout/model/file_actions.dart';
import 'package:letsworkout/util/string_util.dart';
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
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _calorieController = TextEditingController();
  final TextEditingController _carboController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();

  final FileActions _images = FileActions([]);

  @override
  void dispose() {
    _descriptionController.dispose();
    _calorieController.dispose();
    _carboController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    _dietCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('식단 등록'),
          centerTitle: true,
          actions: scaffoldSingleAction(
              onTap: () async {
                bool success = await _dietCubit.createDiet(
                  time: _time,
                  description: _descriptionController.text,
                  calorie: parseOnlyNumber(_calorieController.text),
                  carbohydrate: parseOnlyNumber(_carboController.text),
                  protein: parseOnlyNumber(_proteinController.text),
                  fat: parseOnlyNumber(_fatController.text),
                  images: _images,
                );
                if (success) Navigator.pop(context);
              },
              child: const Text('저장')),
        ),
        body: ListView(
          children: [
            PhotoCards(
              isViewMode: false,
              images: _images,
              onActions: () => setState(() {}),
            ),
            timeWidget(),
            descriptionWidget(),
            calorieWidget(),
            const SizedBox(height: 100),
          ],
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
        Row(
          children: [
            Text('칼로리'),
            Expanded(
                child:
                    calorieTextField(_calorieController, suffixText: 'kcal')),
          ],
        ),
        Row(
          children: [
            Text('탄수화물'),
            Expanded(child: calorieTextField(_carboController)),
          ],
        ),
        Row(
          children: [
            Text('단백질'),
            Expanded(child: calorieTextField(_proteinController)),
          ],
        ),
        Row(
          children: [
            Text('지방'),
            Expanded(child: calorieTextField(_fatController)),
          ],
        ),
      ],
    );
  }

  Widget calorieTextField(
    TextEditingController controller, {
    String suffixText = 'g',
  }) {
    return TextField(
      controller: controller,
      maxLength: 8,
      maxLines: 1,
      decoration: InputDecoration(
        counterText: "",
        suffixText: suffixText,
      ),
      keyboardType: TextInputType.number,
      textAlign: TextAlign.right,
    );
  }
}
