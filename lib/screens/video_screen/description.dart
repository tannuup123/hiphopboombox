import 'package:boombox/modal/postmodal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../utils/convert_utils.dart';

class Description extends StatelessWidget {
  final PostModal postModal;
  const Description({super.key, required this.postModal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 20.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Description',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(postModal.title??'',
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
                            fontSize: 18.sp,
                          ),
                        ),
                        SizedBox(height: 3.h,),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Posted: ${DateFormat('dd MMMM yyyy').format(DateTime.parse(postModal.date??''))}',
                              style: TextStyle(
                                  color: Theme.of(context).brightness==Brightness.light?
                                  Colors.black45 : Colors.white54,
                                  fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
                                  fontSize: 13.sp
                              ),
                            ),
                            SizedBox(width: 10.w,),
                            Icon(Icons.remove_red_eye,color: const Color(0xffee3483),size: 15.r,),
                            SizedBox(width: 2.w,),
                            Text(ConvertUtils.formatCommaNumber(int.parse(postModal.views??'0')),
                              style: TextStyle(
                                  color: Theme.of(context).brightness==Brightness.light?
                                  Colors.black45 : Colors.white54,
                                  fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
                                  fontSize: 13.sp
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h,),

                        SafeArea(
                          child: Text(postModal.des??'',
                            style: TextStyle(
                              color: Theme.of(context).brightness==Brightness.light?
                              Colors.black87 : Colors.white70,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
