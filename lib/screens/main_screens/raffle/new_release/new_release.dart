import 'package:boombox/modal/shoe_modal.dart';
import 'package:boombox/screens/main_screens/raffle/new_release/new_release_cubit.dart';
import 'package:boombox/screens/main_screens/raffle/new_release/new_release_state.dart';
import 'package:boombox/screens/main_screens/raffle/product_details/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

import '../../../../modal/sneaker_brand.dart';

class NewRelease extends StatelessWidget {
  NewRelease({super.key});

  final PageController _pageController= PageController();

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (create)=>NewReleaseCubit()
          ..getSneakerRaffle()
        ),
        BlocProvider(create: (create)=>SneakerBrandCubit()
          ..loadBrands()
        ),
        BlocProvider(create: (create)=>SneakerDateCubit()),
        BlocProvider(create: (create)=>NewReleasePageView(_pageController)),
      ],
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 120.h,
          centerTitle: true,
          title: Column(
            children: [
              Text('Releases',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20.sp),
              ),

              SizedBox(height: 20.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocListener<SneakerDateCubit,DateTime?>(
                    listener: (BuildContext context, DateTime? date) {
                      if(date!=null){
                        context.read<NewReleaseCubit>().month= date.month.toString();
                        context.read<NewReleaseCubit>().year= date.year.toString();
                        context.read<NewReleaseCubit>().getSneakerRaffle();
                      }
                    },
                    child: BlocBuilder<SneakerDateCubit,DateTime?>(
                      builder: (BuildContext context, DateTime? date) {
                        return InkWell(
                          onTap: (){
                            _selectDate(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).textTheme.titleSmall?.color??Colors.green,
                                ),
                                borderRadius: BorderRadius.circular(10.r)
                            ),
                            child: Text(date!=null? DateFormat('MMM yyyy').format(date) : 'Select Date',
                              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 15.sp),
                            ),
                          ),
                        );
                      },

                    ),
                  ),
                  BlocBuilder<SneakerBrandCubit,SneakerBrandState>(
                    builder: (BuildContext context, SneakerBrandState state) {
                      return PopupMenuButton(
                        itemBuilder: (BuildContext context) {
                          if(state is SneakerBrandsLoaded<List<SneakerBrand>>){
                            List<SneakerBrand> list=state.data;
                            return List<PopupMenuEntry>.generate(list.length,(index) {
                              return PopupMenuItem(
                                value: index,
                                child: Text(list[index].brand),
                                onTap: (){
                                  context.read<SneakerBrandCubit>().changeBrand(list[index].brand);
                                  context.read<NewReleaseCubit>().brandId= list[index].id;
                                  context.read<NewReleaseCubit>().getSneakerRaffle();
                                },
                              );
                            });
                          }
                          return <PopupMenuEntry>[
                            const PopupMenuItem(
                              child: Center(child: CircularProgressIndicator(),),
                            )
                          ];
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.r),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).textTheme.titleSmall?.color??Colors.green,
                              ),
                              borderRadius: BorderRadius.circular(10.r)
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                state is SneakerBrandsLoaded<List<SneakerBrand>>?
                                state.brandSelected??'Select Brand':'Select Brand',
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                  fontSize: 15.sp,
                                ),
                              ),
                              Icon(Icons.arrow_drop_down,size: 20.sp,),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                  // InkWell(
                  //   onTap: (){
                  //     _selectBrands(context);
                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.all(10.r),
                  //     decoration: BoxDecoration(
                  //         border: Border.all(
                  //           color: Theme.of(context).textTheme.titleSmall?.color??Colors.green,
                  //         ),
                  //         borderRadius: BorderRadius.circular(10.r)
                  //     ),
                  //     child: Text('Select Brand',
                  //       style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 15.sp),
                  //     ),
                  //   ),
                  // ),
                ],
              )


            ],
          ),
        ),
        body: Column(
          children: [
            BlocBuilder<NewReleasePageView,int>(
              builder: (BuildContext context, int currentPageIndex) {
                return Expanded(
                  child: Column(
                    children: [
                      Container(
                        color: Theme.of(context).appBarTheme.backgroundColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Center the Row in AppBar
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: (){
                                  context.read<NewReleasePageView>().changePage(0);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 20.h),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: const Color(0xff00e5fa),
                                              width: currentPageIndex == 0 ? 2 :0
                                          )
                                      )
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Upcoming', // 'Video'
                                      style: TextStyle(
                                        fontSize: 18.sp, // Using ScreenUtil for scaling
                                        fontWeight: currentPageIndex == 0 ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: (){
                                  context.read<NewReleasePageView>().changePage(1);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 20.h),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: const Color(0xff00e5fa),
                                              width: currentPageIndex == 1 ? 2 :0
                                          )
                                      )
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Popular', // 'Video'
                                      style: TextStyle(
                                        fontSize: 18.sp, // Using ScreenUtil for scaling
                                        fontWeight: currentPageIndex == 1 ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: (){
                                  context.read<NewReleasePageView>().changePage(2);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 20.h),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: const Color(0xff00e5fa),
                                              width: currentPageIndex == 2 ? 2 :0
                                          )
                                      )
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Past', // 'Video'
                                      style: TextStyle(
                                        fontSize: 18.sp, // Using ScreenUtil for scaling
                                        fontWeight: currentPageIndex == 2 ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      BlocBuilder<NewReleaseCubit,NewReleaseState>(
                        builder: (BuildContext context, NewReleaseState state) {
                          if(state is NewReleaseLoading){
                            return const Expanded(child: Center(child: CircularProgressIndicator(),));
                          }
                          else if(state is NewReleaseLoaded){
                            return Expanded(
                                child: PageView.builder(
                                  controller: _pageController,
                                  onPageChanged: (index){
                                    context.read<NewReleasePageView>().changeIndicatorIndex(index);
                                  },
                                  itemCount: 3,
                                  itemBuilder: (BuildContext context, int pageIndex) {
                                    List<ShoeModal> shoeList=[];
                                    if(pageIndex==0) {
                                      shoeList= state.upcomingList;
                                    }
                                    else if(pageIndex==1){
                                      shoeList= state.popularList;
                                    }
                                    else if(pageIndex==2) {
                                      shoeList= state.pastList;
                                    }
                                    return ListView.builder(
                                        itemCount: shoeList.length,
                                        itemBuilder: (context,index){
                                          return InkWell(
                                            onTap: ()=>
                                            Navigator.push(context,MaterialPageRoute(builder: (builder)=>ProductDetails(shoeModal: shoeList[index]))),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 15.w),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    _formatDate(shoeList[index].date), // 'Video'
                                                    style: TextStyle(
                                                        fontSize: 15.sp, // Using ScreenUtil for scaling
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.blue
                                                    ),
                                                  ),
                                                  SizedBox(height: 10.h,),
                                                  Row(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(10.r),
                                                                border: Border.all(
                                                                    color: Theme.of(context).brightness==Brightness.light ? Colors.black26 : Colors.white24
                                                                )
                                                            ),
                                                            child: Image.network(shoeList[index].image1,
                                                              height: 80.h,width: 130.w,),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(width: 20.w,),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              shoeList[index].title, // 'Video'
                                                              style: TextStyle(
                                                                fontSize: 15.sp, // Using ScreenUtil for scaling
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                            SizedBox(height: 2.h,),
                                                            Text(
                                                              shoeList[index].description, // 'Video'
                                                              style: TextStyle(
                                                                fontSize: 15.sp, // Using ScreenUtil for scaling
                                                              ),
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                            SizedBox(height: 10.h,),

                                                            Row(
                                                              children: [
                                                                RichText(
                                                                    text: TextSpan(
                                                                      text: 'Retail\n',
                                                                      style: Theme.of(context).textTheme.bodyMedium!.
                                                                      copyWith(fontSize: 14.sp),

                                                                      children: [
                                                                        TextSpan(
                                                                            text: '\$${shoeList[index].retailPrice}',
                                                                            style: Theme.of(context).textTheme.titleSmall!.
                                                                            copyWith(fontSize: 16.sp)
                                                                        )
                                                                      ],
                                                                    )
                                                                ),
                                                                SizedBox(width: 10.w,),
                                                                RichText(
                                                                    text: TextSpan(
                                                                      text: 'Resell\n',
                                                                      style: Theme.of(context).textTheme.bodyMedium!.
                                                                      copyWith(fontSize: 14.sp),
                                                                      children: [
                                                                        TextSpan(
                                                                            text: '\$${shoeList[index].resellPrice}',
                                                                            style: Theme.of(context).textTheme.titleSmall!.
                                                                            copyWith(fontSize: 16.sp)
                                                                        )
                                                                      ],
                                                                    )
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(height: 10.h,),
                                                  const Divider()
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                    );
                                  },
                                )
                            );
                          }
                          return Container();
                        },

                      )
                    ],
                  ),
                );
              },
            )

          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate=context.read<SneakerDateCubit>().dateTime;
    final DateTime? picked = await showMonthYearPicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(), // Default to today's date
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
        lastDate: DateTime.now().add(const Duration(days: 365 * 2)) // Maximum date
    );
    if (picked != null && picked != selectedDate) {
      context.read<SneakerDateCubit>().changeDate(picked);
    }
  }

  String _formatDate(String date){
    DateTime dateTime = DateTime.parse(date);
    // Create a DateFormat instance with the desired format
    return DateFormat("MMM dd, yyyy").format(dateTime);
  }

}
