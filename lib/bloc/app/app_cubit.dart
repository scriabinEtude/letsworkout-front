import 'package:bloc/bloc.dart';
import 'package:letsworkout/bloc/app/app_state.dart';
import 'package:letsworkout/enum/app_state_type.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit()
      : super(AppState(
          type: AppStateType.init,
        ));

  void appSnackBar(String message) {
    emit(state.copyWith(
      type: AppStateType.snackBar,
      message: message,
    ));
  }

  void successUpSnacbar(String message) {
    emit(state.copyWith(
      type: AppStateType.successUpSnacbar,
      message: message,
    ));
  }
}
