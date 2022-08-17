import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class DietFoodWrite5Servings extends StatefulWidget {
  const DietFoodWrite5Servings({Key? key}) : super(key: key);

  @override
  State<DietFoodWrite5Servings> createState() => _DietFoodWrite5ServingsState();
}

class _DietFoodWrite5ServingsState extends State<DietFoodWrite5Servings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('제공량 추가하기'),
      ),
      body: Column(
        children: [Text('칼로리는 최초등록한 제공량 기준으로 자동 계산됩니다.')],
      ),
    );
  }
}
