import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/bloc/food_write/food_write_state.dart';
import 'package:letsworkout/config/route.dart';
import 'package:letsworkout/screen/diet/food_write/widgets.dart';
import 'package:letsworkout/util/string_util.dart';
import 'package:letsworkout/util/widget_util.dart';

class DietFoodWrite4NutiritionScreen extends StatefulWidget {
  const DietFoodWrite4NutiritionScreen({Key? key}) : super(key: key);

  @override
  State<DietFoodWrite4NutiritionScreen> createState() =>
      _DietFoodWrite4NutiritionScreenState();
}

class _DietFoodWrite4NutiritionScreenState
    extends State<DietFoodWrite4NutiritionScreen> {
  final TextEditingController _calorieController = TextEditingController();
  final TextEditingController _carboController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _sugarController = TextEditingController();
  final TextEditingController _sodiumController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _validation = false;

  @override
  void dispose() {
    _calorieController.dispose();
    _carboController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    _sugarController.dispose();
    _sodiumController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  void _saveValidate() {
    setState(() {
      _validation = _calorieController.text.isNotEmpty &&
          _carboController.text.isNotEmpty &&
          _proteinController.text.isNotEmpty &&
          _fatController.text.isNotEmpty &&
          _sugarController.text.isNotEmpty &&
          _sodiumController.text.isNotEmpty;
    });
  }

  Future _save() async {
    unFocus();
    AppBloc.foodWriteCubit.setNutirition(
      calorie: parseStringNumber(_calorieController.text),
      carbohydrate: parseStringNumber(_carboController.text),
      protein: parseStringNumber(_proteinController.text),
      fat: parseStringNumber(_fatController.text),
      sugar: parseStringNumber(_sugarController.text),
      sodium: parseStringNumber(_sodiumController.text),
      description: _descriptionController.text,
    );

    Navigator.pushNamed(context, Routes.dietFoodWrite5ServingsScreen);
  }

  @override
  Widget build(BuildContext context) {
    FoodWriteState state = AppBloc.foodWriteCubit.state;
    String foodNameText = state.companyName! + state.foodName!;
    String prevText =
        state.firstServingSize! + state.unit! + state.firstServingName!;

    return GestureDetector(
      onTap: unFocus,
      child: Scaffold(
        appBar: AppBar(title: const Text('음식 등록')),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: DietFoodWriteFloatingButton(
          title: '다음',
          enable: _validation,
          onTap: _save,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text(foodNameText),
              Text(prevText),
              TextField(
                controller: _calorieController,
                keyboardType: TextInputType.number,
                onChanged: (text) => _saveValidate(),
                decoration: const InputDecoration(
                  label: Text('칼로리'),
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              TextField(
                controller: _carboController,
                keyboardType: TextInputType.number,
                onChanged: (text) => _saveValidate(),
                decoration: const InputDecoration(
                  label: Text('탄수화물'),
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              TextField(
                controller: _proteinController,
                keyboardType: TextInputType.number,
                onChanged: (text) => _saveValidate(),
                decoration: const InputDecoration(
                  label: Text('단백질'),
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              TextField(
                controller: _fatController,
                keyboardType: TextInputType.number,
                onChanged: (text) => _saveValidate(),
                decoration: const InputDecoration(
                  label: Text('지방'),
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              TextField(
                controller: _sugarController,
                keyboardType: TextInputType.number,
                onChanged: (text) => _saveValidate(),
                decoration: const InputDecoration(
                  label: Text('당'),
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              TextField(
                controller: _sodiumController,
                keyboardType: TextInputType.number,
                onChanged: (text) => _saveValidate(),
                decoration: const InputDecoration(
                  label: Text('나트륨'),
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              TextField(
                controller: _descriptionController,
                maxLength: 400,
                maxLines: null,
                decoration: const InputDecoration(
                  label: Text('설명'),
                ),
              ),
              SizedBox(height: 300),
            ],
          ),
        ),
      ),
    );
  }
}
