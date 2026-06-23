import 'package:boombox/screens/video_screen/description.dart';
import 'package:boombox/screens/video_screen/reply/reply.dart';
import 'package:boombox/widget/expanded_news.dart';
import 'package:boombox/modal/comment_modal.dart';
import 'package:boombox/modal/postmodal.dart';
import 'package:boombox/screens/blocked_users/blocked_user_cubit.dart';
import 'package:boombox/screens/login/login.dart';
import 'package:boombox/screens/video_screen/comment_widget.dart';
import 'package:boombox/screens/video_screen/full_screen_portrait.dart';
import 'package:boombox/screens/video_screen/landscape_video.dart';
import 'package:boombox/screens/video_screen/portrait_video.dart';
import 'package:boombox/screens/video_screen/report/report_cubit.dart';
import 'package:boombox/screens/video_screen/video_cubit.dart';
import 'package:boombox/screens/video_screen/video_event.dart';
import 'package:boombox/utils/utils.dart';
import 'package:boombox/webview/show_webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

import '../../main.dart';
import '../../utils/convert_utils.dart';
import 'comment/comment.dart';

class VideoDetail extends StatelessWidget {
  final PostModal postModal;
  VideoDetail({super.key, required this.postModal});


  @override
  Widget build(BuildContext context) {
    // _setPortraitOrientation();
    List<String> socialMediaLinks= postModal.socialMedia!.split("http").where((link) => link.isNotEmpty).toList();
    double topPadding= MediaQuery.paddingOf(context).top; //status bar or notch height etc

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=>VideoCubit(postModal.id!)..initializePlayer(postModal.video!)),
        BlocProvider(create: (create)=>VideoOrientationCubit()),
        BlocProvider(create: (context)=>DesCommCubit()),
        BlocProvider(create: (context)=>CommentCubit(postModal.id!)..fetchComments()),
        BlocProvider(create: (context)=>ReplyCubit()),
        BlocProvider(create: (context)=>VideoByTagCubit(postModal.id!)..loadPost()),
      ],
      child: BlocBuilder<VideoOrientationCubit,VideoOrientation>(
        builder: (BuildContext context, VideoOrientation state) {
          if(state is VideoLandscape){
            return const LandscapeVideo();
          }
          else if(state is VideoFullPortrait){
            return const FullScreenPortrait();
          }
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
          ]);
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);

          return Scaffold(
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  const PortraitVideo(),

                  SizedBox(height: 10.h,),

                  BlocBuilder<DesCommCubit,VideoState>(
                      builder: (context, state){
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(postModal.title??'',
                                    style: TextStyle(
                                      fontFamily: GoogleFonts.poppins().fontFamily,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  SizedBox(height: 5.h,),
                                  Row(
                                    children: [
                                      Text('${ConvertUtils.formatNumber(int.parse(postModal.views??'0'))} views',
                                        style: TextStyle(
                                          color: Theme.of(context).brightness==Brightness.light?
                                          Colors.black54 : Colors.white54,
                                          fontFamily: GoogleFonts.poppins().fontFamily,
                                          fontSize: 14.sp,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                      SizedBox(width: 10.w,),
                                      Text(ConvertUtils.getTimeDiff(postModal.date??''),
                                        style: TextStyle(
                                          color: Theme.of(context).brightness==Brightness.light?
                                          Colors.black54 : Colors.white54,
                                          fontFamily: GoogleFonts.poppins().fontFamily,
                                          fontSize: 14.sp,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                      SizedBox(width: 10.w,),
                                      InkWell(
                                        onTap: (){
                                          _showDialog(context: context, topPadding: topPadding, isDescription: true);
                                          // context.read<DesCommCubit>().showDescription();
                                        },
                                        child: Text("...more",
                                          style: TextStyle(
                                              fontFamily: GoogleFonts.poppins().fontFamily,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),

                                    ],
                                  ),

                                  SizedBox(height: 20.h,),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        for(String link in socialMediaLinks)
                                          Padding(
                                            padding: EdgeInsets.only(right: 20.w),
                                            child: InkWell(
                                              onTap: ()=>_launchUrl(context,link),
                                              child: Image.asset(_socialImg(link),
                                                height: 30.h,width: 30.w,
                                              ),
                                            ),
                                          ),
                                        if(postModal.link!=null && postModal.link!.isNotEmpty)
                                          InkWell(
                                              onTap: (){
                                                Navigator.push(context, MaterialPageRoute(builder: (builder)=>ShowWebView(link: postModal.link??'https://hiphopboombox.com')));
                                              },
                                              child: Image.asset(Theme.of(context).brightness==Brightness.light?
                                              'assets/images/fumesocial_light_theme.png'
                                                  :'assets/images/funmesocial_dark_theme.png',
                                                height: 30.h,width: 30.w,
                                                fit: BoxFit.fill,
                                              )
                                          ),

                                        if(postModal.link!=null && postModal.link!.isNotEmpty)
                                          SizedBox(width: 20.w,),
                                      ],
                                    ),
                                  ),

                                  if(socialMediaLinks.isNotEmpty || postModal.link!.isNotEmpty)
                                    SizedBox(height: 20.h,),

                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton.icon(
                                          onPressed: (){
                                            _share(context);
                                          },
                                          style: ButtonStyle(
                                            backgroundColor: WidgetStateProperty.all(
                                              Theme.of(context).brightness==Brightness.light?
                                              Colors.black12 : Colors.white12,),
                                            padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w)),
                                          ),
                                          label: Text("Share",
                                            style: Theme.of(context).textTheme.titleSmall,
                                          ),
                                          icon: Icon(Icons.share,size: 15.sp,),
                                        ),
                                        SizedBox(width: 20.w,),

                                        TextButton.icon(
                                          onPressed: (){
                                            _showReportDialog(context);
                                          },
                                          style: ButtonStyle(
                                            backgroundColor: WidgetStateProperty.all(
                                                Theme.of(context).brightness==Brightness.light?
                                                Colors.black12 : Colors.white12
                                            ),
                                            padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w)),
                                          ),
                                          label: Text("Report",
                                            style: Theme.of(context).textTheme.titleSmall,
                                          ),
                                          icon: Icon(Icons.report,size: 15.sp,),
                                        ),
                                        SizedBox(width: 20.w,),

                                        TextButton.icon(
                                          onPressed: (){
                                            _showBlockDialog(context);
                                          },
                                          style: ButtonStyle(
                                            backgroundColor: WidgetStateProperty.all(
                                                Theme.of(context).brightness==Brightness.light?
                                                Colors.black12 : Colors.white12
                                            ),
                                            padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w)),
                                          ),
                                          label: Text("Block",
                                            style: Theme.of(context).textTheme.titleSmall,
                                          ),
                                          icon: Icon(Icons.block,size: 15.sp,),
                                        ),
                                        SizedBox(width: 20.w,),

                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20.h,),
                                  BlocBuilder<CommentCubit,FetchCommentState>(
                                    builder: (BuildContext context, state) {
                                      // if(state is CommentLoading){
                                      //   return const Center(child: CircularProgressIndicator(color: Colors.black,));
                                      // }
                                      if(state is CommentLoaded){
                                        // print('1. $state ${state.list.length}');
                                        return InkWell(
                                          onTap: () {
                                            // context.read<DesCommCubit>()
                                            //     .showComment();
                                            _showDialog(context: context, topPadding: topPadding, isDescription: false,);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).brightness==Brightness.light?
                                                Colors.black12 : Colors.white12,
                                                borderRadius: BorderRadius
                                                    .circular(10.r)
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10.h,
                                                horizontal: 10.w),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Text('Comments',
                                                  style: TextStyle(
                                                      fontFamily: GoogleFonts
                                                          .poppins()
                                                          .fontFamily,
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight
                                                          .bold
                                                  ),
                                                ),
                                                SizedBox(height: 5.h,),
                                                if(state.list.isNotEmpty)
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 30.h,
                                                        width: 30.w,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape
                                                                .circle,
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    state.list[0]
                                                                        .image !=
                                                                        '' ?
                                                                    state.list[0]
                                                                        .image! :
                                                                    'https://dummyimage.com/600x400/000/fff&text=${state
                                                                        .list[0]
                                                                        .name![0].toUpperCase()}'),
                                                                fit: BoxFit.fill
                                                            )
                                                        ),
                                                      ),
                                                      SizedBox(width: 10.w,),
                                                      Expanded(
                                                        child: Text("${state
                                                            .list[0].text}",
                                                          style: TextStyle(
                                                            fontFamily: GoogleFonts
                                                                .poppins()
                                                                .fontFamily,
                                                            fontSize: 13.sp,
                                                          ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                else
                                                  Container(
                                                    width: double.infinity,
                                                    padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 10.w),
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context).brightness==Brightness.light?
                                                      Colors.black12 : Colors.white12,
                                                      borderRadius: BorderRadius.circular(10.r),
                                                    ),
                                                    child: Text(
                                                      'Add a comment...',
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 12.sp,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                      else{
                                        return Container();
                                      }
                                    },
                                  ),

                                  SizedBox(height: 20.h,),

                                  // SizedBox(height: 10.h,),
                                  // Expanded(
                                  //   child: ListView.separated(
                                  //       itemCount: 10,
                                  //       itemBuilder: (context,index){
                                  //         return const ExpandedNewsBlock();
                                  //       },
                                  //       separatorBuilder: (BuildContext context, int index)=>SizedBox(height: 20.h,)
                                  //   ),
                                  // )
                                  BlocBuilder<VideoByTagCubit,FetchPostState>(
                                      builder: (context,state){
                                        if(state is PostLoading){
                                          return _nextVideosShimmer(context);
                                        }
                                        else if(state is PostLoaded){
                                          // print(state.list.length);
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                    text: "Next".toUpperCase(),
                                                    style: TextStyle(
                                                        fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
                                                        fontSize: 20.sp,
                                                        color: const Color(0xffee3483)
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: '  VIDEOS'.toUpperCase(),
                                                        style: TextStyle(
                                                            fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
                                                            fontSize: 20.sp,
                                                            color: const Color(0xff00e5fa)
                                                        ),
                                                      )
                                                    ]
                                                ),
                                              ),
                                              NotificationListener<ScrollNotification>(
                                                onNotification: (scrollInfo) {
                                                  if (!state.hasReachedMax &&
                                                      scrollInfo.metrics.pixels ==
                                                          scrollInfo.metrics
                                                              .maxScrollExtent) {
                                                    // print('end list');
                                                    context.read<VideoByTagCubit>().loadPost();
                                                  }
                                                  return true;
                                                },
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    itemCount: state.list.length+(state.hasReachedMax?0:1),
                                                    itemBuilder: (context,index){
                                                      if(index<state.list.length) {
                                                        return Column(
                                                          children: [
                                                            SizedBox(height: 20.h,),
                                                            InkWell(
                                                                onTap: ()=>
                                                                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (builder)=>VideoDetail(postModal: state.list[index]))),
                                                                child: ExpandedNewsWidget(postModal: state.list[index],))
                                                          ],
                                                        );
                                                      }
                                                      else if(index<48){
                                                        // print('myIndex: $index');
                                                        context.read<VideoByTagCubit>().loadPost();
                                                        return const Center(
                                                          child: CircularProgressIndicator(
                                                            color: Colors.black,),
                                                        );
                                                      }
                                                      return null;
                                                    }),
                                              ),

                                            ],
                                          );
                                        }
                                        return Container();
                                      })
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                ],
              ),
            ),
          );
        },

      ),
    );
  }


  void _showDialog({required BuildContext context, required double topPadding,
    required bool isDescription, }){
    final dialogHeight= 1.sh-(0.25.sh+topPadding);

    showBottomSheet(
        context: context,
        constraints: BoxConstraints.expand(
            width: double.infinity,
            height: dialogHeight
        ),
        clipBehavior: Clip.none,
        shape: const LinearBorder(),
        builder: (context){
          return isDescription?
          Description(postModal: postModal)
              :
          CommentDialog(postId: postModal.id!);
        }
    );
  }

  String _socialImg(String link){
    if(link.contains('instagram')){
      return 'assets/images/instagram.png';
    }
    else if(link.contains('facebook')){
      return 'assets/images/facebook.png';
    }
    else if(link.contains('tiktok')){
      return 'assets/images/tiktok.png';
    }
    else if(link.contains('x')){
      return 'assets/images/twitter.png';
    }
    else if(link.contains('youtube')){
      return 'assets/images/youtube.png';
    }
    else if(link.contains('threads')){
      return 'assets/images/threads.png';
    }
    return '';
  }

  void _launchUrl(BuildContext context, String url) {
    // if (await canLaunchUrl(Uri.parse(url))) {
    // await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    // } else {
    // throw 'Could not launch $url';
    // }
    Navigator.push(context, MaterialPageRoute(builder: (builder)=>ShowWebView(link: 'http$url'.trim().replaceAll(',', ''))));
  }

  Future<void> _share(BuildContext context) async {
    List<String> arr=(postModal.title??'').split(' ');
    String title='';
    for(int i=0; i<arr.length && i<3; i++){
      String text=arr[i].toUpperCase();
      text= i<2? '${text}_': text;
      title='$title$text';
    }

    final size=MediaQuery.of(context).size;
    final result = await Share.share('https://hiphopboombox.com/news/${postModal.id}/$title',
      sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2),
        );

    if (result.status == ShareResultStatus.success) {
      // print('Thank you for sharing my website!');
    }
  }

  Widget _nextVideosShimmer(BuildContext context){
    return Column(
      children: [
        SizedBox(height: 20.h,),
        ...List.generate(2, (index){
          return Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: Shimmer(
                gradient: Theme.of(context).brightness==Brightness.light?lightGradient: darkGradient,
                child: Container(
                  height: 260.h,
                  decoration: BoxDecoration(
                      color: Theme.of(context).brightness==Brightness.light?Colors.black:Colors.white,
                    borderRadius: BorderRadius.circular(10.r)
                  ),
                )
            ),
          );
        })
      ],
    );
  }

  void _showReportDialog(BuildContext context){
    final List<String> options = [
      'Sexual content',
      'Violent or repulsive content',
      'Hateful or abusive content',
      'Harassment or bullying',
      'Harmful or dangerous acts',
      'Misinformation',
      'Child abuse',
      'Legal issue',
      'Promotes terrorism',
      'Spam or misleading',
    ];
    showDialog(
        context: context,
        builder: (context) {
          return BlocProvider(
            create: (BuildContext context)=>ReportCubit(),
            child: BlocBuilder<ReportCubit,String>(
              builder: (BuildContext context, String selectedValue) {
                return Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
                  elevation: 16,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      SizedBox(height: 20.h),
                      Center(child: Text('Report video',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp
                        ),
                      )),
                      SizedBox(height: 20.h),
                      for (String option in options)
                        RadioListTile<String>(
                          title: Text(option,
                            style: TextStyle(
                                fontSize: 18.sp
                            ),),
                          value: option,
                          groupValue: selectedValue,
                          onChanged: (String? value) {
                            context.read<ReportCubit>().itemSelected(value);
                          },
                        ),

                      SizedBox(height: 20.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: ()=>Navigator.pop(context),
                            child: Text('Cancel',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp
                              ),),
                          ),
                          SizedBox(width: 20.w,),

                          InkWell(
                            onTap: (){
                              WidgetsBinding.instance.addPostFrameCallback((_) =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Thanks for reporting the content',
                                        style: GoogleFonts.poppins(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.blue,
                                    ),
                                  ));
                              Navigator.pop(context);
                            },
                            child: Text('Report',
                              style: TextStyle(
                                  color: selectedValue.isNotEmpty? Colors.blue : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp
                              ),),
                          ),
                          SizedBox(width: 20.w,),
                        ],
                      ),
                      SizedBox(height: 15.h,),
                    ],
                  ),
                );
              },
            ),
          );
        }
    );
  }

  void _showBlockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (create)=>BlockedUserCubit(),
          child: BlocListener<BlockedUserCubit,bool>(
            listener: (BuildContext context, isAdminBlocked) {
              if(isAdminBlocked){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>MyHomePage()),(Route<dynamic> route) => false);
              }
            },
            child: BlocBuilder<BlockedUserCubit,bool>(
              builder: (BuildContext context, bool isAdminBlocked) {
                return AlertDialog(
                  title: Text("Block user",style: GoogleFonts.poppins(),),
                  content: Text("Blocking this user will prevent all their content from appearing. You can unblock them in the account settings.",style: GoogleFonts.poppins()),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Text("Cancel"),
                    ),
                    SizedBox(width: 10.w),
                    TextButton(
                      onPressed: () async {
                        // Handle any action for the confirm button
                        Navigator.of(context).pop(); // Close the dialog
                        context.read<BlockedUserCubit>().blockAdmin();
                      },
                      child: const Text("Continue"),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}