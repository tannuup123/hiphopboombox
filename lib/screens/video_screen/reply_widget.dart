import 'package:boombox/modal/reply_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/convert_utils.dart';
import '../../widget/report_alert.dart';

class ReplyWidget extends StatelessWidget {
  final ReplyModal replyModal;

  const ReplyWidget({
    required this.replyModal,
    super.key});

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
                  image: NetworkImage(replyModal.image!=''? replyModal.image! :
                  'https://dummyimage.com/600x400/000/fff&text=${replyModal.name![0].toUpperCase()}'),
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
                    child: Text(replyModal.name??'',
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

                  Text(ConvertUtils.getRelativeTime(replyModal.date!, replyModal.usaTimestamp!),
                    style: TextStyle(
                      color: Theme.of(context).brightness==Brightness.light?
                      Colors.black54 : Colors.white54,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 11.sp,
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
              Text(replyModal.text??'',
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
                    label: Text(replyModal.likes??'0',
                      style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold

                      ),
                    ),
                    icon: Icon(Icons.thumb_up_alt_outlined,size: 18.r,),
                  ),
                  SizedBox(width: 5.w,),
                  TextButton.icon(
                    onPressed: (){

                    },
                    label: Text(replyModal.dislikes??'0',
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
            ],
          ),
        ),
      ],
    );
  }
}
