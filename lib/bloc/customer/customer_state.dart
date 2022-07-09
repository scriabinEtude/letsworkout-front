import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/customer_question.dart';

class CustomerState {
  final LoadingState loading;
  final List<CustomerQuestion> questions;

  CustomerState({
    this.loading = LoadingState.init,
    required this.questions,
  });

  CustomerState copyWith(
          {LoadingState? loading, List<CustomerQuestion>? questions}) =>
      CustomerState(
        loading: loading ?? this.loading,
        questions: questions ?? this.questions,
      );
}
