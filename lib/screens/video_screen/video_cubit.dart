import 'dart:math';

import 'package:boombox/widget/expanded_news.dart';
import 'package:boombox/backend/api.dart';
import 'package:boombox/backend/data_event.dart';
import 'package:boombox/modal/category_modal.dart';
import 'package:boombox/modal/comment_modal.dart';
import 'package:boombox/modal/postmodal.dart';
import 'package:boombox/modal/user_details.dart';
import 'package:boombox/screens/video_screen/video_event.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../modal/reply_modal.dart';

class DesCommCubit extends Cubit<VideoState>{

  DesCommCubit(): super(DesInitial());

  void showDescription(){
    emit(DescriptionShow());
  }

  void hideDescription(){
    emit(DescriptionHide());
  }

  void showComment(){
    emit(CommentShow());
  }

  void hideComment(){
    emit(CommentHide());
  }

  void showReply(CommentModal commentModal){
    emit(ReplyShow(commentModal));
  }

  void hideReply(){
    emit(ReplyHide());
  }

  Future<void> getPostDetails(String postId) async {
    emit(DescriptionLoading());
    PostModal postModal = await MyApi.getInstance.getPostById(postId);
    if(!isClosed) {
      emit(DescriptionLoaded(postModal));
    }
  }
}

class VideoCubit extends Cubit<VideoState>{

  String postId;
  VideoCubit(this.postId): super(VideoInitial());

  late VideoPlayerController _controller;
  bool _showControls=false;
  bool _isControlChecking=false;
  Widget? playerWidget;

  Future<void> initializePlayer(String link) async {
    WakelockPlus.enable();
    // link='https://videos.pexels.com/video-files/2795405/2795405-uhd_1440_2560_25fps.mp4';
    // link='https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

    emit(VideoLoading());
    try{
      _controller.dispose();
    }
    catch(e){}
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        link))
      ..initialize().then((_) {
        _controller.play();
        _showControls=false;
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        if(!isClosed) {
          emit(VideoInitialized(_controller,_showControls));
        }
      },onError: (_,s){
        if(!isClosed){
          emit(VideoError(link));
        }
      }
      );
    _controller.addListener(() async {
      if(_controller.value.isPlaying && _showControls && !_isControlChecking){
        _isControlChecking=true;
        await Future.delayed(const Duration(seconds: 3));
        _isControlChecking=false;
        if(_controller.value.isPlaying && _showControls && !isClosed){
          // print("showC $_showControls");
          _showControls=!_showControls;
          emit(VideoInitialized(_controller,_showControls));
        }
      }
    });
    await MyApi.getInstance.updateViews(postId);
  }

  void toggleControls(){
    _showControls=!_showControls;
    emit(VideoInitialized(_controller,_showControls));
  }

  void toggleVideoPlay(){
    _controller.value.isPlaying?
    _controller.pause(): _controller.play();

    emit(VideoInitialized(_controller,_showControls));
  }

  void forwardVideo(){
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition + const Duration(seconds: 10);
    _controller.seekTo(newPosition);
  }

  void backwardVideo(){
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition - const Duration(seconds: 10);
    _controller.seekTo(newPosition);
  }

  @override
  Future<void> close() {
    _controller.dispose();
    WakelockPlus.disable();
    return super.close();
  }

}

class VideoOrientationCubit extends Cubit<VideoOrientation>{
  VideoOrientationCubit():super(VideoPortrait());

  void landscape(VideoPlayerController v){
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.landscapeLeft,
    // ]);
    // print(v.value.aspectRatio);
    if(v.value.aspectRatio<1){
      emit(VideoFullPortrait());
    }
    else {
      emit(VideoLandscape());
    }
  }

  void portrait(){
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    // ]);
    emit(VideoPortrait());
  }

}


class CommentCubit extends Cubit<FetchCommentState>{

  bool _hasReachedMax=false;
  final String postId;
  bool _isLoading=false;
  CommentCubit(this.postId):super(CommentInitial());

  Future<void> fetchComments() async {
    if(_hasReachedMax || _isLoading) return;
    List<CommentModal> oldList= (state is CommentLoaded)? (state as CommentLoaded).list : [];
    if(oldList.isEmpty) {
      emit(CommentLoading());
    }
    _isLoading=true;
    List<CommentModal> list= await MyApi.getInstance.getComments(postId, oldList.length);
    _isLoading=false;
    if(list.isEmpty ){
      _hasReachedMax=true;
    }
    else{
      oldList.addAll(list);
    }

    if(list.length<5){
      _hasReachedMax=true;
    }

    if (isClosed) return;
    emit(CommentLoaded(oldList,_hasReachedMax));
  }

