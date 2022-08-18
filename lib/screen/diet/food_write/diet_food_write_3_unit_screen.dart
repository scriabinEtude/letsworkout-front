import 'package:flutter/material.dart';
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
  String _selectedUnit = "";
  String _selectedServingName = "";
  String _selectedSize = "";
  String _display = "";
  late List<String> _servingNames;

  @override
  void initState() {
    super.initState();
  }

  void _validate() {
    _validation = _selectedUnit.isNotEmpty &&
        _selectedServingName.isNotEmpty &&
        _selectedSize.isNotEmpty;
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
    Map<String, dynamic>? result = await showDietFoodServingPicker(
        context: context,
        servingNames: _servingNames,
        selectedUnit: _selectedUnit);

    if (result != null) {
      _selectedServingName = result['servingName'];
      _selectedSize = result['size'];
      _display = result['display'];
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
                  child: Text('제공량 선택'),
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

            // DietFoodServingPicker(
            //   key: _servingNamePickerKey,
            //   onChanged: (text) => _validate(),
            //   sizeController: _sizeController,
            //   textFieldEnabled: _sizeControllerEnabled,
            //   servingDisplay: _servingDisplay,
            //   onSelecteServingName: _selectServingName,
            //   units: _units,
            // ),
            // if (_selectedUnit.isNotEmpty)
            //   Column(
            //     children: [
            //       Text('1회 제공량 단위 선택'),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Row(
            //             children: [
            //               SizedBox(
            //                 width: 100,
            //                 child: TextField(
            //                   onChanged: (text) => _validate(),
            //                   controller: _sizeController,
            //                   enabled: _sizeControllerEnabled,
            //                   keyboardType: TextInputType.number,
            //                   inputFormatters: <TextInputFormatter>[
            //                     FilteringTextInputFormatter.digitsOnly,
            //                   ],
            //                 ),
            //               ),
            //               Text(_servingDisplay),
            //             ],
            //           ),
            //           SizedBox(
            //             height: 200,
            //             width: 200,
            //             child: CupertinoPicker(
            //               key: _servingNamePickerKey,
            //               itemExtent: 30,
            //               squeeze: 1,
            //               selectionOverlay: ColoredBox(
            //                 color: Colors.blueAccent.withOpacity(0.2),
            //               ),
            //               onSelectedItemChanged: (index) {
            //                 _selectServingName(_units[index]);
            //               },
            //               children: _units.map((unit) => Text(unit)).toList(),
            //             ),
            //           )
            //         ],
            //       ),
            //       newServingSizeName(),
            //     ],
            //   ),

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

  // Widget servingNameBox(String value) {
  //   bool enable = value == _selectedServingName;
  //   return InkWell(
  //     onTap: _firstSelectUnit ? () => _selectServingName(value) : null,
  //     child: Opacity(
  //       opacity: _firstSelectUnit ? 1 : 0.2,
  //       child: Container(
  //         width: MediaQuery.of(context).size.width / 4 - 10,
  //         margin: const EdgeInsets.symmetric(vertical: 5),
  //         height: 50,
  //         decoration: BoxDecoration(
  //           border: Border.all(
  //             color: enable ? Colors.black : Colors.grey,
  //           ),
  //         ),
  //         child: Center(
  //           child: Text(
  //             value,
  //             style: TextStyle(
  //               fontWeight: enable ? FontWeight.bold : null,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
