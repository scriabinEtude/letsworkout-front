import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/bloc/comment/comment_cubit.dart';
import 'package:letsworkout/bloc/feed/feed_cubit.dart';
import 'package:letsworkout/bloc/feed/feed_state.dart';
import 'package:letsworkout/enum/comment_type.dart';
import 'package:letsworkout/model/comment.dart';
import 'package:letsworkout/model/diet.dart';
import 'package:letsworkout/model/feed.dart';
import 'package:letsworkout/model/workout.dart';
import 'package:letsworkout/widget/avatar.dart';
import 'package:letsworkout/widget/comment_input_field.dart';
import 'package:letsworkout/widget/comment_list.dart';
import 'package:letsworkout/widget/photo_cards.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class FeedDetailScreen extends StatefulWidget {
  const FeedDetailScreen({
    Key? key,
    required this.feed,
  }) : super(key: key);
  final Feed feed;

  @override
  State<FeedDetailScreen> createState() => _FeedDetailScreenState();
}

class _FeedDetailScreenState extends State<FeedDetailScreen>
    with AutomaticKeepAliveClientMixin {
  late final FeedCubit _feedCubit;
  late final CommentCubit _commentCubit;
  final _commentController = TextEditingController();
  int? myId = AppBloc.userCubit.user?.userId;
  final _pageController = PageController();

  @override
  void initState() {
    _feedCubit = FeedCubit(feed: widget.feed);
    _feedCubit.commentGet(feedId: widget.feed.feedId);
    _commentCubit = CommentCubit(feed: widget.feed);
    super.initState();
  }

  @override
  void dispose() {
    _feedCubit.close();
    _commentCubit.close();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: CommentInputField(
        controller: _commentController,
        onChanged: (text) => setState(() {}),
        onPressed: () async {
          await _feedCubit.commentInsert(
            depth: 0,
            parentId: null,
            comment: _commentController.text,
          );
          _commentController.text = "";
          setState(() {});
        },
      ),
      body: BlocBuilder<FeedCubit, FeedState>(
        bloc: _feedCubit,
        builder: (context, state) {
          String description;
          Feed feed = state.feed!;
          if (feed is Workout) {
            description = feed.description ?? "";
          } else {
            description = (feed as Diet).description ?? "";
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Avatar(
                  size: 40,
                  image: state.feed!.user!.profileImage,
                ),
                Text(state.feed!.user!.name!),
                // if (state.feedActive?.images?.isNotEmpty  == true)
                GestureDetector(
                  onDoubleTap: _feedCubit.toggleLike,
                  child: PhotoCards(
                    pageController: _pageController,
                    images: state.feed!.images!,
                    isViewMode: true,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                const SizedBox(height: 8),
                if (state.feed!.images!.listShowable.isNotEmpty)
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: state.feed!.images!.listShowable.length,
                    effect: const SlideEffect(
                      dotHeight: 5,
                      dotWidth: 5,
                      spacing: 5,
                    ),
                  ),
                Text(description),
                IconButton(
                  icon: Icon(state.feed!.isLiked!
                      ? Icons.favorite
                      : Icons.favorite_border),
                  onPressed: _feedCubit.toggleLike,
                ),
                CommentColumn(
                  feedCubit: _feedCubit,
                  myId: myId,
                )
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
