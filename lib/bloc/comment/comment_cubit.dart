import 'package:bloc/bloc.dart';
import 'package:letsworkout/bloc/comment/comment_state.dart';
import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/feed.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit({required Feed feed})
      : super(CommentState(
          feed: feed,
          comments: [],
        ));

  void setLoading(LoadingState loading) {
    emit(state.copyWith(loading: loading));
  }
}
