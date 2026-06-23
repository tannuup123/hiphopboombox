import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

import '../../modal/comment_modal.dart';
import '../../modal/postmodal.dart';
import '../../modal/reply_modal.dart';

abstract class VideoEvent{}


abstract class VideoState{}

class VideoInitial extends VideoState{}

class VideoLoading extends VideoState{}

class VideoInitialized extends VideoState{
  final VideoPlayerController videoPlayerController;
  final bool showControls;
  VideoInitialized(this.videoPlayerController, this.showControls);
}
class VideoError extends VideoState{
  final String videoLink;

  VideoError(this.videoLink);
}


class DesInitial extends VideoState{}

class DescriptionLoading extends VideoState{}
class DescriptionShow extends VideoState{}
class DescriptionHide extends VideoState{}
class CommentShow extends VideoState{}
class CommentHide extends VideoState{}
class DescriptionLoaded extends VideoState{
  final PostModal postModal;

  DescriptionLoaded(this.postModal);
}

class ReplyShow extends VideoState{
  CommentModal commentModal;

  ReplyShow(this.commentModal);
}
class ReplyHide extends VideoState{}

abstract class FetchCommentState{}
class CommentInitial extends FetchCommentState{}
class CommentLoading extends FetchCommentState{}

class CommentLoaded extends FetchCommentState{
  final List<CommentModal> list;
  final bool hasReachedMax;

  CommentLoaded(this.list, this.hasReachedMax);
}
class CommentMoreLoading extends FetchCommentState{}

class CommentInsertLoading extends FetchCommentState{}

class CommentInsertFailed extends FetchCommentState{
  final String errorMsg;

  CommentInsertFailed(this.errorMsg);
}

class NotLoggedIn extends FetchCommentState{}

abstract class FetchReplyState{}
class ReplyInitial extends FetchReplyState{}
class ReplyLoading extends FetchReplyState{}

class ReplyLoaded extends FetchReplyState{
  final CommentModal commentModal;
  final List<ReplyModal> list;
  final bool hasReachedMax;

  ReplyLoaded(this.commentModal,this.list, this.hasReachedMax);
}

class UserNotLoggedIn extends FetchReplyState{}
class ReplyInsertLoading extends FetchReplyState{}

abstract class FetchPostState{}

class PostInitial extends FetchPostState{}

class PostLoading extends FetchPostState{}

class PostLoaded extends FetchPostState{
  final List<PostModal> list;
  final bool hasReachedMax;
  PostLoaded(this.list, this.hasReachedMax);
}


abstract class VideoOrientation{}

class VideoPortrait extends VideoOrientation{}
class VideoLandscape extends VideoOrientation{}
class VideoFullPortrait extends VideoOrientation{}