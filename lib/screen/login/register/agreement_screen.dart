import 'package:flutter/material.dart';
import 'package:letsworkout/config/route.dart';

class AgreementScreen extends StatefulWidget {
  const AgreementScreen({Key? key}) : super(key: key);

  @override
  State<AgreementScreen> createState() => _AgreementScreenState();
}

class _AgreementScreenState extends State<AgreementScreen> {
  final Map<int, bool> _agreementState = {
    0: false,
    1: false,
    2: false,
  };

  bool _validation = false;

  @override
  void setState(VoidCallback fn) {
    _validation = !_agreementState.containsValue(false);
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffffffff),
        foregroundColor: const Color(0xff000000),
        centerTitle: true,
        title: const Text('회원가입'),
      ),
      body: Column(
        children: [
          Text('한결아 운동하자!\n같이 득근해보아요!'),
          agreement(index: 0),
          agreement(index: 1),
          agreement(index: 2),
          Opacity(
            opacity: _validation ? 1 : 0.2,
            child: OutlinedButton(
              onPressed: () {
                if (_validation) {
                  Navigator.pushNamed(context, Routes.registNameScreen);
                }
              },
              child: const Center(
                child: Text(
                  '약관 동의 완료',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget agreement({
    required int index,
  }) {
    return Row(
      children: [
        Checkbox(
          value: _agreementState[index],
          onChanged: (isSelected) {
            _agreementState[index] = isSelected ?? false;
            setState(() {});
          },
          activeColor: Colors.black,
        ),
      ],
    );
  }
}
