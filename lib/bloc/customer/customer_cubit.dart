import 'package:bloc/bloc.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/bloc/customer/customer_state.dart';
import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/customer_question.dart';
import 'package:letsworkout/repository/customer_repository.dart';

class CustomerCubit extends Cubit<CustomerState> {
  CustomerCubit() : super(CustomerState());

  final CustomerRepository _customerRepository = CustomerRepository();

  void setLoading(LoadingState loading) {
    emit(state.copyWith(loading: loading));
  }

  Future<bool> sendCustomerReportToEmail({
    required String title,
    required String body,
  }) async {
    try {
      bool success = await _customerRepository.insertCustomerQuestion(
          customerQuestion: CustomerQuestion(
        userId: AppBloc.userCubit.user!.id,
        title: title,
        body: body,
        // device: ,
        // os: ,
        // appVersion: ,
        // buildNumber: ,
      ));
      return success;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
