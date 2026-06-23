import 'package:boombox/screens/video_screen/reply/reply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../modal/comment_modal.dart';
import '../../../modal/reply_modal.dart';
import '../../login/login.dart';
import '../comment_widget.dart';
import '../reply_widget.dart';
import '../video_cubit.dart';
import '../video_event.dart';

class CommentDialog extends StatefulWidget {
  final String postId;
  final CommentCubit? commentCubit;
  const CommentDialog({super.key, required this.postId, this.commentCubit});

  @override
  State<CommentDialog> createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  final TextEditingController _commentController=TextEditingController();


  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DesCommCubit,VideoState>(
      builder: (BuildContext context, VideoState state) {
        if(state is ReplyShow){
          return ReplyDialog(commentModal: state.commentModal,);
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 20.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Comments',
                    style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  InkWell(
                      onTap: ()=>Navigator.pop(context),
                      child: Icon(Icons.close_sharp,size: 30.r,))
                ],
              ),
              SizedBox(height: 5.h,),
              const Divider(),
              SizedBox(height: 5.h,),
              Expanded(
                child: BlocBuilder<CommentCubit,FetchCommentState>(
                  builder: (BuildContext context, FetchCommentState state) {
                    if(state is CommentLoading){
                      return const Center(child: CircularProgressIndicator());
                    }
                    else if(state is CommentLoaded){
                      // List<CommentModal> list=state as
                      // print('$state ${state.list.length}');
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(state.list.isNotEmpty)
                            Expanded(
                              child: NotificationListener<ScrollNotification>(
                                onNotification: (scrollInfo) {
                                  if (!state.hasReachedMax &&
                                      scrollInfo.metrics.pixels ==
                                          scrollInfo.metrics.maxScrollExtent) {
                                    context.read<CommentCubit>().fetchComments();
                                  }
                                  return true;
                                },
                                child: RefreshIndicator(
                                  onRefresh: () {
                                    return context.read<CommentCubit>().reloadComments();
                                  },
                                  child: ListView.separated(
                                      itemCount: state.list.length+(state.hasReachedMax?0:1),
                                      itemBuilder: (context,index){
                                        if(index<state.list.length){
                                          CommentModal commentModal= state.list[index];
                                          return Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                                            child: CommentWidget(commentModal: commentModal,isReplyScreen: false,),
                                          );
                                        }
                                        else{
                                          return Column(
                                            children: [
                                              SizedBox(height: 5.h,),
                                              const CircularProgressIndicator(),
                                              SizedBox(height: 5.h,),
                                            ],
                                          );
                                        }
                                      },
                                      separatorBuilder: (BuildContext context, int index){
                                        return SizedBox(height: 20.h,);
                                      }
                                  ),
                                ),
                              ),
                            )
                          else
                            Expanded(
                              child: Column(
                                children: [
                                  SizedBox(height: 20.h,),
                                  Center(
                                    child: Text('No comments yet',
                                      style: GoogleFonts.poppins(
                                          fontSize: 15.sp
                                      ),),
                                  ),
                                  Text('Say something to start the conversation',
                                    style: GoogleFonts.poppins(
                                        color: Theme.of(context).brightness==Brightness.light?
                                        Colors.black54 : Colors.white54,
                                        fontSize: 15.sp
                                    ),),

                                ],
                              ),
                            ),
                          const Divider(),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.h),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness==Brightness.light?
                                    Colors.black12 : Colors.white12,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: TextFormField(
                                    controller: _commentController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Add a comment',
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10.w)
                                    ),
                                    style: TextStyle(
                                        fontFamily: GoogleFonts.poppins().fontFamily,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold

                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w,),
                              if(state is CommentInsertLoading)
                                const CircularProgressIndicator()
                              else
                                InkWell(
                                    onTap: (){
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      context.read<CommentCubit>().insertComments(_commentController.text);
                                      _commentController.text='';
                                    },
                                    child: Icon(Icons.send,color: Colors.blue,size: 25.sp,)
                                ),
                            ],
                          )
                        ],
                      );
                    }
                    else if(state is NotLoggedIn){
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>Login()));
                      });
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
