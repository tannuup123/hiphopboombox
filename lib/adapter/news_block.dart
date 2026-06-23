import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../modal/postmodal.dart';
import '../utils/convert_utils.dart';
import '../utils/utils.dart';

class NewsBlock extends StatelessWidget {
  final PostModal postModal;
  const NewsBlock({super.key, required this.postModal});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.w,
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10.r)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r),
                    topRight: Radius.circular(10.r)),
                child: CachedNetworkImage(
                  memCacheWidth: 300,
                  fit: BoxFit.fill,
                  height: 140.h,
                  width: 150.w,
                  // memCacheHeight: 200,
                  placeholder: (context, url){
                    return Shimmer(
                        gradient: Theme.of(context).brightness==Brightness.light?lightGradient: darkGradient,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r),
                                  topRight: Radius.circular(10.r)),
                              color: Theme.of(context).brightness==Brightness.light?Colors.black:Colors.white,),
                        ));
                  },
                  errorWidget: (context,s,d){
                    return Shimmer(
                        gradient: Theme.of(context).brightness==Brightness.light?lightGradient: darkGradient,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r),
                                  topRight: Radius.circular(10.r)),
                              color: Theme.of(context).brightness==Brightness.light?Colors.black:Colors.white,),
                        ));
                  },
                  imageUrl: postModal.portraitImage??'',
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                        // color: Colors.black26,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(10.r)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.only(right: 4.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.remove_red_eye,color: Colors.white,size: 15.r,),
                        SizedBox(width: 2.w,),
                        Text(ConvertUtils.formatNumber(int.parse(postModal.views??'0')),
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13.sp,
                            fontWeight: FontWeight.bold
                          ),
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 5.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w),
            child: Text(postModal.title??'',
              style: TextStyle(
                color: Colors.white,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 14.sp
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
