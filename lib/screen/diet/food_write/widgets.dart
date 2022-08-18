import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class DietFoodWriteFloatingButton extends StatelessWidget {
  const DietFoodWriteFloatingButton({
    Key? key,
    required this.title,
    required this.enable,
    required this.onTap,
  }) : super(key: key);
  final String title;
  final bool enable;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enable ? 1 : 0.2,
      child: InkWell(
        onTap: enable ? onTap : null,
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width - 100,
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(title),
          ),
        ),
      ),
    );
  }
}

showDietFoodServingPicker({
  required BuildContext context,
  required List<String> servingNames,
  required String selectedUnit,
}) async {
  return await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DietFoodServingPicker(
          names: servingNames,
          selectedUnit: selectedUnit,
        );
      });
}

class DietFoodServingPicker extends StatefulWidget {
  const DietFoodServingPicker({
    Key? key,
    required this.names,
    required this.selectedUnit,
  }) : super(key: key);

  final List<String> names;
  final String selectedUnit;

  @override
  State<DietFoodServingPicker> createState() => _DietFoodServingPickerState();
}

class _DietFoodServingPickerState extends State<DietFoodServingPicker> {
  String _servingDisplay = "";
  bool _sizeControllerEnabled = true;
  String _selectedServingName = "";
  bool _validation = false;
  final _sizeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectServingName(widget.names[0]);
  }

  _validate() {
    setState(() {
      _validation = _sizeController.text.isNotEmpty;
    });
  }

  void _selectServingName(String servingName) {
    _selectedServingName = servingName;
    if (["1인분", "1회제공량"].contains(_selectedServingName)) {
      _servingDisplay = "${widget.selectedUnit} $_selectedServingName".trim();
      _sizeControllerEnabled = true;
    } else if (["100g", "100ml"].contains(_selectedServingName)) {
      _servingDisplay = widget.selectedUnit;
      _sizeController.text = "100";
      _sizeControllerEnabled = false;
    } else {
      _servingDisplay = "${widget.selectedUnit} 1$_selectedServingName".trim();
      _sizeControllerEnabled = true;
    }
    _validate();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SizedBox(
        height: 400,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Text('취소'),
                ),
                Opacity(
                  opacity: _validation ? 1 : 0.2,
                  child: InkWell(
                    onTap: _validation
                        ? () => Navigator.pop(context, {
                              'size': _sizeController.text,
                              'servingName': _selectedServingName,
                              'display': _servingDisplay,
                            })
                        : null,
                    child: Text('선택'),
                  ),
                ),
              ],
            ),
            Text('1회 제공량 단위 선택'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: TextField(
                        onChanged: (t) =>
                            _selectServingName(_selectedServingName),
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
                  height: 300,
                  width: 200,
                  child: CupertinoPicker(
                    itemExtent: 30,
                    squeeze: 1,
                    selectionOverlay: ColoredBox(
                      color: Colors.blueAccent.withOpacity(0.2),
                    ),
                    onSelectedItemChanged: (index) {
                      _selectServingName(widget.names[index]);
                    },
                    children: widget.names.map((unit) => Text(unit)).toList(),
                  ),
                )
              ],
            ),
            newServingSizeName(context),
          ],
        ),
      ),
    );
  }

  Widget newServingSizeName(BuildContext context) {
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
}
