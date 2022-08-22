import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:letsworkout/model/food.dart';
import 'package:letsworkout/model/serving_size.dart';
import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/repository/user_repository.dart';
import 'package:letsworkout/screen/diet/diet_food_search_screen.dart';
import 'package:letsworkout/widget/avatar.dart';
import 'package:collection/collection.dart';
import 'package:letsworkout/widget/test_widget.dart';
import 'package:uuid/uuid.dart';

class DietFoodDetailScreen extends StatefulWidget {
  const DietFoodDetailScreen({
    Key? key,
    required this.food,
  }) : super(key: key);
  final Food food;

  @override
  State<DietFoodDetailScreen> createState() => _DietFoodDetailScreenState();
}

class _DietFoodDetailScreenState extends State<DietFoodDetailScreen> {
  final _userRepository = UserRepository();
  late final Food food;
  late ServingSize _servingSize;
  late Future<List<User>> _thankstoUserList;
  String? _selectedDetail;
  late final TextEditingController _unitController;
  final List<Widget> _units = List<Widget>.generate(
      2001, (index) => Text(index.toString()),
      growable: true);
  final Uuid uuid = const Uuid();
  late Key _unitPickerKey;

  @override
  void initState() {
    food = widget.food;
    _servingSize = widget.food.servingSizes![0];
    _thankstoUserList = _futureThankstoUserList();
    _unitController =
        TextEditingController(text: _servingSize.servingSize.toString());
    _unitPickerKey = Key(uuid.v4());
    super.initState();
  }

  int get _size {
    if (_selectedDetail == null) {
      return _servingSize.servingSize;
    } else if (_selectedDetail == "unit") {
      return int.parse(_unitController.text);
    } else {
      return 1;
    }
  }

  Future<List<User>> _futureThankstoUserList() async {
    return await _userRepository.getUsersById(
      food.thanksto?.map((e) => e.userId).toList() ?? [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('음식 정보')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('${food.foodName}'),
            Text('${food.company.name}'),

            // if (user != null) Text('등록한 사람 ${user!.name ?? ""}'),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NutiritionContainer(
                    title: '탄수화물',
                    unit: 'g',
                    nutrition: Food.sizeFrom100g(food.carbohydrate, _size)),
                NutiritionContainer(
                    title: '단백질',
                    unit: 'g',
                    nutrition: Food.sizeFrom100g(food.protein, _size)),
                NutiritionContainer(
                    title: '지방',
                    unit: 'g',
                    nutrition: Food.sizeFrom100g(food.fat, _size)),
                NutiritionContainer(
                    title: '당',
                    unit: 'g',
                    nutrition: Food.sizeFrom100g(food.sugar, _size)),
                NutiritionContainer(
                    title: '나트륨',
                    unit: 'mg',
                    nutrition: Food.sizeFrom100g(food.sodium, _size)),
              ],
            ),
            Text('인용횟수 ${food.refCount}'),

            Text('1. 등록된 제공량을 선택해 주세요.'),
            Wrap(
              children: food.servingSizes!
                  .map((serving) => InkWell(
                        onTap: () {
                          _servingSize = serving;
                          setState(() {});
                        },
                        child: Container(
                          color: _servingSize == serving
                              ? Colors.blueAccent[100]
                              : null,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: Column(
                            // mainAxisSize: MainAxisSize.max,
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                height: 20,
                                child: Text(serving.servingName),
                              ),
                              Text('${serving.servingSize}${food.unit}'),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
            Text('2. 세세하게 조정하세요'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    _selectedDetail = "unit";
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'unit',
                        onChanged: (value) {
                          _selectedDetail = "unit";
                          setState(() {});
                        },
                        groupValue: _selectedDetail,
                      ),
                      Text('${food.unit}으로 조정'),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    _selectedDetail = "개";
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio<String>(
                        value: "개",
                        onChanged: (value) {
                          _selectedDetail = "개";
                          setState(() {});
                        },
                        groupValue: _selectedDetail,
                      ),
                      const Text('갯수로 조정'),
                    ],
                  ),
                ),
              ],
            ),
            if (_selectedDetail == "unit")
              Row(
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: CupertinoPicker(
                      key: _unitPickerKey,
                      itemExtent: 30,
                      squeeze: 1.2,
                      onSelectedItemChanged: (index) {
                        _unitController.text = index.toString();
                        setState(() {});
                      },
                      scrollController:
                          FixedExtentScrollController(initialItem: _size),
                      children: _units,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _unitController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        // 공백이 될 수 없음
                        int number = 0;
                        if (value.isEmpty) {
                          number = 0;
                        }
                        // 2000을 넘을 수 없음
                        else if (int.parse(value) > 2000) {
                          number = 2000;
                        } else {
                          number = int.parse(value);
                        }
                        _unitController.text = number.toString();
                        _unitController.selection = TextSelection.fromPosition(
                            TextPosition(offset: _unitController.text.length));
                        _unitPickerKey = Key(uuid.v4());
                        setState(() {});
                      },
                    ),
                  ),
                  Text(food.unit),
                ],
              ),

            if (food.description != null) Text('설명 ${food.description}'),

            FutureBuilder<List<User>?>(
              future: _thankstoUserList,
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (!snapshot.hasData) return const SizedBox.shrink();

                  return Column(
                      children: snapshot.data!
                          .mapIndexed((index, user) => Row(
                                children: [
                                  Avatar(
                                    size: 20,
                                    image: user.profileImage,
                                  ),
                                  Column(
                                    children: [
                                      Text(user.tag!),
                                      Text(user.name!),
                                    ],
                                  ),
                                  Text(food.thanksto![index].description),
                                ],
                              ))
                          .toList());
                } else {
                  return SizedBox.shrink();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
