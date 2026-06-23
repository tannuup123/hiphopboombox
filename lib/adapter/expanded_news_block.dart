import 'package:boombox/modal/postmodal.dart';
import 'package:boombox/utils/convert_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/utils.dart';

class ExpandedNewsBlock extends StatelessWidget {
  final PostModal postModal;
  const ExpandedNewsBlock({super.key, required this.postModal});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10.r)
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r),
                    topRight: Radius.circular(10.r)),
                child: CachedNetworkImage(
                  memCacheWidth: 500,
                  fit: BoxFit.fill,
                  height: 250.h,
                  width: double.infinity,
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
                  imageUrl: postModal.landscapeImage??'',

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
                        Icon(Icons.remove_red_eye,color: Colors.white,size: 18.r,),
                        SizedBox(width: 2.w,),
                        Text(ConvertUtils.formatNumber(int.parse(postModal.views??'0')),
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(width: 2.w,)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 5.h,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(postModal.title??'',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontSize: 14.sp
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // SizedBox(height: 20.h,),
          // Divider(height: 1.h,color: Colors.white12,),
          SizedBox(height: 10.h,)
        ],
      ),
    );
  }
}
