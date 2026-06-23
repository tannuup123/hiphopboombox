import 'package:boombox/widget/report_alert.dart';
import 'package:boombox/modal/comment_modal.dart';
import 'package:boombox/screens/video_screen/video_cubit.dart';
import 'package:boombox/screens/video_screen/video_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/convert_utils.dart';

class CommentWidget extends StatelessWidget {
   final CommentModal commentModal;
   final bool isReplyScreen;

   const CommentWidget(
      {required this.commentModal,
   super.key, required this.isReplyScreen}); // const CommentWidget({super.key});


  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 30.h,
          width: 30.w,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage(commentModal.image!=''? commentModal.image! :
                  'https://dummyimage.com/600x400/000/fff&text=${commentModal.name![0].toUpperCase()}'),
                  fit: BoxFit.fill
              )
          ),
        ),
        SizedBox(width: 15.w,),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(commentModal.name??'',
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // SizedBox(width: 5.w,),
                  // Icon(Icons.circle,color: Colors.black,size: 8.r,),
                  SizedBox(width: 5.w,),
          
                  Text(ConvertUtils.getRelativeTime(commentModal.date!, commentModal.usaTimestamp!),
                    style: TextStyle(
                      color: Theme.of(context).brightness==Brightness.light?
                      Colors.black54 : Colors.white54,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(width: 10.w,),
                  
                  InkWell(
                    onTap: (){
                      ReportAlert.showReportDialog(context);
                    },
                      child: Icon(Icons.more_vert,size: 15.sp,)
                  ),
                  SizedBox(width: 10.w,),
                  
                ],
              ),
              SizedBox(height: 5.h,),
              Text(commentModal.text??'',
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontSize: 13.sp,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: (){
          
                    },
                     style: TextButton.styleFrom(padding: EdgeInsets.zero,minimumSize: Size.zero,),
                    label: Text(commentModal.likes??'0',
                      style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold
          
                      ),
                    ),
                    icon: Icon(Icons.thumb_up_alt_outlined,size: 18.r,),
                  ),
                  SizedBox(width: 5.w,),
                  TextButton.icon(
                    onPressed: (){
          
                    },
                    label: Text(commentModal.dislikes??'0',
                      style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold
          
                      ),
                    ),
                    icon: Icon(Icons.thumb_down_alt_outlined,size: 18.r,),
                  ),
                ],
              ),
              SizedBox(height: 2.h,),
          
          
              if(commentModal.showReplies && !isReplyScreen)
                InkWell(
                  onTap: (){
                    context.read<DesCommCubit>().showReply(commentModal);
                    // Navigator.pushNamed(context, '/reply');
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 5.h),
                    child: Text('Show Replies',
                      style: TextStyle(
                          color: Colors.blue,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold
          
                      ),
                    ),
                  ),
                )
              else if(!isReplyScreen)
                InkWell(
                  onTap: (){
                    context.read<DesCommCubit>().showReply(commentModal);
                    // Navigator.pushNamed(context, '/reply',arguments: commentModal);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 5.h),
                    child: Text('Add Reply',
                      style: TextStyle(
                          color: Colors.blue,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold

                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
