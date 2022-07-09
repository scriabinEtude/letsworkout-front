import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letsworkout/bloc/customer/customer_cubit.dart';
import 'package:letsworkout/bloc/customer/customer_state.dart';
import 'package:letsworkout/model/customer_question.dart';

class CustomerQuestionViewScreen extends StatefulWidget {
  const CustomerQuestionViewScreen({Key? key}) : super(key: key);

  @override
  State<CustomerQuestionViewScreen> createState() =>
      _CustomerQuestionViewScreenState();
}

class _CustomerQuestionViewScreenState
    extends State<CustomerQuestionViewScreen> {
  final CustomerCubit _customerCubit = CustomerCubit();

  @override
  void initState() {
    super.initState();
    _customerCubit.getCustomerQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('건의함'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: BlocBuilder<CustomerCubit, CustomerState>(
          bloc: _customerCubit,
          builder: (context, state) {
            return ListView(
              children: state.questions.map((q) => questionWidget(q)).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget questionWidget(CustomerQuestion question) {
    return Column(
      children: [
        Text('${question.userId}'),
        Text('${question.title}'),
        Text('${question.body}'),
        Text('${question.device}'),
        Text('${question.os}'),
        Text('${question.appVersion}'),
      ],
    );
  }
}
