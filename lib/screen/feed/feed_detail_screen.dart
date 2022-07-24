import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/bloc/feed/feed_cubit.dart';
import 'package:letsworkout/bloc/feed/feed_state.dart';
import 'package:letsworkout/enum/comment_state.dart';
import 'package:letsworkout/model/comment.dart';
import 'package:letsworkout/model/diet.dart';
import 'package:letsworkout/model/feed.dart';
import 'package:letsworkout/model/workout.dart';
import 'package:letsworkout/widget/avatar.dart';
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
  final _commentController = TextEditingController();
  int? meId = AppBloc.userCubit.user?.userId;
  final _pageController = PageController();

  @override
  void initState() {
    _feedCubit = FeedCubit(feed: widget.feed);
    _feedCubit.commentGet(feedId: widget.feed.feedId);
    super.initState();
  }

  @override
  void dispose() {
    _feedCubit.close();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: TextField(
            controller: _commentController,
            maxLines: null,
            onChanged: (text) => setState(() {}),
            decoration: InputDecoration(
              hintText: "댓글 달기",
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                color: _commentController.text.isEmpty
                    ? Colors.black
                    : Colors.blue,
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
            ),
          ),
        ),
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
                    height: 400,
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
                Text('댓긇 ${state.comments.length}개'),
                ...state.comments.map((c) => commentWidget(c))
              ],
            ),
          );
        },
      ),
    );
  }

  Widget commentWidget(Comment c) {
    CommentState state = CommentState.values[c.state!];

    return Container(
      child: Row(
        children: [
          Avatar(image: c.user!.profileImage, size: 30),
          Column(
            children: [
              Row(
                children: [
                  Text(c.user!.name ?? ""),
                  if (state == CommentState.deleted)
                    const Text('삭제된 댓글입니다.')
                  else
                    Text(c.comment ?? ""),
                ],
              ),
              if (state != CommentState.deleted)
                Row(
                  children: [
                    Text("좋아요${c.likes}개   "),
                    Text('신고'),
                    Text('수정'),
                    if (c.user!.userId == meId)
                      InkWell(
                          onTap: () async {
                            if (await showOkCancelAlertDialog(
                                    context: context,
                                    title: '정말로 삭제하시겠습니까?',
                                    okLabel: '확인',
                                    cancelLabel: "취소") ==
                                OkCancelResult.ok) {
                              _feedCubit.commentDelete(
                                comment: c,
                              );
                            }
                          },
                          child: Text('   삭제')),
                  ],
                )
            ],
          ),
          if (state != CommentState.deleted)
            IconButton(
              icon: Icon((c.isLiked ?? false)
                  ? Icons.favorite
                  : Icons.favorite_border),
              onPressed: () => _feedCubit.toggleCommentLike(comment: c),
            ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
