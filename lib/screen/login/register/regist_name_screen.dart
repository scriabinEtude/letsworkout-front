import 'package:flutter/material.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/config/route.dart';

class RegistNameScreen extends StatefulWidget {
  const RegistNameScreen({Key? key}) : super(key: key);

  @override
  State<RegistNameScreen> createState() => _RegistNameScreenState();
}

class _RegistNameScreenState extends State<RegistNameScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _validation = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('이름 입력'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          const Text('성을 떼고 이름만 입력해주세요'),
          TextField(
            controller: _nameController,
            maxLength: 20,
            onChanged: (text) {
              setState(() {
                _validation = text.isNotEmpty;
              });
            },
          ),
          Opacity(
            opacity: _validation ? 1 : 0.2,
            child: OutlinedButton(
              onPressed: () async {
                if (!_validation) return;
                _validation = false;
                setState(() {});

                // 이름 세팅
                AppBloc.loginCubit.setUser(AppBloc.loginCubit.state
                    .copyWith(name: _nameController.text));
                Navigator.pushNamed(context, Routes.registTagScreen);
              },
              child: const Text('다음', style: TextStyle(color: Colors.black)),
            ),
          )
        ],
      )),
    );
  }
}
