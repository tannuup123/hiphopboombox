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

class ReplyDialog extends StatefulWidget {
  final CommentModal commentModal;
  const ReplyDialog({super.key, required this.commentModal,});

  @override
  State<ReplyDialog> createState() => _ReplyDialogState();
}

class _ReplyDialogState extends State<ReplyDialog> {
  final TextEditingController _replyController=TextEditingController();

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>ReplyCubit()..fetchReply(widget.commentModal),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                    onTap: (){
                      context.read<DesCommCubit>().showComment();
                      // Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios,size: 30.r,)),
                SizedBox(width: 5.w,),

                Text('Replies',
                  style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const Spacer(),
                InkWell(
                    onTap: (){
                      // context.read<DesCommCubit>().hideReply();
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close_sharp,size: 30.r,))
              ],
            ),
            SizedBox(height: 5.h,),
            const Divider(),
            SizedBox(height: 5.h,),
            BlocBuilder<ReplyCubit,FetchReplyState>(
              builder: (context, state) {
                if(state is ReplyLoading){
                  return const Expanded(child: Center(child: CircularProgressIndicator()));
                }
                else if(state is ReplyLoaded){
                  // List<CommentModal> list=state as
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommentWidget(commentModal: state.commentModal,isReplyScreen: true,),

                        const Divider(),
                        SizedBox(height: 5.h,),

                        if(state.list.isNotEmpty)
                          Expanded(
                            child: NotificationListener<ScrollNotification>(
                              onNotification: (scrollInfo) {
                                if (!state.hasReachedMax &&
                                    scrollInfo.metrics.pixels ==
                                        scrollInfo.metrics.maxScrollExtent) {
                                  context.read<ReplyCubit>().loadMoreReply(widget.commentModal);
                                }
                                return true;
                              },
                              child: Padding(
                                padding: EdgeInsets.only(left: 25.w),
                                child: ListView.separated(
                                    itemCount: state.list.length+(state.hasReachedMax?0:1),
                                    itemBuilder: (context,index){
                                      if(index<state.list.length){
                                        ReplyModal replyModal= state.list[index];
                                        return Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                                          child: ReplyWidget(replyModal: replyModal,),
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
                                  child: Text('No Reply yet',
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
                                  controller: _replyController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Add a reply',
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
                            InkWell(
                                onTap: (){
                                  context.read<ReplyCubit>().insertReply(widget.commentModal, _replyController.text);
                                  _replyController.text='';
                                },
                                child: state is ReplyInsertLoading? const CircularProgressIndicator():
                                Icon(Icons.send,color: Colors.blue,size: 25.sp,)
                            )
                          ],
                        )
                      ],
                    ),
                  );
                }
                else if(state is UserNotLoggedIn){
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>Login()));
                  });
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}