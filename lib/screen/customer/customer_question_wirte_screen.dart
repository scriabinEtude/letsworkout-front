import 'package:flutter/material.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/bloc/customer/customer_cubit.dart';
import 'package:letsworkout/util/cubit_util.dart';
import 'package:letsworkout/widget/scaffold.dart';

class CustomerQuestionWirteScreen extends StatefulWidget {
  const CustomerQuestionWirteScreen({Key? key}) : super(key: key);

  @override
  State<CustomerQuestionWirteScreen> createState() =>
      _CustomerQuestionWirteScreenState();
}

class _CustomerQuestionWirteScreenState
    extends State<CustomerQuestionWirteScreen> {
  final CustomerCubit _cubit = CustomerCubit();
  final TextEditingController _titleContoller = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('고객문의 & 기능건의'),
          centerTitle: true,
          actions: scaffoldSingleAction(
            onTap: () async {
              if (_titleContoller.text.isEmpty) {
                snack("제목은 필수입니다.");
              } else if (_textController.text.length < 10) {
                snack("10자 이상으로 작성해주세요 \n자세하게 말씀해주시면 더욱 좋습니다!");
              } else {
                bool success = await _cubit.sendCustomerReportToEmail(
                  title: _titleContoller.text,
                  body: _textController.text,
                );
                if (success) {
                  snack("소중한 의견 감사드립니다!");
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('저장'),
          ),
        ),
        body: Column(
          children: [
            const Text('소중한 의견 감사합니다.\n저희에게 아주 큰 힘이 됩니다'),
            TextField(
              controller: _titleContoller,
              maxLength: 50,
              decoration: const InputDecoration(counterText: ""),
            ),
            TextField(
              controller: _textController,
              maxLength: 2000,
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}
