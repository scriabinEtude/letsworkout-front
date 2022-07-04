import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:letsworkout/bloc/cubit/diet_cubit.dart';
import 'package:letsworkout/util/string_util.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DietWriteScreen extends StatefulWidget {
  const DietWriteScreen({Key? key}) : super(key: key);

  @override
  State<DietWriteScreen> createState() => _DietWriteScreenState();
}

class _DietWriteScreenState extends State<DietWriteScreen> {
  DietCubit _dietCubit = DietCubit();

  DateTime _time = DateTime.now();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _calorieController = TextEditingController();
  final TextEditingController _carboController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();

  final List<File> _images = [];

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
          actions: [
            InkWell(
              onTap: () async {
                bool success = await _dietCubit.createDiet(
                  time: _time,
                  description: _descriptionController.text,
                  calorie: parseOnlyNumber(_calorieController.text),
                  carbohydrate: parseOnlyNumber(_carboController.text),
                  protein: parseOnlyNumber(_proteinController.text),
                  fat: parseOnlyNumber(_fatController.text),
                  imageFiles: _images,
                );
                if (success) Navigator.pop(context);
              },
              child: const Center(child: Text('저장')),
            ),
            const SizedBox(width: 20),
          ],
        ),
        body: ListView(
          children: [
            photoCards(),
            timeWidget(),
            descriptionWidget(),
            calorieWidget(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget photoCards() {
    return SizedBox(
      height: MediaQuery.of(context).size.width,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ..._images.map(
            (image) => photoCard(image),
          ),
          addPhotoCard(),
        ],
      ),
    );
  }

  Widget photoCard(File image) {
    return Stack(
      children: [
        Image.file(
          image,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
        ),
        Positioned(
          right: 20,
          top: 20,
          child: InkWell(
            onTap: () {
              _images.remove(image);
              setState(() {});
            },
            child: const Icon(Icons.cancel),
          ),
        ),
      ],
    );
  }

  Widget addPhotoCard() {
    return InkWell(
      onTap: () async {
        ImagePicker picker = ImagePicker();
        List<XFile>? files = await picker.pickMultiImage();
        if (files == null) return;

        files.forEach((file) {
          _images.add(File(file.path));
        });
        setState(() {});
      },
      child: Container(
          color: Colors.amber,
          height: MediaQuery.of(context).size.width,
          width: MediaQuery.of(context).size.width,
          child: const Center(
            child: Icon(
              size: 60,
              Icons.camera_alt_outlined,
            ),
          )),
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
