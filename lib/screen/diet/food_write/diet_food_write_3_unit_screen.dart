import 'package:flutter/material.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/config/route.dart';
import 'package:letsworkout/model/serving_size.dart';
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
  String _selectedUnit = "";
  String _selectedServingName = "";
  int _selectedSize = 0;
  String _display = "";
  late List<String> _servingNames;

  @override
  void initState() {
    super.initState();
  }

  void _validate() {
    _validation = _selectedUnit.isNotEmpty &&
        _selectedServingName.isNotEmpty &&
        _selectedSize > 0;
    setState(() {});
  }

  _selectUnit(String unit) {
    _selectedUnit = unit;

    String opposition = _selectedUnit == "g" ? "ml" : "g";
    _selectedServingName =
        _selectedServingName.replaceAll(opposition, _selectedUnit);

    _servingNames = [
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
    _callServingPicker();
  }

  _save() {
    unFocus();

    AppBloc.foodWriteCubit.setFirstServing(
      unit: _selectedUnit,
      firstServingName: _selectedServingName,
      firstServingSize: _selectedSize,
    );

    Navigator.pushNamed(context, Routes.dietFoodWirte4NutiritionScreen);
  }

  _callServingPicker() async {
    ServingSize? result = await showDietFoodServingPicker(
        context: context,
        servingNames: _servingNames,
        selectedUnit: _selectedUnit);

    if (result != null) {
      _selectedServingName = result.servingName;
      _selectedSize = result.servingSize;
      _display = result.display ?? "";
      _validate();
    }
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
            Builder(builder: (context) {
              if (_selectedUnit.isEmpty) {
                return const SizedBox.shrink();
              } else if (_selectedUnit.isNotEmpty &&
                  _selectedServingName.isEmpty) {
                return InkWell(
                  onTap: _callServingPicker,
                  child: Text(' + 제공량 선택'),
                );
              } else {
                return Column(
                  children: [
                    Text('$_selectedSize$_selectedUnit$_selectedServingName'),
                    InkWell(
                      child: Text('재작성'),
                      onTap: _callServingPicker,
                    )
                  ],
                );
              }
            }),
            const SizedBox(height: 200)
          ],
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
