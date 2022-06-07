import 'package:flutter/material.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/config/route.dart';

class RegistTagScreen extends StatefulWidget {
  const RegistTagScreen({Key? key}) : super(key: key);

  @override
  State<RegistTagScreen> createState() => _RegistTagScreenState();
}

class _RegistTagScreenState extends State<RegistTagScreen> {
  final TextEditingController _tagController = TextEditingController();
  bool _validation = false;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('태그 입력'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          TextField(
            controller: _tagController,
            maxLength: 20,
            onChanged: (text) {
              setState(() {
                _validation = text.isNotEmpty;
              });
            },
          ),
          Opacity(
            opacity: _validation && !_loading ? 1 : 0.2,
            child: OutlinedButton(
              onPressed: () async {
                if (!_validation) return;
                if (_loading) return;
                _validation = false;
                _loading = true;
                setState(() {});

                bool isRegistered = await AppBloc.loginCubit
                    .registUser(tag: _tagController.text);

                if (isRegistered) {
                  Navigator.pushNamed(context, Routes.homeScreen);
                  return;
                }

                _loading = false;
                setState(() {});
              },
              child: Text(_loading ? "등록중" : '확인',
                  style: const TextStyle(color: Colors.black)),
            ),
          )
        ],
      )),
    );
  }
}
