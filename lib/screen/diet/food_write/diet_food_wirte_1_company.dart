import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/config/route.dart';
import 'package:letsworkout/model/food_company.dart';
import 'package:letsworkout/repository/food_repository.dart';
import 'package:letsworkout/widget/scaffold.dart';

class DietFoodWrite1CompanyScreen extends StatefulWidget {
  const DietFoodWrite1CompanyScreen({Key? key}) : super(key: key);

  @override
  State<DietFoodWrite1CompanyScreen> createState() =>
      _DietFoodWrite1CompanyScreenState();
}

class _DietFoodWrite1CompanyScreenState
    extends State<DietFoodWrite1CompanyScreen> {
  final _companyController = TextEditingController();
  List<FoodCompany> _companyList = [];
  final _foodRepository = FoodRepository();

  @override
  void dispose() {
    _companyController.dispose();
    super.dispose();
  }

  _onChanged(String company) async {
    if (company.isEmpty) {
      EasyDebounce.cancel('companySearch');
      _companyList = [];
      setState(() {});
    } else {
      EasyDebounce.debounce('companySearch', const Duration(milliseconds: 350),
          () async {
        _companyList = await _foodRepository.companySearch(company: company);
        setState(() {});
      });
    }
  }

  _select(String companyName) {
    AppBloc.foodWriteCubit.setCompanyName(companyName);
    Navigator.pushNamed(context, Routes.dietFoodWrite2FoodnameScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('제조사 찾기'),
      ),
      body: ListView(
        children: [
          TextField(
            controller: _companyController,
            decoration: const InputDecoration(label: Text('제조사')),
            onChanged: _onChanged,
          ),
          if (_companyController.text.isEmpty)
            Text('제조사를 입력해주세요')
          else if (_companyList.isNotEmpty &&
              _companyController.text.isNotEmpty)
            ..._companyList.map((company) => companyWidget(company))
          else if (_companyList.isEmpty && _companyController.text.isNotEmpty)
            InkWell(
              onTap: () => _select(_companyController.text),
              child: Text('${_companyController.text} 등록하기'),
            ),
        ],
      ),
    );
  }

  Widget companyWidget(FoodCompany company) {
    return InkWell(
      onTap: () => _select(company.name!),
      child: Container(
        width: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(company.name!),
            Text('${company.refCount!}'),
          ],
        ),
      ),
    );
  }
}
