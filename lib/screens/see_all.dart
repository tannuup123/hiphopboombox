import 'package:boombox/modal/postmodal.dart';
import 'package:boombox/screens/video_screen/video_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/utils.dart';
import '../widget/expanded_news.dart';

class SeeAll extends StatelessWidget {
  final String text1,text2;
  final List<PostModal> list;
  const SeeAll({super.key, required this.text1, required this.text2, required this.list, });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: text1.toUpperCase(),
              style: TextStyle(
                  fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
                  fontSize: 20.sp,
                  color: const Color(0xffee3483)
              ),
              children: [
                TextSpan(
                  text: '  $text2'.toUpperCase(),
                  style: TextStyle(
                      fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
                      fontSize: 20.sp,
                      color: const Color(0xff00e5fa)
                  ),
                )
              ]
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Column(
          children: [
            Expanded(
                child: ListView.separated(
                    itemCount: list.length,
                    itemBuilder: (context,index){
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: InkWell(
                          onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (builder)=> VideoDetail(postModal: list[index],))),
                          child: ExpandedNewsWidget(postModal: list[index],),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index)=>SizedBox(height: 20.h,)
                )
            )
          ],
        ),
      ),
    );
  }
}
