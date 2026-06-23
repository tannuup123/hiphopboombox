import 'package:boombox/backend/api.dart';
import 'package:boombox/modal/user_details.dart';
import 'package:boombox/screens/login/login.dart';
import 'package:boombox/screens/main_screens/polls/poll_bloc.dart';
import 'package:boombox/screens/main_screens/polls/poll_state.dart';
import 'package:boombox/theme/theme_cubit.dart';
import 'package:boombox/utils/convert_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/utils.dart';

class Polls extends StatelessWidget {
  const Polls({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: ()=>context.read<PollCubit>().fetchPoll(),
      child: BlocBuilder<PollCubit,PollState>(
          builder: (context,state){
            if(state is PollLoading){
              return const Center(child: CircularProgressIndicator(),);
            }
            else if(state is PollLoaded){
              if(state.list.isNotEmpty) {
                return ListView.separated(
                  itemBuilder: (context,index){
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Column(
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
                                return _imageShimmer(context);
                              },
                              errorWidget: (context,s,d){
                                return _imageShimmer(context);
                              },
                              imageUrl: state.list[index].questionModal.portraitImage,

                            ),
                          ),
                          SizedBox(height: 10.h,),
                          BlocBuilder<ThemeCubit,ThemeMode>(
                            builder: (BuildContext context, ThemeMode mode) {
                              return Text(state.list[index].questionModal.question,style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                  fontSize: 22.sp,
                                  color: Theme.of(context).brightness==Brightness.light?Colors.black:Colors.white
                              ),);
                            },
                          ),
                          SizedBox(height: 20.h,),
                          BlocBuilder<VoteCubit,VoteState>(
                            builder: (BuildContext context, VoteState v) {
                              if(v is VoteSelected){
                                return Column(
                                  children: [
                                    ...List.generate(state.list[index].optionList.length, (i){
                                      return InkWell(
                                        onTap: ()=>context.read<VoteCubit>()
                                            .optionSelected(i,state.list[index].questionModal.pollId,state.list[index].optionList[i].optionId),

                                        child: Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.symmetric(vertical:5.h),
                                          padding: EdgeInsets.symmetric(vertical:10.h,horizontal: 10.w),
                                          decoration: BoxDecoration(
                                              color: v.selectedIndex==i? const Color(0xffee3483): Colors.transparent,
                                              borderRadius: BorderRadius.circular(10.r),
                                              border: Border.all(
                                                  color: Theme.of(context).brightness==Brightness.light? Colors.black: Colors.white,
                                                  width: 1.w
                                              )
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(state.list[index].optionList[i].optionText,
                                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                      fontSize: 18.sp,
                                                      color: v.selectedIndex==i?Colors.white:Theme.of(context).textTheme.bodyMedium!.color

                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 15.w,),
                                              if(v.submittedIndex>-1)
                                                Text("${ConvertUtils.formatNumber(int.parse(state.list[index].optionList[i].votes)+1)} votes",
                                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                      fontSize: 18.sp,
                                                      color: v.selectedIndex==i?Colors.white:Theme.of(context).textTheme.bodyMedium!.color
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                    SizedBox(height: 20.h,),
                                    InkWell(
                                      onTap: (){
                                        if(UserDetails.id==null || UserDetails.id==''){
                                          Navigator.push(context, MaterialPageRoute(builder: (builder)=>Login()));
                                        }
                                        else if(v.submittedIndex==-1){
                                          context.read<VoteCubit>().optionSubmitted();
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 30.w),
                                        decoration: BoxDecoration(
                                            color: v.submittedIndex>-1? Colors.grey : Colors.green,
                                            borderRadius: BorderRadius.circular(15.r)
                                        ),
                                        child: Text('Submit',style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold
                                        ),),
                                      ),
                                    ),
                                    SizedBox(height: 20.h,),

                                    BlocBuilder<ThemeCubit,ThemeMode>(
                                      builder: (BuildContext context, ThemeMode mode) {
                                        if(v.submittedIndex>-1) {
                                          return Row(
                                            children: [
                                              Text("Share:",
                                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                    fontSize: 18.sp,
                                                    color: Theme.of(context).brightness==Brightness.light?Colors.black:Colors.white
                                                ),
                                              ),
                                              SizedBox(width: 20.w,),
                                              InkWell(
                                                  onTap: ()=>shareToFacebook(state.list[index].questionModal.question),
                                                  child: Image.asset('assets/images/facebook.png',height: 20.h,width: 20.w,)
                                              ),
                                              SizedBox(width: 20.w,),
                                              InkWell(
                                                  onTap: ()=>shareToThreads(state.list[index].questionModal.question),
                                                  child: Image.asset('assets/images/threads.png',height: 20.h,width: 20.w,)
                                              ),
                                              SizedBox(width: 20.w,),
                                              InkWell(
                                                onTap: ()=>shareToTwitter(state.list[index].questionModal.question),
                                                child: Image.asset(Theme.of(context).brightness==Brightness.light?
                                                'assets/images/twitter.png':'assets/images/twitter_white.png',
                                                  height: 20.h,width: 20.w,),
                                              )
                                            ],
                                          );
                                        }
                                        return Container();
                                      },),
                                  ],
                                );
                              }
                              return Container();
                            },),



                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context,index)=>SizedBox(height: 10.h,),
                  itemCount: state.list.length
              );
              }
              else{
                return const Center(
                  child: Text('No polls are available right now'),
                );
              }
            }
            return Container();
          }
      ),
    );
  }

  Widget _imageShimmer(BuildContext context){
    return Shimmer(
        gradient: Theme.of(context).brightness==Brightness.light?lightGradient: darkGradient,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r)),
            color: Theme.of(context).brightness==Brightness.light?Colors.black:Colors.white,),
        ));
  }

  final String pollLink = 'https://hiphopboombox.com/polls/?id1=0&id2=0';

  void shareToFacebook(String text) async {
    final url = Uri.parse('https://www.facebook.com/sharer/sharer.php?u=$pollLink&quote=${Uri.encodeComponent(text)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void shareToTwitter(String text) async {
    final url = Uri.parse('https://twitter.com/intent/tweet?text=${Uri.encodeComponent(text)}&url=$pollLink');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void shareToThreads(String text) async {
    final url = Uri.parse('https://www.threads.net/share?text=${Uri.encodeComponent(text)}&url=$pollLink');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}
