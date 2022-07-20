import 'package:flutter/material.dart';
import 'package:letsworkout/bloc/feed/feed_cubit.dart';
import 'package:letsworkout/model/feed_active.dart';
import 'package:letsworkout/model/file_actions.dart';
import 'package:letsworkout/widget/avatar.dart';
import 'package:letsworkout/widget/photo_cards.dart';

class FeedDetailScreen extends StatefulWidget {
  const FeedDetailScreen({Key? key, required this.feedActive})
      : super(key: key);
  final FeedActive feedActive;

  @override
  State<FeedDetailScreen> createState() => _FeedDetailScreenState();
}

class _FeedDetailScreenState extends State<FeedDetailScreen> {
  late final FileActions images;
  final FeedCubit _feedCubit = FeedCubit();
  late FeedActive _feedActive;

  @override
  void initState() {
    images = widget.feedActive.images ?? FileActions([]);
    _feedActive = widget.feedActive;
    super.initState();
  }

  @override
  void dispose() {
    _feedCubit.close();
    super.dispose();
  }

  Future like() async {
    if (_feedActive.isLiked!) {
      setState(() {
        _feedActive = _feedActive.copyWith(isLiked: false);
      });
      try {
        await _feedCubit.unLike(_feedActive.feedId!);
      } catch (e) {
        print(e);
        setState(() {
          _feedActive = _feedActive.copyWith(isLiked: true);
        });
      }
    } else {
      setState(() {
        _feedActive = _feedActive.copyWith(isLiked: true);
      });
      try {
        await _feedCubit.like(_feedActive.feedId!);
      } catch (e) {
        print(e);
        setState(() {
          _feedActive = _feedActive.copyWith(isLiked: false);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Avatar(
            size: 40,
            image: _feedActive.profileImage,
          ),
          Text(_feedActive.name!),
          if (images.isNotEmpty)
            GestureDetector(
              onDoubleTap: like,
              child: PhotoCards(
                images: images,
                isViewMode: true,
                onActions: () {},
              ),
            ),
          Text(_feedActive.description ?? ""),
          IconButton(
            icon: Icon(
                _feedActive.isLiked! ? Icons.favorite : Icons.favorite_border),
            onPressed: like,
          ),
        ],
      ),
    );
  }
}
