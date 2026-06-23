import 'package:boombox/widget/news.dart';
import 'package:boombox/backend/data_bloc.dart';
import 'package:boombox/backend/data_event.dart';
import 'package:boombox/modal/postmodal.dart';
import 'package:boombox/screens/see_all.dart';
import 'package:boombox/screens/video_screen/video_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/theme_cubit.dart';
import '../../utils/utils.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=>CategoryPostCubit()),
        BlocProvider(create: (context)=>DataFetchBloc()),
        BlocProvider(create: (context)=> DataFetchBloc2()),
        BlocProvider(create: (context)=> DataFetchBloc3()),
        BlocProvider(create: (context)=> DataFetchBloc4()),
      ],
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: (){
            return context.read<FeaturedDataFetchCubit>().fetchFeaturedPosts();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                BlocListener<FeaturedDataFetchCubit,DataState>(
                  listener: (context,state){
                    if(state is DataLoaded){
                      context.read<CategoriesFetchCubit>().loadCategories();
                    }
                  },
                  child: BlocBuilder<FeaturedDataFetchCubit,DataState>(
                    builder: (context,state){
                      if(state is DataLoading){
                        return _sliderShimmer(context);
                      }
                    else if(state is DataLoaded){
                      // print(state.list.length);
                      return CarouselSlider.builder(
                          itemCount: state.list.length,
                          itemBuilder: (itemBuilder,index,i){
                            return SizedBox(
                                width: double.infinity,
                                // color: Colors.black,
                                // height: 350,
                                child: InkWell(
                                    onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (builder)=>
                                        VideoDetail(postModal: state.list[index],))),
                                    child: Stack(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: double.infinity,
                                          width: double.infinity,
                                          child: CachedNetworkImage(
                                            memCacheWidth: 1000,
                                            placeholder: (context, url) => Shimmer(
                                                gradient: Theme.of(context).brightness==Brightness.light?lightGradient: darkGradient,
                                                child: Container(
                                                  color: Colors.white,
                                                )),
                                            imageUrl:  state.list[index].portraitImage??'',
                                            fit: BoxFit.fill,
                                            errorWidget: (context, url,x) => Shimmer(
                                                gradient: Theme.of(context).brightness==Brightness.light?lightGradient: darkGradient,
                                                child: Container(
                                                  color: Colors.white,
                                                ))
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.9),
                                                      spreadRadius: 10,
                                                      blurRadius: 10,
                                                      offset: const Offset(0, 4), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                padding: EdgeInsets.only(bottom: 5.h),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                                                      child: RichText(
                                                        textAlign: TextAlign.center,
                                                        text: TextSpan(
                                                            text: '${state.list[index].title}'.toUpperCase(),
                                                            style: TextStyle(
                                                              fontFamily: GoogleFonts.poppins().fontFamily,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 20.sp,
                                                            ),
                                                        ),
                                                      ),
                                                    ),

                                                    SizedBox(height: 3.h,),
                                                    Container(
                                                      width: double.infinity,
                                                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                                                      child: ElevatedButton.icon(
                                                          onPressed: null,
                                                          style: ButtonStyle(
                                                              backgroundColor: WidgetStateProperty.all(Colors.white),
                                                              elevation: WidgetStateProperty.all(20),
                                                              padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 4.h))

                                                          ),
                                                          icon: Icon(Icons.play_arrow,color: Colors.black,size: 20.sp,),
                                                          label: Text('Play',style: TextStyle(color: Colors.black,fontSize: 22.sp),)
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                )
                            );
                          },
                          options: CarouselOptions(
                              initialPage: 2,
                              autoPlay: true,
                              viewportFraction: 1,
                              aspectRatio: 1
                          )
                      );
                    }
                    else{
                      return Container();
                    }
                    },
                  ),
                ),

                SizedBox(height: 20.h,),

                BlocListener<CategoriesFetchCubit,DataState>(
                  listener: (context,state){
                    context.read<DataFetchBloc>().add(FetchData());
                  },
                  child: BlocBuilder<CategoriesFetchCubit,DataState>(
                      builder: (context,state){
                        if(state is CategoriesLoaded){
                          return BlocBuilder<CategoryPostCubit,CategoryPostState>(
                            builder: (context,state2){
                              int selectedIndex=-1;
                              if(state2 is CategoryPostLoading){
                                selectedIndex=state2.index;
                              }
                              else if(state2 is CategoryPostLoaded){
                                selectedIndex=state2.index;
                              }
                              return BlocBuilder<ThemeCubit,ThemeMode>(
                                builder: (BuildContext context, ThemeMode themeMode) {
                                  return SizedBox(
                                    height: 45.h,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context,index){
                                          return InkWell(
                                            onTap: (){
                                              context.read<CategoryPostCubit>().toggleCategory(state.list[index], index);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(vertical:5.h,horizontal: 10.w),
                                              margin: EdgeInsets.only(left: index==0? 15.w:0, right: 15.w),
                                              decoration: BoxDecoration(
                                                  color: _categoryBg(themeMode, selectedIndex, index),
                                                  borderRadius: BorderRadius.circular(20.r)
                                              ),
                                              child: Center(
                                                child: Text(state.list[index].name,
                                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                        color:_categoryTitleColor(themeMode, selectedIndex, index),
                                                        fontSize: 13.sp
                                                    )
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        itemCount: state.list.length
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }
                        return _shimmerCategories(context);
                  }),
                ),

                SizedBox(height: 20.h,),

                BlocBuilder<CategoryPostCubit,CategoryPostState>(
                  builder: (context,state){
                    if(state is CategoryPostInitial) {
                      return Column(
                        children: [

                          BlocListener<DataFetchBloc, DataState>(
                            listener: (context, state) {
                              if (state is DataLoaded) {
                                context.read<DataFetchBloc2>().add(
                                    FetchData2(getDate('yyyy-MM-dd', 0)));
                              }
                            },
                            child: BlocBuilder<DataFetchBloc, DataState>(
                              builder: (BuildContext context, state) {
                                if (state is DataLoading) {
                                  return _newsShimmer(context);
                                }
                                else if (state is DataLoaded) {
                                  return _videosWidget(text1: 'Trending', text2: 'Now', context: context, list: state.list);
                                }
                                else {
                                  return Container();
                                }
                              },
                            ),
                          ),

                          SizedBox(height: 25.h,),
                          BlocListener<DataFetchBloc2, DataState>(
                              listener: (context, state) {
                                if (state is DataLoaded) {
                                  context.read<DataFetchBloc3>().add(
                                      FetchData2(getDate('yyyy-MM-dd', 1)));
                                }
                              },
                              child: BlocBuilder<DataFetchBloc2, DataState>(
                                builder: (context, state) {
                                  if (state is DataInitial || state is DataLoading) {
                                    return _newsShimmer(context);
                                  }
                                  else if (state is DataLoaded) {
                                    if (state.list.isNotEmpty) {
                                      return _videosWidget(text1: "TODAY'S", text2: 'VIDEOS', context: context, list: state.list);
                                    }
                                    else {
                                      return Container();
                                    }
                                  }
                                  else {
                                    return Container();
                                  }
                                },
                              )
                          ),
                          SizedBox(height: 25.h,),

                          BlocListener<DataFetchBloc3, DataState>(
                            listener: (context, state) {
                              if (state is DataLoaded) {
                                context.read<DataFetchBloc4>().add(
                                    FetchData2(getDate('yyyy-MM-dd', 2)));
                              }
                            },
                            child: BlocBuilder<DataFetchBloc3, DataState>(
                                builder: (context, state) {
                                  if (state is DataLoading) {
                                    return _newsShimmer(context);
                                  }
                                  else if (state is DataLoaded) {
                                    if (state.list.isNotEmpty) {
                                      return _videosWidget(text1: getDate('d MMMM /yyyy', 1)
                                          .split('/')[0].toUpperCase(), text2: getDate('d MMMM /yyyy', 1)
                                          .split('/')[1].toUpperCase(), context: context, list: state.list);
                                    }
                                    else {
                                      return Container();
                                    }
                                  }
                                  else {
                                    return Container();
                                  }
                                }
                            ),
                          ),
                          SizedBox(height: 25.h,),

                          BlocBuilder<DataFetchBloc4, DataState>(
                              builder: (context, state) {
                                if (state is DataLoading) {
                                  return _newsShimmer(context);
                                }
                                else if (state is DataLoaded) {
                                  if (state.list.isNotEmpty) {
                                    return _videosWidget(text1: getDate('d MMMM /yyyy', 2).split('/')[0].toUpperCase(),
                                        text2: getDate('d MMMM /yyyy', 1).split('/')[1].toUpperCase(),
                                        context: context, list: state.list
                                    );
                                  }
                                  else {
                                    return Container();
                                  }
                                }
                                else {
                                  return Container();
                                }
                              }
                          ),

                        ],
                      );
                    }
                    else{
                      if(state is CategoryPostLoaded){
                        return Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: _videosWidget(context: context, list: state.list),
                        );
                      }
                      return _newsShimmer(context);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _videosWidget({String? text1, String? text2,
    required BuildContext context, required List<PostModal> list}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment
          .start,
      children: [
        if(text1!=null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween,
              children: [
                _richText(text1: text1, text2: text2??''),
                InkWell(
                  onTap: () =>
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (builder) =>
                                  SeeAll(
                                    text1: text1.toUpperCase()??'',
                                    text2: text2?.toUpperCase()??'',
                                    list: list,))),
                  child: _seeAll(),
                )
              ],
            ),
          ),
        if(text1!=null)
          SizedBox(height: 10.h,),

        SizedBox(
          height: 230.h,
          child: ListView.builder(
              itemCount: list.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) =>
                                VideoDetail(
                                  postModal: list[index],))),
                    child: Padding(
                      padding: EdgeInsets.only(left: index==0? 15.w:0, right: 15.w),
                      child: NewsWidget(
                          postModal: list[index]),
                    ));
              }
          ),
        ),
      ],
    );
  }

  Widget _richText({required String text1, required String text2}){
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: text1
              .toUpperCase(),
          style: TextStyle(
              fontFamily: GoogleFonts
                  .poppins(
                  fontWeight: FontWeight
                      .bold)
                  .fontFamily,
              fontSize: 20.sp,
              color: const Color(
                  0xffee3483)
          ),
          children: [
            TextSpan(
              text: '  $text2'
                  .toUpperCase(),
              style: TextStyle(
                  fontFamily: GoogleFonts
                      .poppins(
                      fontWeight: FontWeight
                          .bold)
                      .fontFamily,
                  fontSize: 20.sp,
                  color: const Color(
                      0xff00e5fa)
              ),
            )
          ]
      ),
    );
  }

  Widget _seeAll(){
    return Text(
        'See All'.toUpperCase(),
        style: TextStyle(
            fontFamily: GoogleFonts
                .poppins()
                .fontFamily,
            fontWeight: FontWeight
                .bold,
            fontSize: 15.sp,
            color: Colors.grey
        ));
  }

  String getDate(String format,int sub){
    DateTime dateTime = DateTime.now();
    dateTime= dateTime.subtract(Duration(days: sub));
    return DateFormat(format).format(dateTime);
  }

  Color _categoryBg(ThemeMode themeMode,int selectedIndex, int currentIndex){
    if(themeMode==ThemeMode.light){
      return selectedIndex==currentIndex?
      Colors.black : Colors.grey.shade100;
    }
    else{
      return selectedIndex==currentIndex?
      Colors.white : Colors.white12;
    }
  }

  Color _categoryTitleColor(ThemeMode themeMode,int selectedIndex, int currentIndex){
    if(themeMode==ThemeMode.light){
      return selectedIndex==currentIndex?
      Colors.white : Colors.black;
    }
    else{
      return selectedIndex==currentIndex?
      Colors.black : Colors.white;
    }
  }

  Widget _sliderShimmer(BuildContext context) {
    return Shimmer(
        gradient: Theme.of(context).brightness==Brightness.light?lightGradient: darkGradient,
        child: Container(
          height: 350.h,
          decoration: BoxDecoration(
              color: Theme.of(context).brightness==Brightness.light?Colors.black:Colors.white,
    ),
        ));
  }

  Widget _shimmerCategories(BuildContext context) {
    return Shimmer(
        gradient: Theme.of(context).brightness==Brightness.light?lightGradient: darkGradient,
        child: Container(
          height: 35.h,
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context,index){
                return Container(
                  width: 100.w,

                  padding: EdgeInsets.symmetric(vertical:5.h,horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness==Brightness.light?Colors.black:Colors.white,
                      borderRadius: BorderRadius.circular(20.r)
                  ),
                );
              },
              separatorBuilder: (context,index){
                return SizedBox(width: 15.w,);
              },
              itemCount: 5
          ),
        )
    );
  }

  Widget _newsShimmer(BuildContext context) {
    return Shimmer(
        gradient: Theme.of(context).brightness==Brightness.light?lightGradient: darkGradient,
        child:  SizedBox(
          height: 230.h,
          child: ListView.separated(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  width: 150.w,
                  color: Theme.of(context).brightness==Brightness.light?Colors.black:Colors.white,
                );
              },
            separatorBuilder: (context,index){
              return SizedBox(width: 15.w,);
            },
          ),
        ),
    );
  }

}
