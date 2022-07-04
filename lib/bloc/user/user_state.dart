import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/user.dart';

class UserState {
  final User? user;
  final LoadingState loading;

  UserState({
    this.user,
    this.loading = LoadingState.init,
  });

  UserState copyWith({
    User? user,
    LoadingState? loading,
  }) =>
      UserState(
        user: user ?? this.user,
        loading: loading ?? this.loading,
      );

  UserState userInit() => UserState(
        user: null,
        loading: loading,
      );
}
