import 'package:bloc/bloc.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/bloc/customer/customer_state.dart';
import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/customer_question.dart';
import 'package:letsworkout/model/platform_state.dart';
import 'package:letsworkout/repository/customer_repository.dart';
import 'package:letsworkout/util/app_util.dart';

class CustomerCubit extends Cubit<CustomerState> {
  CustomerCubit()
      : super(CustomerState(
          questions: [],
        ));

  final CustomerRepository _customerRepository = CustomerRepository();

  void setLoading(LoadingState loading) {
    emit(state.copyWith(loading: loading));
  }

  Future<bool> insertCustomerQuestion({
    required String title,
    required String body,
  }) async {
    try {
      PlatformState platformState = await getPlatformState();

      bool success = await _customerRepository.insertCustomerQuestion(
          customerQuestion: CustomerQuestion(
        userId: AppBloc.userCubit.user!.userId,
        title: title,
        body: body,
        device: platformState.device,
        os: platformState.os,
        appVersion: platformState.appVersion,
      ));
      return success;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future getCustomerQuestions() async {
    try {
      setLoading(LoadingState.loading);

      emit(state.copyWith(
        questions: await _customerRepository.getCustomerQuestions(),
      ));
    } catch (e) {
      print(e);
    } finally {
      setLoading(LoadingState.done);
    }
  }
}
