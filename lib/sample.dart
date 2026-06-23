// import 'package:boombox/widget/expanded_news.dart';
// import 'package:boombox/modal/comment_modal.dart';
// import 'package:boombox/modal/postmodal.dart';
// import 'package:boombox/modal/reply_modal.dart';
// import 'package:boombox/screens/blocked_users/blocked_user_cubit.dart';
// import 'package:boombox/screens/login/login.dart';
// import 'package:boombox/screens/video_screen/comment_widget.dart';
// import 'package:boombox/screens/video_screen/full_screen_portrait.dart';
// import 'package:boombox/screens/video_screen/landscape_video.dart';
// import 'package:boombox/screens/video_screen/portrait_video.dart';
// import 'package:boombox/screens/video_screen/reply_widget.dart';
// import 'package:boombox/screens/video_screen/report/report_cubit.dart';
// import 'package:boombox/screens/video_screen/video_cubit.dart';
// import 'package:boombox/screens/video_screen/video_event.dart';
// import 'package:boombox/utils/utils.dart';
// import 'package:boombox/webview/show_webview.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../main.dart';
// import '../../utils/convert_utils.dart';
//
// class Sample extends StatelessWidget {
//   final String postId;
//   final String postTitle;
//   final String videoLink;
//   Sample({super.key, required this.postId, required this.postTitle, required this.videoLink});
//
//   final TextEditingController _commentController=TextEditingController();
//   final TextEditingController _replyController=TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     // _setPortraitOrientation();
//     // Map<String,dynamic> map= ConvertUtils.filterLinks(postModal.des??'');
//
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (context)=>VideoCubit(postId)..initializePlayer(videoLink)),
//         BlocProvider(create: (create)=>VideoOrientationCubit()),
//         BlocProvider(create: (context)=>DesCommCubit()..getPostDetails(postId)),
//         BlocProvider(create: (context)=>CommentCubit(postId)..fetchComments()),
//         BlocProvider(create: (context)=>ReplyCubit()),
//         BlocProvider(create: (context)=>VideoByTagCubit(postId)..loadPost()),
//       ],
//       child: BlocBuilder<VideoOrientationCubit,VideoOrientation>(
//         builder: (BuildContext context, VideoOrientation state) {
//
//           if(state is VideoLandscape){
//             return const LandscapeVideo();
//           }
//           else if(state is VideoFullPortrait){
//             return const FullScreenPortrait();
//           }
//           SystemChrome.setPreferredOrientations([
//             DeviceOrientation.portraitUp,
//           ]);
//           SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
//
//           return Scaffold(
//             backgroundColor: Colors.white,
//             body: SafeArea(
//               child: Column(
//                 children: [
//                   const PortraitVideo(),
//
//                   SizedBox(height: 10.h,),
//
//                   BlocBuilder<DesCommCubit,VideoState>(
//                       builder: (context, state){
//                         if(state is DescriptionShow){
//                           return _showDialog(context,map);
//                         }
//                         else if(state is CommentShow){
//                           return _showComments(context);
//                         }
//                         else if(state is ReplyShow){
//                           return _showReplies(state.commentModal,context);
//                         }
//                         else{
//                           return Expanded(
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 10.w),
//                               child: SingleChildScrollView(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(postModal.title??'',
//                                       style: TextStyle(
//                                         color: Colors.black,
//                                         fontFamily: GoogleFonts.poppins().fontFamily,
//                                         fontSize: 18.sp,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                       overflow: TextOverflow.ellipsis,
//                                       maxLines: 2,
//                                     ),
//                                     SizedBox(height: 5.h,),
//                                     Row(
//                                       children: [
//                                         Text('${ConvertUtils.formatNumber(int.parse(postModal.views??'0'))} views',
//                                           style: TextStyle(
//                                             color: Colors.black54,
//                                             fontFamily: GoogleFonts.poppins().fontFamily,
//                                             fontSize: 14.sp,
//                                           ),
//                                           overflow: TextOverflow.ellipsis,
//                                           maxLines: 2,
//                                         ),
//                                         SizedBox(width: 10.w,),
//                                         Text(ConvertUtils.getTimeDiff(postModal.date??''),
//                                           style: TextStyle(
//                                             color: Colors.black54,
//                                             fontFamily: GoogleFonts.poppins().fontFamily,
//                                             fontSize: 14.sp,
//                                           ),
//                                           overflow: TextOverflow.ellipsis,
//                                           maxLines: 2,
//                                         ),
//                                         SizedBox(width: 10.w,),
//                                         InkWell(
//                                           onTap: (){
//                                             context.read<DesCommCubit>().showDescription();
//                                           },
//                                           child: Text("...more",
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontFamily: GoogleFonts.poppins().fontFamily,
//                                                 fontSize: 14.sp,
//                                                 fontWeight: FontWeight.bold,
//                                                 letterSpacing: 1
//                                             ),
//                                             overflow: TextOverflow.ellipsis,
//                                             maxLines: 2,
//                                           ),
//                                         ),
//
//                                       ],
//                                     ),
//
//                                     SizedBox(height: 20.h,),
//                                     SingleChildScrollView(
//                                       scrollDirection: Axis.horizontal,
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                         children: [
//                                           for(String link in map['links'])
//                                             Padding(
//                                               padding: EdgeInsets.only(right: 40.w),
//                                               child: InkWell(
//                                                 onTap: ()=>_launchUrl(context,link),
//                                                 child: Image.asset(_socialImg(link),
//                                                   height: 30.h,width: 30.w,
//                                                 ),
//                                               ),
//                                             ),
//                                           if(postModal.link!=null && postModal.link!.isNotEmpty)
//                                             InkWell(
//                                                 onTap: (){
//                                                   _launchUrl(context,postModal.link??'hiphopboombox.com');
//                                                 },
//                                                 child: Image.asset('assets/images/funmesocial.jpeg',
//                                                   height: 30.h,width: 30.w,
//                                                 )
//                                             ),
//
//                                           if(postModal.link!=null && postModal.link!.isNotEmpty)
//                                             SizedBox(width: 20.w,),
//                                         ],
//                                       ),
//                                     ),
//
//                                     if((map['links'] as List).isNotEmpty || postModal.link!.isNotEmpty)
//                                       SizedBox(height: 20.h,),
//
//                                     SingleChildScrollView(
//                                       scrollDirection: Axis.horizontal,
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                         children: [
//                                           TextButton.icon(
//                                             onPressed: (){
//                                               _share(context);
//                                             },
//                                             style: ButtonStyle(
//                                               backgroundColor: WidgetStateProperty.all(Colors.black12),
//                                               padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w)),
//                                             ),
//                                             label: Text("Share",
//                                               style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontFamily: GoogleFonts.poppins().fontFamily,
//                                                 fontSize: 12.sp,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             icon: Icon(Icons.share,color:Colors.black,size: 15.sp,),
//                                           ),
//                                           SizedBox(width: 20.w,),
//
//                                           TextButton.icon(
//                                             onPressed: (){
//                                               _showReportDialog(context);
//                                             },
//                                             style: ButtonStyle(
//                                               backgroundColor: WidgetStateProperty.all(Colors.black12),
//                                               padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w)),
//                                             ),
//                                             label: Text("Report",
//                                               style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontFamily: GoogleFonts.poppins().fontFamily,
//                                                 fontSize: 12.sp,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             icon: Icon(Icons.report,color:Colors.black,size: 15.sp,),
//                                           ),
//                                           SizedBox(width: 20.w,),
//
//                                           TextButton.icon(
//                                             onPressed: (){
//                                               _showBlockDialog(context);
//                                             },
//                                             style: ButtonStyle(
//                                               backgroundColor: WidgetStateProperty.all(Colors.black12),
//                                               padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w)),
//                                             ),
//                                             label: Text("Block",
//                                               style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontFamily: GoogleFonts.poppins().fontFamily,
//                                                 fontSize: 12.sp,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             icon: Icon(Icons.block,color:Colors.black,size: 15.sp,),
//                                           ),
//                                           SizedBox(width: 20.w,),
//
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: 20.h,),
//                                     BlocBuilder<CommentCubit,FetchCommentState>(
//                                       builder: (BuildContext context, state) {
//                                         // if(state is CommentLoading){
//                                         //   return const Center(child: CircularProgressIndicator(color: Colors.black,));
//                                         // }
//                                         if(state is CommentLoaded){
//                                           // print('1. $state ${state.list.length}');
//                                           return InkWell(
//                                             onTap: () {
//                                               context.read<DesCommCubit>()
//                                                   .showComment();
//                                             },
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                   color: Colors.black12,
//                                                   borderRadius: BorderRadius
//                                                       .circular(10.r)
//                                               ),
//                                               padding: EdgeInsets.symmetric(
//                                                   vertical: 10.h,
//                                                   horizontal: 10.w),
//                                               child: Column(
//                                                 crossAxisAlignment: CrossAxisAlignment
//                                                     .start,
//                                                 children: [
//                                                   Text('Comments',
//                                                     style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontFamily: GoogleFonts
//                                                             .poppins()
//                                                             .fontFamily,
//                                                         fontSize: 16.sp,
//                                                         fontWeight: FontWeight
//                                                             .bold
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: 5.h,),
//                                                   if(state.list.isNotEmpty)
//                                                     Row(
//                                                       children: [
//                                                         Container(
//                                                           height: 30.h,
//                                                           width: 30.w,
//                                                           decoration: BoxDecoration(
//                                                               shape: BoxShape
//                                                                   .circle,
//                                                               image: DecorationImage(
//                                                                   image: NetworkImage(
//                                                                       state.list[0]
//                                                                           .image !=
//                                                                           '' ?
//                                                                       state.list[0]
//                                                                           .image! :
//                                                                       'https://dummyimage.com/600x400/000/fff&text=${state
//                                                                           .list[0]
//                                                                           .name![0].toUpperCase()}'),
//                                                                   fit: BoxFit.fill
//                                                               )
//                                                           ),
//                                                         ),
//                                                         SizedBox(width: 10.w,),
//                                                         Expanded(
//                                                           child: Text("${state
//                                                               .list[0].text}",
//                                                             style: TextStyle(
//                                                               color: Colors.black,
//                                                               fontFamily: GoogleFonts
//                                                                   .poppins()
//                                                                   .fontFamily,
//                                                               fontSize: 13.sp,
//                                                             ),
//                                                             maxLines: 2,
//                                                             overflow: TextOverflow
//                                                                 .ellipsis,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     )
//                                                   else
//                                                     Container(
//                                                       width: double.infinity,
//                                                       padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 10.w),
//                                                       decoration: BoxDecoration(
//                                                         color: Colors.black12,
//                                                         borderRadius: BorderRadius.circular(10.r),
//                                                       ),
//                                                       child: Text(
//                                                         'Add a comment...',
//                                                         style: GoogleFonts.poppins(
//                                                           fontSize: 12.sp,
//                                                           color: Colors.black,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                 ],
//                                               ),
//                                             ),
//                                           );
//                                         }
//                                         else{
//                                           return Container();
//                                         }
//                                       },
//                                     ),
//
//                                     SizedBox(height: 20.h,),
//
//                                     // SizedBox(height: 10.h,),
//                                     // Expanded(
//                                     //   child: ListView.separated(
//                                     //       itemCount: 10,
//                                     //       itemBuilder: (context,index){
//                                     //         return const ExpandedNewsBlock();
//                                     //       },
//                                     //       separatorBuilder: (BuildContext context, int index)=>SizedBox(height: 20.h,)
//                                     //   ),
//                                     // )
//                                     BlocBuilder<VideoByTagCubit,FetchPostState>(
//                                         builder: (context,state){
//                                           if(state is PostLoading){
//                                             return _nextVideosShimmer();
//                                           }
//                                           else if(state is PostLoaded){
//                                             // print(state.list.length);
//                                             return Column(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 RichText(
//                                                   textAlign: TextAlign.center,
//                                                   text: TextSpan(
//                                                       text: "Next".toUpperCase(),
//                                                       style: TextStyle(
//                                                           fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
//                                                           fontSize: 20.sp,
//                                                           color: const Color(0xffee3483)
//                                                       ),
//                                                       children: [
//                                                         TextSpan(
//                                                           text: '  VIDEOS'.toUpperCase(),
//                                                           style: TextStyle(
//                                                               fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
//                                                               fontSize: 20.sp,
//                                                               color: const Color(0xff00e5fa)
//                                                           ),
//                                                         )
//                                                       ]
//                                                   ),
//                                                 ),
//                                                 NotificationListener<ScrollNotification>(
//                                                   onNotification: (scrollInfo) {
//                                                     if (!state.hasReachedMax &&
//                                                         scrollInfo.metrics.pixels ==
//                                                             scrollInfo.metrics
//                                                                 .maxScrollExtent) {
//                                                       // print('end list');
//                                                       context.read<VideoByTagCubit>().loadPost();
//                                                     }
//                                                     return true;
//                                                   },
//                                                   child: ListView.builder(
//                                                       shrinkWrap: true,
//                                                       physics: const NeverScrollableScrollPhysics(),
//                                                       itemCount: state.list.length+(state.hasReachedMax?0:1),
//                                                       itemBuilder: (context,index){
//                                                         if(index<state.list.length) {
//                                                           return Column(
//                                                             children: [
//                                                               SizedBox(height: 20.h,),
//                                                               InkWell(
//                                                                   onTap: ()=>
//                                                                       Navigator.pushReplacement(context,MaterialPageRoute(builder: (builder)=>VideoDetail(postModal: state.list[index]))),
//                                                                   child: ExpandedNewsBlock(postModal: state.list[index],))
//                                                             ],
//                                                           );
//                                                         }
//                                                         else if(index<48){
//                                                           // print('myIndex: $index');
//                                                           context.read<VideoByTagCubit>().loadPost();
//                                                           return const Center(
//                                                             child: CircularProgressIndicator(
//                                                               color: Colors.black,),
//                                                           );
//                                                         }
//                                                         return null;
//                                                       }),
//                                                 ),
//
//                                               ],
//                                             );
//                                           }
//                                           return Container();
//                                         })
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         }
//                       })
//                 ],
//               ),
//             ),
//           );
//         },
//
//       ),
//     );
//   }
//
//   Widget _showDialog(BuildContext context,Map<String,dynamic> map){
//
//     return Expanded(
//       child: SizedBox(
//         width: double.infinity,
//         height: MediaQuery.of(context).size.height * 0.75,
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Description',
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontFamily: GoogleFonts.poppins().fontFamily,
//                         fontSize: 20.sp,
//                         fontWeight: FontWeight.bold
//                     ),
//                   ),
//                   InkWell(
//                       onTap: (){
//                         context.read<DesCommCubit>().hideDescription();
//                       },
//                       child: Icon(Icons.close_sharp,color: Colors.black,size: 30.r,))
//                 ],
//               ),
//               SizedBox(height: 5.h,),
//               const Divider(color: Colors.black26,),
//               SizedBox(height: 5.h,),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(postModal.title??'',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
//                           fontSize: 18.sp,
//                         ),
//                       ),
//                       SizedBox(height: 3.h,),
//                       Row(
//                         // mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text('Posted: ${DateFormat('dd MMMM yyyy').format(DateTime.parse(postModal.date??''))}',
//                             style: TextStyle(
//                                 color: Colors.black45,
//                                 fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
//                                 fontSize: 13.sp
//                             ),
//                           ),
//                           SizedBox(width: 10.w,),
//                           InkWell(
//                               onTap: ()=>Navigator.pop(context),
//                               child: Icon(Icons.remove_red_eye,color: const Color(0xffee3483),size: 15.r,)
//                           ),
//                           SizedBox(width: 2.w,),
//                           Text(ConvertUtils.formatCommaNumber(int.parse(postModal.views??'0')),
//                             style: TextStyle(
//                                 color: Colors.black45,
//                                 fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
//                                 fontSize: 13.sp
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 15.h,),
//
//                       SafeArea(
//                         child: Text(map['text'],
//                           style: TextStyle(
//                             color: Colors.black87,
//                             fontFamily: GoogleFonts.poppins().fontFamily,
//                             fontSize: 15.sp,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   String _socialImg(String link){
//     if(link.contains('instagram')){
//       return 'assets/images/instagram.png';
//     }
//     else if(link.contains('facebook')){
//       return 'assets/images/facebook.png';
//     }
//     else if(link.contains('tiktok')){
//       return 'assets/images/tiktok.png';
//     }
//     else if(link.contains('x')){
//       return 'assets/images/twitter.png';
//     }
//     else if(link.contains('youtube')){
//       return 'assets/images/youtube.png';
//     }
//     else if(link.contains('threads')){
//       return 'assets/images/threads.png';
//     }
//     return '';
//   }
//
//   void _launchUrl(BuildContext context, String url) {
//     // if (await canLaunchUrl(Uri.parse(url))) {
//     // await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
//     // } else {
//     // throw 'Could not launch $url';
//     // }
//     Navigator.push(context, MaterialPageRoute(builder: (builder)=>ShowWebView(link: url)));
//   }
//
//   Widget _showComments(BuildContext context){
//     return Expanded(
//         child: SizedBox(
//           width: double.infinity,
//           height: MediaQuery.of(context).size.height * 0.75,
//           child: BlocListener<CommentCubit,FetchCommentState>(
//             listener: (context,state){
//               // print(state);
//             },
//             child: BlocBuilder<CommentCubit,FetchCommentState>(
//               builder: (BuildContext context, FetchCommentState state) {
//                 if(state is CommentLoading){
//                   return const Center(child: CircularProgressIndicator(color: Colors.black,));
//                 }
//                 else if(state is CommentLoaded){
//                   // List<CommentModal> list=state as
//                   // print('$state ${state.list.length}');
//                   return Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text('Comments',
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontFamily: GoogleFonts.poppins().fontFamily,
//                                   fontSize: 20.sp,
//                                   fontWeight: FontWeight.bold
//                               ),
//                             ),
//                             InkWell(
//                                 onTap: (){
//                                   context.read<DesCommCubit>().hideComment();
//                                 },
//                                 child: Icon(Icons.close_sharp,color: Colors.black,size: 30.r,))
//                           ],
//                         ),
//                         SizedBox(height: 5.h,),
//                         const Divider(color: Colors.black26,),
//                         SizedBox(height: 5.h,),
//                         if(state.list.isNotEmpty)
//                           Expanded(
//                             child: NotificationListener<ScrollNotification>(
//                               onNotification: (scrollInfo) {
//                                 if (!state.hasReachedMax &&
//                                     scrollInfo.metrics.pixels ==
//                                         scrollInfo.metrics.maxScrollExtent) {
//                                   context.read<CommentCubit>().fetchComments();
//                                 }
//                                 return true;
//                               },
//                               child: ListView.separated(
//                                   itemCount: state.list.length+(state.hasReachedMax?0:1),
//                                   itemBuilder: (context,index){
//                                     if(index<state.list.length){
//                                       CommentModal commentModal= state.list[index];
//                                       return Padding(
//                                         padding: EdgeInsets.symmetric(horizontal: 10.w),
//                                         child: CommentWidget(commentModal: commentModal,isReplyScreen: false,),
//                                       );
//                                     }
//                                     else{
//                                       return Column(
//                                         children: [
//                                           SizedBox(height: 5.h,),
//                                           const CircularProgressIndicator(
//                                             color: Colors.black,),
//                                           SizedBox(height: 5.h,),
//                                         ],
//                                       );
//                                     }
//                                   },
//                                   separatorBuilder: (BuildContext context, int index){
//                                     return SizedBox(height: 20.h,);
//                                   }
//                               ),
//                             ),
//                           )
//                         else
//                           Expanded(
//                             child: Column(
//                               children: [
//                                 SizedBox(height: 20.h,),
//                                 Center(
//                                   child: Text('No comments yet',
//                                     style: GoogleFonts.poppins(
//                                         color: Colors.black,
//                                         fontSize: 15.sp
//                                     ),),
//                                 ),
//                                 Text('Say something to start the conversation',
//                                   style: GoogleFonts.poppins(
//                                       color: Colors.black54,
//                                       fontSize: 15.sp
//                                   ),),
//
//                               ],
//                             ),
//                           ),
//                         const Divider(color: Colors.black26,),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Container(
//                                 padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.h),
//                                 decoration: BoxDecoration(
//                                   color: Colors.black12,
//                                   borderRadius: BorderRadius.circular(10.r),
//                                 ),
//                                 child: TextFormField(
//                                   controller: _commentController,
//                                   decoration: InputDecoration(
//                                       border: InputBorder.none,
//                                       hintText: 'Add a comment',
//                                       contentPadding: EdgeInsets.symmetric(horizontal: 10.w)
//                                   ),
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontFamily: GoogleFonts.poppins().fontFamily,
//                                       fontSize: 12.sp,
//                                       fontWeight: FontWeight.bold
//
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 10.w,),
//                             if(state is CommentInsertLoading)
//                               const CircularProgressIndicator(color: Colors.black,)
//                             else
//                               InkWell(
//                                   onTap: (){
//                                     FocusManager.instance.primaryFocus?.unfocus();
//                                     context.read<CommentCubit>().insertComments(_commentController.text);
//                                     _commentController.text='';
//                                   },
//                                   child: Icon(Icons.send,color: Colors.blue,size: 25.sp,)
//                               ),
//                           ],
//                         )
//                       ],
//                     ),
//                   );
//                 }
//                 else if(state is NotLoggedIn){
//                   WidgetsBinding.instance.addPostFrameCallback((_) {
//                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>Login()));
//                   });
//                 }
//                 return Container();
//               },
//             ),
//           ),
//         )
//     );
//   }
//
//   Widget _showReplies(CommentModal commentModal,BuildContext context){
//     context.read<ReplyCubit>().fetchReply(commentModal);
//     return Expanded(
//         child: SizedBox(
//           width: double.infinity,
//           height: MediaQuery.of(context).size.height * 0.75,
//           child: BlocBuilder<ReplyCubit,FetchReplyState>(
//             builder: (context, state) {
//               if(state is ReplyLoading){
//                 return const Center(child: CircularProgressIndicator(color: Colors.black,));
//               }
//               else if(state is ReplyLoaded){
//                 // List<CommentModal> list=state as
//                 return Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           InkWell(
//                               onTap: (){
//                                 context.read<DesCommCubit>().showComment();
//                               },
//                               child: Icon(Icons.arrow_back_ios,color: Colors.black,size: 30.r,)),
//                           SizedBox(width: 5.w,),
//
//                           Text('Replies',
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontFamily: GoogleFonts.poppins().fontFamily,
//                                 fontSize: 20.sp,
//                                 fontWeight: FontWeight.bold
//                             ),
//                           ),
//                           const Spacer(),
//                           InkWell(
//                               onTap: (){
//                                 context.read<DesCommCubit>().hideReply();
//                               },
//                               child: Icon(Icons.close_sharp,color: Colors.black,size: 30.r,))
//                         ],
//                       ),
//                       SizedBox(height: 5.h,),
//                       const Divider(color: Colors.black26,),
//                       SizedBox(height: 5.h,),
//                       CommentWidget(commentModal: state.commentModal,isReplyScreen: true,),
//
//                       const Divider(color: Colors.black26,),
//                       SizedBox(height: 5.h,),
//
//                       if(state.list.isNotEmpty)
//                         Expanded(
//                           child: NotificationListener<ScrollNotification>(
//                             onNotification: (scrollInfo) {
//                               if (!state.hasReachedMax &&
//                                   scrollInfo.metrics.pixels ==
//                                       scrollInfo.metrics.maxScrollExtent) {
//                                 context.read<ReplyCubit>().loadMoreReply(commentModal);
//                               }
//                               return true;
//                             },
//                             child: Padding(
//                               padding: EdgeInsets.only(left: 25.w),
//                               child: ListView.separated(
//                                   itemCount: state.list.length+(state.hasReachedMax?0:1),
//                                   itemBuilder: (context,index){
//                                     if(index<state.list.length){
//                                       ReplyModal replyModal= state.list[index];
//                                       return Padding(
//                                         padding: EdgeInsets.symmetric(horizontal: 10.w),
//                                         child: ReplyWidget(replyModal: replyModal,),
//                                       );
//                                     }
//                                     else{
//                                       return Column(
//                                         children: [
//                                           SizedBox(height: 5.h,),
//                                           const CircularProgressIndicator(
//                                             color: Colors.black,),
//                                           SizedBox(height: 5.h,),
//                                         ],
//                                       );
//                                     }
//                                   },
//                                   separatorBuilder: (BuildContext context, int index){
//                                     return SizedBox(height: 20.h,);
//                                   }
//                               ),
//                             ),
//                           ),
//                         )
//                       else
//                         Expanded(
//                           child: Column(
//                             children: [
//                               SizedBox(height: 20.h,),
//                               Center(
//                                 child: Text('No Reply yet',
//                                   style: GoogleFonts.poppins(
//                                       color: Colors.black,
//                                       fontSize: 15.sp
//                                   ),),
//                               ),
//                               Text('Say something to start the conversation',
//                                 style: GoogleFonts.poppins(
//                                     color: Colors.black54,
//                                     fontSize: 15.sp
//                                 ),),
//
//                             ],
//                           ),
//                         ),
//                       const Divider(color: Colors.black26,),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Container(
//                               padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.h),
//                               decoration: BoxDecoration(
//                                 color: Colors.black12,
//                                 borderRadius: BorderRadius.circular(10.r),
//                               ),
//                               child: TextFormField(
//                                 controller: _replyController,
//                                 decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     hintText: 'Add a reply',
//                                     contentPadding: EdgeInsets.symmetric(horizontal: 10.w)
//                                 ),
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontFamily: GoogleFonts.poppins().fontFamily,
//                                     fontSize: 12.sp,
//                                     fontWeight: FontWeight.bold
//
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 10.w,),
//                           InkWell(
//                               onTap: (){
//                                 context.read<ReplyCubit>().insertReply(commentModal, _replyController.text);
//                                 _replyController.text='';
//                               },
//                               child: state is ReplyInsertLoading? const CircularProgressIndicator(color: Colors.black,):
//                               Icon(Icons.send,color: Colors.blue,size: 25.sp,)
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                 );
//               }
//               else if(state is UserNotLoggedIn){
//                 WidgetsBinding.instance.addPostFrameCallback((_) {
//                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>Login()));
//                 });
//               }
//               return Container();
//             },
//           ),
//         )
//     );
//   }
//
//
//   Future<void> _share(BuildContext context) async {
//     List<String> arr=(postModal.title??'').split(' ');
//     String title='';
//     for(int i=0; i<arr.length && i<3; i++){
//       String text=arr[i].toUpperCase();
//       text= i<2? '${text}_': text;
//       title='$title$text';
//     }
//
//     final size=MediaQuery.of(context).size;
//     final result = await Share.share('https://hiphopboombox.com/news/${postModal.id}/$title',
//       sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2),
//     );
//
//     if (result.status == ShareResultStatus.success) {
//       // print('Thank you for sharing my website!');
//     }
//   }
//
//   Widget _nextVideosShimmer(){
//     return Column(
//       children: [
//         SizedBox(height: 20.h,),
//         ...List.generate(2, (index){
//           return Padding(
//             padding: EdgeInsets.only(bottom: 20.h),
//             child: Shimmer(
//                 gradient: shimmerGradient,
//                 child: Container(
//                   height: 260.h,
//                   decoration: BoxDecoration(
//                       color: Colors.black,
//                       borderRadius: BorderRadius.circular(10.r)
//                   ),
//                 )
//             ),
//           );
//         })
//       ],
//     );
//   }
//
//   void _showReportDialog(BuildContext context){
//     final List<String> options = [
//       'Sexual content',
//       'Violent or repulsive content',
//       'Hateful or abusive content',
//       'Harassment or bullying',
//       'Harmful or dangerous acts',
//       'Misinformation',
//       'Child abuse',
//       'Legal issue',
//       'Promotes terrorism',
//       'Spam or misleading',
//     ];
//     showDialog(
//         context: context,
//         builder: (context) {
//           return BlocProvider(
//             create: (BuildContext context)=>ReportCubit(),
//             child: BlocBuilder<ReportCubit,String>(
//               builder: (BuildContext context, String selectedValue) {
//                 return Dialog(
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
//                   elevation: 16,
//                   child: ListView(
//                     shrinkWrap: true,
//                     children: <Widget>[
//                       SizedBox(height: 20.h),
//                       Center(child: Text('Report video',
//                         style: TextStyle(color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20.sp
//                         ),
//                       )),
//                       SizedBox(height: 20.h),
//                       for (String option in options)
//                         RadioListTile<String>(
//                           title: Text(option,
//                             style: TextStyle(
//                                 fontSize: 18.sp
//                             ),),
//                           value: option,
//                           groupValue: selectedValue,
//                           onChanged: (String? value) {
//                             context.read<ReportCubit>().itemSelected(value);
//                           },
//                         ),
//
//                       SizedBox(height: 20.h,),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           InkWell(
//                             onTap: ()=>Navigator.pop(context),
//                             child: Text('Cancel',
//                               style: TextStyle(
//                                   color: Colors.blue,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 15.sp
//                               ),),
//                           ),
//                           SizedBox(width: 20.w,),
//
//                           InkWell(
//                             onTap: (){
//                               WidgetsBinding.instance.addPostFrameCallback((_) =>
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Text(
//                                         'Thanks for reporting the content',
//                                         style: GoogleFonts.poppins(color: Colors.white),
//                                       ),
//                                       backgroundColor: Colors.blue,
//                                     ),
//                                   ));
//                               Navigator.pop(context);
//                             },
//                             child: Text('Report',
//                               style: TextStyle(
//                                   color: selectedValue.isNotEmpty? Colors.blue : Colors.grey,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 15.sp
//                               ),),
//                           ),
//                           SizedBox(width: 20.w,),
//                         ],
//                       ),
//                       SizedBox(height: 15.h,),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           );
//         }
//     );
//   }
//
//   void _showBlockDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return BlocProvider(
//           create: (create)=>BlockedUserCubit(),
//           child: BlocListener<BlockedUserCubit,bool>(
//             listener: (BuildContext context, isAdminBlocked) {
//               if(isAdminBlocked){
//                 Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>MyHomePage()),(Route<dynamic> route) => false);
//               }
//             },
//             child: BlocBuilder<BlockedUserCubit,bool>(
//               builder: (BuildContext context, bool isAdminBlocked) {
//                 return AlertDialog(
//                   title: Text("Block user",style: GoogleFonts.poppins(color: Colors.black),),
//                   content: Text("Blocking this user will prevent all their content from appearing. You can unblock them in the account settings.",style: GoogleFonts.poppins(color: Colors.black)),
//                   actions: [
//                     TextButton(
//                       onPressed: () {
//                         Navigator.of(context).pop(); // Close the dialog
//                       },
//                       child: const Text("Cancel"),
//                     ),
//                     SizedBox(width: 10.w),
//                     TextButton(
//                       onPressed: () async {
//                         // Handle any action for the confirm button
//                         Navigator.of(context).pop(); // Close the dialog
//                         context.read<BlockedUserCubit>().blockAdmin();
//                       },
//                       child: const Text("Continue"),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
//   void _setPortraitOrientation() {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//     ]);
//   }
//
//   void _setLandScapeOrientation() {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//   }
// }