  Future<void> reloadComments() async {
    _hasReachedMax=false;
    if(_isLoading) return;

    emit(CommentLoading());
    _isLoading=true;
    List<CommentModal> list= await MyApi.getInstance.getComments(postId, 0);
    _isLoading=false;
    if(list.isEmpty ){
      _hasReachedMax=true;
    }

    if(list.length<5){
      _hasReachedMax=true;
    }

    if (isClosed) return;
    emit(CommentLoaded(list,_hasReachedMax));
  }



  Future<void> insertComments(String text)async {
    if(UserDetails.id==null || UserDetails.id==''){
      emit(NotLoggedIn());
      return;
    }
    if(text.trim().isEmpty){
      // emit(CommentInsertFailed('Comment can be empty'));
      return;
    }
    List<CommentModal> oldList= (state is CommentLoaded)? (state as CommentLoaded).list : [];
    CommentModal commentModal=await MyApi.getInstance.insertComment(UserDetails.id!, postId, text);
    emit(CommentInsertLoading());
    oldList.insert(0, commentModal);
    // print(oldList.length);
    emit(CommentLoaded(oldList,_hasReachedMax));
  }

}
class ReplyCubit extends Cubit<FetchReplyState>{

  bool _hasReachedMax=false;
  bool _isLoading=false;
  ReplyCubit():super(ReplyInitial());

  Future<void> fetchReply(CommentModal commentModal) async {
    _hasReachedMax=false;
    emit(ReplyLoading());
    List<ReplyModal> list= await MyApi.getInstance.getReplies(commentModal.id!, 0);
    if(list.isEmpty || list.length<5){
      _hasReachedMax=true;
    }
    if (isClosed) return;
    emit(ReplyLoaded(commentModal,list,_hasReachedMax));
  }

  Future<void> loadMoreReply(CommentModal commentModal) async {
    if(_hasReachedMax || _isLoading) return;
    List<ReplyModal> oldList= (state is ReplyLoaded)? (state as ReplyLoaded).list : [];
    if(oldList.isEmpty) {
      emit(ReplyLoading());
    }
    // print(oldList.length);
    _isLoading=true;
    List<ReplyModal> list= await MyApi.getInstance.getReplies(commentModal.id!, oldList.length);
    _isLoading=false;

    if(list.isEmpty){
      _hasReachedMax=true;
    }
    else{
      oldList.addAll(list);
    }
    if (isClosed) return;
    emit(ReplyLoaded(commentModal,oldList,_hasReachedMax));
  }

  Future<void> insertReply(CommentModal commentModal,String text) async {
    // emit(ReplyLoading());
    if(UserDetails.id==null || UserDetails.id==''){
      emit(UserNotLoggedIn());
      return;
    }
    List<ReplyModal> oldList= (state is ReplyLoaded)? (state as ReplyLoaded).list : [];
    ReplyModal replyModal= await MyApi.getInstance.insertReply(UserDetails.id!, commentModal.id!, text);
    emit(ReplyInsertLoading());
    oldList.insert(0,replyModal);
    if (isClosed) return;
    emit(ReplyLoaded(commentModal,oldList,_hasReachedMax));
  }

}

class VideoByTagCubit extends Cubit<FetchPostState>{
  bool _hasReachedMax=false;
  List<CategoryModal> categoryList=[];
  final String postId;

  VideoByTagCubit(this.postId):super(PostInitial());

  Future<void> loadPost() async {
    if(_hasReachedMax) return;
    List<PostModal> oldList= (state is PostLoaded)? (state as PostLoaded).list : [];
    if(oldList.isEmpty) {
      emit(PostLoading());
    }
    categoryList= categoryList.isEmpty? await MyApi.getInstance.getVideoTags(postId) : categoryList;
    List<PostModal> postList=await MyApi.getInstance.getVideosByCategory(postId,categoryList[0].id,oldList.length);
    // if(postList.isEmpty){
    //   postList=await MyApi.getInstance.getVideosByCategory(postId,categoryList[0].id,oldList.length);
    // }
    if(postList.isEmpty){
      _hasReachedMax=true;
    }
    else{
      oldList.addAll(postList);
    }
    if (isClosed) return;
    emit(PostLoaded(oldList,_hasReachedMax));
  }

  int get randomNum=>Random().nextInt(categoryList.length);
}
