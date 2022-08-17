import 'dart:developer';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/config/route.dart';
import 'package:letsworkout/screen/diet/food_write/widgets.dart';
import 'package:letsworkout/util/widget_util.dart';
import 'package:uuid/uuid.dart';

class DietFoodWrite3UnitScreen extends StatefulWidget {
  const DietFoodWrite3UnitScreen({Key? key}) : super(key: key);

  @override
  State<DietFoodWrite3UnitScreen> createState() =>
      _DietFoodWrite3UnitScreenState();
}

class _DietFoodWrite3UnitScreenState extends State<DietFoodWrite3UnitScreen> {
  Uuid uuid = const Uuid();
  bool _validation = false;
  bool _firstSelectUnit = false;
  String _selectedUnit = "";
  String _selectedServingName = "";
  String _servingDisplay = "";
  bool _sizeControllerEnabled = true;
  Key _servingNamePickerKey = const Key('servingNamePicker');
  final _sizeController = TextEditingController();
  late List<String> _units;

  @override
  void initState() {
    super.initState();
  }

  void _validate() {
    _firstSelectUnit = _selectedUnit.isNotEmpty;
    _validation = _selectedUnit.isNotEmpty &&
        _selectedServingName.isNotEmpty &&
        _sizeController.text.isNotEmpty;
    setState(() {});
  }

  _selectUnit(String unit) {
    _selectedUnit = unit;
    _refreshServingNamePicker();
    _selectServingName(_selectedServingName);

    _units = [
      '100$_selectedUnit',
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
    ];
    _validate();
  }

  void _selectServingName(String servingName) {
    _selectedServingName = servingName;
    if (["1인분", "1회제공량"].contains(_selectedServingName)) {
      _servingDisplay = "$_selectedUnit $_selectedServingName".trim();
      _sizeControllerEnabled = true;
    } else if (["100g", "100ml"].contains(_selectedServingName)) {
      _servingDisplay = _selectedUnit;
      _sizeController.text = "100";
      _sizeControllerEnabled = false;
      unFocus();
    } else {
      _servingDisplay = "$_selectedUnit 1$_selectedServingName".trim();
      _sizeControllerEnabled = true;
    }
    _validate();
  }

  _refreshServingNamePicker() {
    _servingNamePickerKey = Key(uuid.v4());
  }

  _save() {
    unFocus();

    AppBloc.foodWriteCubit.setFirstServing(
      unit: _selectedUnit,
      firstServingName: _selectedServingName,
      firstServingSize: _sizeController.text,
    );

    Navigator.pushNamed(context, Routes.dietFoodWirte4NutiritionScreen);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: unFocus,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("단위 등록"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: DietFoodWriteFloatingButton(
          title: '다음',
          enable: _validation,
          onTap: _save,
        ),
        body: ListView(
          children: [
            Text('단위 선택'),
            Row(
              children: [
                unitSelectBox('g'),
                unitSelectBox('ml'),
              ],
            ),
            // showMaterialScrollPicker(context: context, items: [1,2,3,4,5,6,7,8,], selectedItem: selectedItem),
            // ScrollPickerDialog(items: [1, 2, 3, 4, 5, 6, 7], selectedItem: 2),
            if (_selectedUnit.isNotEmpty)
              Column(
                children: [
                  Text('1회 제공량 단위 선택'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: TextField(
                              onChanged: (text) => _validate(),
                              controller: _sizeController,
                              enabled: _sizeControllerEnabled,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                          Text(_servingDisplay),
                        ],
                      ),
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: CupertinoPicker(
                          key: _servingNamePickerKey,
                          itemExtent: 30,
                          squeeze: 1,
                          selectionOverlay: ColoredBox(
                            color: Colors.blueAccent.withOpacity(0.2),
                          ),
                          onSelectedItemChanged: (index) {
                            _selectServingName(_units[index]);
                          },
                          children: _units.map((unit) => Text(unit)).toList(),
                        ),
                      )
                    ],
                  ),
                  newServingSizeName(),
                ],
              ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     servingNameBox('100$_selectedUnit'),
            //     servingNameBox('1인분'),
            //     servingNameBox('1회제공량'),
            //     servingNameBox('개'),
            //   ],
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     servingNameBox('조각'),
            //     servingNameBox('팩'),
            //     servingNameBox('패키지'),
            //     servingNameBox('봉지'),
            //   ],
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     servingNameBox('병'),
            //     servingNameBox('캔'),
            //     servingNameBox('잔'),
            //     servingNameBox('포'),
            //   ],
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     servingNameBox('바'),
            //     servingNameBox('모'),
            //     servingNameBox('포기'),
            //     servingNameBox('공기'),
            //   ],
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     servingNameBox('접시'),
            //     servingNameBox('뚝배기'),
            //     servingNameBox('움큼'),
            //     servingNameBox('숟갈'),
            //   ],
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     servingNameBox('큰술'),
            //     servingNameBox('작은술'),
            //   ],
            // ),
            const SizedBox(height: 200)
          ],
        ),
      ),
    );
  }

  Widget newServingSizeName() {
    return InkWell(
      onTap: () async {
        List<String>? userInput = await showTextInputDialog(
          context: context,
          title: "새로운 입력",
          textFields: [
            DialogTextField(),
          ],
        );

        if (userInput != null && userInput[0].isNotEmpty) {
          _selectServingName(userInput[0]);
        }
      },
      child: Text('+ 새로운 입력'),
    );
  }

  Widget servingNameBox(String value) {
    bool enable = value == _selectedServingName;
    return InkWell(
      onTap: _firstSelectUnit ? () => _selectServingName(value) : null,
      child: Opacity(
        opacity: _firstSelectUnit ? 1 : 0.2,
        child: Container(
          width: MediaQuery.of(context).size.width / 4 - 10,
          margin: const EdgeInsets.symmetric(vertical: 5),
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(
              color: enable ? Colors.black : Colors.grey,
            ),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: enable ? FontWeight.bold : null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget unitSelectBox(String unit) {
    bool enable = unit == _selectedUnit;
    return InkWell(
      onTap: () => _selectUnit(unit),
      child: Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
            color: enable ? Colors.black : Colors.grey,
          ),
        ),
        child: Center(
          child: Text(
            unit,
            style: TextStyle(
              fontWeight: enable ? FontWeight.bold : null,
            ),
          ),
        ),
      ),
    );
  }
}
