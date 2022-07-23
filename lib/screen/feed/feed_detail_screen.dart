import 'dart:developer';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/bloc/feed/feed_cubit.dart';
import 'package:letsworkout/bloc/feed/feed_state.dart';
import 'package:letsworkout/enum/comment_state.dart';
import 'package:letsworkout/model/comment.dart';
import 'package:letsworkout/model/feed_active.dart';
import 'package:letsworkout/widget/avatar.dart';
import 'package:letsworkout/widget/photo_cards.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class FeedDetailScreen extends StatefulWidget {
  const FeedDetailScreen({Key? key, required this.feedActive})
      : super(key: key);
  final FeedActive feedActive;

  @override
  State<FeedDetailScreen> createState() => _FeedDetailScreenState();
}

class _FeedDetailScreenState extends State<FeedDetailScreen>
    with AutomaticKeepAliveClientMixin {
  late final FeedCubit _feedCubit;
  final _commentController = TextEditingController();
  int? meId = AppBloc.userCubit.user?.id;
  final _pageController = PageController();

  @override
  void initState() {
    _feedCubit = FeedCubit(feedActive: widget.feedActive);
    _feedCubit.commentGet(feedId: widget.feedActive.feedId);
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
                icon: Icon(Icons.send),
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
          return SingleChildScrollView(
            child: Column(
              children: [
                Avatar(
                  size: 40,
                  image: state.feedActive!.profileImage,
                ),
                Text(state.feedActive!.name!),
                // if (state.feedActive?.images?.isNotEmpty  == true)
                GestureDetector(
                  onDoubleTap: _feedCubit.toggleLike,
                  child: PhotoCards(
                    pageController: _pageController,
                    images: state.feedActive!.images!,
                    isViewMode: true,
                    width: MediaQuery.of(context).size.width,
                    height: 400,
                  ),
                ),
                const SizedBox(height: 8),
                if (state.feedActive!.images!.listShowable.isNotEmpty)
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: state.feedActive!.images!.listShowable.length,
                    effect: const SlideEffect(
                      dotHeight: 5,
                      dotWidth: 5,
                      spacing: 5,
                    ),
                  ),
                Text(state.feedActive!.description ?? ""),
                IconButton(
                  icon: Icon(state.feedActive!.isLiked!
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
          Avatar(image: c.userImage, size: 30),
          Column(
            children: [
              Row(
                children: [
                  Text(c.userName ?? ""),
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
                    Text('답글'),
                    Text('신고'),
                    Text('수정'),
                    if (c.userId == meId)
                      InkWell(
                          onTap: () async {
                            if (await showOkCancelAlertDialog(
                                    context: context,
                                    title: '정말로 삭제하시겠습니까?',
                                    okLabel: '확인',
                                    cancelLabel: "취소") ==
                                OkCancelResult.ok) {
                              _feedCubit.commentDelete(commentId: c.id!);
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
