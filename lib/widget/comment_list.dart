import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:letsworkout/bloc/feed/feed_cubit.dart';
import 'package:letsworkout/model/comment.dart';
import 'package:letsworkout/widget/avatar.dart';

class CommentColumn extends StatelessWidget {
  const CommentColumn({
    Key? key,
    required this.feedCubit,
    required this.myId,
  }) : super(key: key);

  final FeedCubit feedCubit;
  final int? myId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('댓긇 ${feedCubit.state.comments.length}개'),
        ...feedCubit.state.comments.map((comment) => CommentContainer(
              comment: comment,
              onToggleLike: feedCubit.toggleCommentLike,
              canDelete: (comment) => comment.user!.userId == myId,
              onDelete: (comment) async {
                if (await showOkCancelAlertDialog(
                        context: context,
                        title: '정말로 삭제하시겠습니까?',
                        okLabel: '확인',
                        cancelLabel: "취소") ==
                    OkCancelResult.ok) {
                  feedCubit.commentDelete(
                    comment: comment,
                  );
                }
              },
            )),
      ],
    );
  }
}

class CommentContainer extends StatelessWidget {
  const CommentContainer({
    Key? key,
    required this.comment,
    required this.onToggleLike,
    required this.onDelete,
    required this.canDelete,
  }) : super(key: key);
  final Comment comment;
  final void Function(Comment) onToggleLike;
  final void Function(Comment) onDelete;
  final bool Function(Comment) canDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Avatar(image: comment.user!.profileImage, size: 30),
        Column(
          children: [
            Row(
              children: [
                Text(comment.user!.name ?? ""),
                Text(comment.comment ?? ""),
              ],
            ),
            Row(
              children: [
                Text("좋아요${comment.likes}개   "),
                Text('신고'),
                Text('수정'),
                if (canDelete(comment))
                  InkWell(
                    onTap: () => onDelete(comment),
                    child: Text('   삭제'),
                  ),
              ],
            )
          ],
        ),
        IconButton(
          icon: Icon((comment.isLiked ?? false)
              ? Icons.favorite
              : Icons.favorite_border),
          onPressed: () => onToggleLike(comment),
        ),
      ],
    );
  }
}
