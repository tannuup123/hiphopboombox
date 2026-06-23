import 'package:boombox/screens/main_screens/search/search_cubit.dart';
import 'package:boombox/screens/main_screens/search/search_state.dart';
import 'package:boombox/screens/video_screen/video_detail.dart';
import 'package:boombox/utils/convert_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/utils.dart';

class Search extends StatelessWidget {
  Search({super.key});
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness==Brightness.light?
              Colors.black12 : Colors.white12,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: searchController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search..',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                    ),
                    style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold
                    ),
                    onChanged: (s){
                      context.read<SearchCubit>().search(s);
                    },
                  ),
                ),
                SizedBox(width: 10.w,),
                InkWell(
                    onTap: (){
                      FocusManager.instance.primaryFocus?.unfocus();
                      context.read<SearchCubit>().search(searchController.text);
                    },
                    child: Icon(Icons.search,color: Colors.blue,size: 25.sp,)),
                SizedBox(width: 10.w,),
              ],
            ),
          ),
          SizedBox(height: 20.h,),
          BlocBuilder<SearchCubit,SearchState>(
              builder: (context,state){
                if(state is RecentLoaded){
                  return Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Recent Searches",style: GoogleFonts.poppins(fontWeight: FontWeight.bold),),
                            InkWell(
                              onTap: () {
                                context.read<SearchCubit>().clearPrefs();
                              },
                              child: Text("Clear",style: GoogleFonts.poppins(color: Colors.red,fontWeight: FontWeight.bold),),
                            )
                          ],
                        ),
                        SizedBox(height: 10.h,),
                        BlocBuilder<SearchCubit,SearchState>(
                          builder: (BuildContext context, SearchState state) {

                            if(state is RecentLoaded){
                              // print('$state ${state.list.length}');
                              return Expanded(
                                  child: ListView.separated(
                                    itemCount: state.list.length,
                                    itemBuilder: (context,index){
                                      return InkWell(
                                        onTap: (){
                                          searchController.text=state.list[index];
                                          // FocusManager.instance.primaryFocus?.unfocus();
                                        },
                                        child: Text(state.list[index],
                                          style: TextStyle(
                                              fontFamily: GoogleFonts.poppins().fontFamily,
                                              fontSize: 14.sp
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context,index){
                                      return SizedBox(height: 20.h,);
                                    },
                                  )
                              );
                            }
                            return Container();
                          },

                        ),
                      ],
                    ),
                  );
                }
                else if(state is SearchLoading){
                  return const Expanded(child: Center(child: CircularProgressIndicator()));
                }
                else if(state is SearchLoaded){
                  return Expanded(
                      child: ListView.separated(
                        itemCount: state.list.length,
                        itemBuilder: (context,index){
                          return InkWell(
                            onTap: (){
                              FocusManager.instance.primaryFocus?.unfocus();
                              context.read<SearchCubit>().saveToPrefs();
                              Navigator.push(context, MaterialPageRoute(builder:
                                  (context)=>VideoDetail(postModal: state.list[index])));
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.r),
                                      child: CachedNetworkImage(
                                        memCacheWidth: 300,
                                        fit: BoxFit.fill,
                                        height: 80.h,
                                        width: 100.w,
                                        // memCacheHeight: 200,
                                        placeholder: (context, url){
                                          return Shimmer(
                                              gradient: lightGradient,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r),
                                                        topRight: Radius.circular(10.r)),
                                                    color: Colors.black),
                                              ));
                                        },
                                        errorWidget: (context,s,d){
                                          return Shimmer(
                                              gradient: lightGradient,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r),
                                                        topRight: Radius.circular(10.r)),
                                                    color: Colors.black),
                                              ));
                                        },
                                        imageUrl: state.list[index].landscapeImage??'',
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
                                              Icon(Icons.remove_red_eye,color: Colors.white,size: 13.r,),
                                              SizedBox(width: 2.w,),
                                              Text(ConvertUtils.formatNumber(int.parse(state.list[index].views??'0')),
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 11.sp,
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
                                SizedBox(width: 10.w,),
                                Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(state.list[index].title??'',
                                          style: TextStyle(
                                              fontFamily: GoogleFonts.poppins().fontFamily,
                                              fontSize: 14.sp
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    )
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context,index){
                          return SizedBox(height: 20.h,);
                        },
                      )
                  );
                }
                return Container();
              }
          )
        ],
      ),
    );
  }
}
