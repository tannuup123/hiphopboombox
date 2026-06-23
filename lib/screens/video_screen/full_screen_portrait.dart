import 'package:boombox/screens/video_screen/video_cubit.dart';
import 'package:boombox/screens/video_screen/video_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class FullScreenPortrait extends StatelessWidget {
  const FullScreenPortrait({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: BlocBuilder<VideoCubit,VideoState>(
            builder: (context,VideoState state){
              if(state is VideoInitialized){
                return PopScope(
                  canPop: false,
                  onPopInvokedWithResult: (_,x){
                    context.read<VideoOrientationCubit>().portrait();
                  },
                  child: InkWell(
                    onTap: (){
                      context.read<VideoCubit>().toggleControls();
                    },
                    child: Container(
                      color: Colors.black,
                      child: Stack(
                        children: [
                          Center(
                            child: AspectRatio(
                              aspectRatio: state.videoPlayerController.value.aspectRatio,
                              child: VideoPlayer(state.videoPlayerController),
                            ),
                          ),
                          ValueListenableBuilder(valueListenable: state.videoPlayerController,
                            builder: (BuildContext context, VideoPlayerValue value, Widget? child) {
                              if(value.isBuffering) {
                                return const Center(child: CircularProgressIndicator(color:  Colors.white,),);
                              }
                              return Container();
                            },
                          ),
                          Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: AnimatedOpacity(
                                  opacity: state.showControls? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: ()=>state.showControls?context.read<VideoCubit>().backwardVideo():
                                        context.read<VideoCubit>().toggleControls(),

                                        child: Container(
                                            padding: EdgeInsets.all(10.r),
                                            decoration: const BoxDecoration(
                                                color: Colors.black26,
                                                shape: BoxShape.circle
                                            ),
                                            child: Icon(
                                              Icons.replay_10,size: 30.sp,color: Colors.white,)
                                        ),
                                      ),
                                      InkWell(
                                        onTap: ()=>state.showControls?context.read<VideoCubit>().toggleVideoPlay():
                                        context.read<VideoCubit>().toggleControls(),
                                        child: Container(
                                          padding: EdgeInsets.all(10.r),
                                          decoration: const BoxDecoration(
                                              color: Colors.black26,
                                              shape: BoxShape.circle
                                          ),
                                          child: Icon(
                                            state.videoPlayerController.value.isPlaying?
                                            Icons.pause:Icons.play_arrow,size: 30.sp,color: Colors.white,),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: ()=>state.showControls?context.read<VideoCubit>().forwardVideo():
                                        context.read<VideoCubit>().toggleControls(),
                                        child: Container(
                                          padding: EdgeInsets.all(10.r),
                                          decoration: const BoxDecoration(
                                              color: Colors.black26,
                                              shape: BoxShape.circle
                                          ),
                                          child: Icon(
                                            Icons.forward_10,size: 30.sp,color: Colors.white,),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          ),

                          Positioned.fill(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: ValueListenableBuilder(
                                  valueListenable: state.videoPlayerController,
                                  builder: (BuildContext context, value, Widget? child) {
                                    final currentPosition = _formatDuration(value.position);
                                    final totalDuration = _formatDuration(value.duration);
                                    return AnimatedOpacity(
                                      opacity: state.showControls? 1.0 : 0.0,
                                      duration: const Duration(milliseconds: 300),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 10.w),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.5),
                                                        spreadRadius: 2,
                                                        blurRadius: 10,
                                                        offset: Offset(0, 4), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: Text('$currentPosition : $totalDuration',
                                                    style: GoogleFonts.poppins(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 16.sp
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: ()=>state.showControls?
                                                  context.read<VideoOrientationCubit>().portrait():
                                                  null,
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black.withOpacity(0.5),
                                                            spreadRadius: 2,
                                                            blurRadius: 10,
                                                            offset: const Offset(0, 4), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: Icon(Icons.fullscreen_exit,color:Colors.white,size: 30.sp,)
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          VideoProgressIndicator(
                                              state.videoPlayerController,
                                              allowScrubbing: true
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                          ),

                          Positioned.fill(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: AnimatedOpacity(
                                  opacity: state.showControls? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: InkWell(
                                    onTap: ()=>state.showControls?
                                    context.read<VideoOrientationCubit>().portrait():
                                    null,
                                    child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 10,
                                            offset: Offset(0, 4), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.arrow_back_ios,size: 30.sp,color: Colors.white,),
                                    ),
                                  ),
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
              else if(state is VideoLoading){
                return Stack(
                  children: [
                    const Center(child: CircularProgressIndicator(color: Colors.white,)),
                    Positioned.fill(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                            onTap: ()=>Navigator.pop(context),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10.w),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 0,
                                    blurRadius: 10,
                                    offset: Offset(0, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.arrow_back_ios,size: 30.sp,color: Colors.white,),
                            ),
                          ),
                        )
                    )
                  ],
                );
              }
              else if(state is VideoError){
                return Stack(
                  children: [
                    Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Playback error",style: TextStyle(color: Colors.white,fontSize: 12.sp),),
                            SizedBox(height: 5.h),
                            InkWell(
                              onTap: (){
                                context.read<VideoCubit>().initializePlayer(state.videoLink);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 10.w),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.r)
                                ),
                                child: Text("Retry",
                                  style: TextStyle(color: Colors.black,fontSize: 10.sp),
                                ),
                              ),
                            )
                          ],
                        )
                    ),
                    Positioned.fill(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                            onTap: ()=>Navigator.pop(context),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10.w),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 0,
                                    blurRadius: 10,
                                    offset: Offset(0, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.arrow_back_ios,size: 30.sp,color: Colors.white,),
                            ),
                          ),
                        )
                    )
                  ],
                );
              }
              return Container();
            }
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}
