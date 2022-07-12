import 'package:bloc/bloc.dart';
import 'package:letsworkout/bloc/feed/feed_state.dart';
import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/repository/feed_repository.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit({required this.user})
      : super(
          FeedState(
            user: user,
            feedActives: [],
          ),
        );
  final User user;

  final FeedRepository _feedRepository = FeedRepository();

  void setLoading(LoadingState loading) {
    emit(state.copyWith(loading: loading));
  }

  Future getFeedActives() async {
    try {
      setLoading(LoadingState.loading);
      emit(state.copyWith(
        feedActives:
            await _feedRepository.getFeedActives(userId: state.user.id!),
      ));
    } catch (e) {
      print(e);
    } finally {
      setLoading(LoadingState.done);
    }
  }
}
