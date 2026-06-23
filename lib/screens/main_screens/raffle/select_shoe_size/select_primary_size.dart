import 'package:boombox/backend/api.dart';
import 'package:boombox/main.dart';
import 'package:boombox/modal/user_details.dart';
import 'package:boombox/screens/main_screens/account/account_cubit.dart';
import 'package:boombox/screens/main_screens/raffle/user_raffles/user_raffle_cubit.dart';
import 'package:boombox/screens/main_screens/raffle/user_raffles/user_raffle_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectPrimarySize extends StatefulWidget {
  final BuildContext myContext;
  const SelectPrimarySize({super.key,required this.myContext});

  @override
  State<SelectPrimarySize> createState() => _SelectPrimarySizeState();
}

class _SelectPrimarySizeState extends State<SelectPrimarySize> {

  final PageController _pageController= PageController();
  int _currentPageIndex=0;
  num _selectedSize=-1;
  int _selectedSizeIndex=-1;

  final List<String> _humanTypeList=['Men', 'Women', 'Children'];
  bool _isLoading=false;

  @override
  Widget build(BuildContext context) {
    return _isLoading?
    Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: const Center(child: CircularProgressIndicator(),),
    )
        :
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: 20.h,),
          // Center(
          //   child: Text(
          //     "Select Your Primary Size",
          //     style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20.sp), // Adjust the title style
          //   ),
          // ),
          // Center(
          //   child: Column(
          //     children: [
          //       Container(
          //         height:100.h,
          //         width: 100.w,
          //         decoration: BoxDecoration(
          //             shape: BoxShape.circle,
          //             image: DecorationImage(
          //                 image: Image.network(widget.userDetails.image??'',).image,
          //                 fit: BoxFit.cover
          //             ),
          //             border: Border.all(
          //                 color: Colors.blue,
          //                 width: 2
          //             )
          //         ),
          //       ),
          //       SizedBox(height: 20.h,),
          //       Text('${widget.userDetails.name}',style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 20.sp),),
          //     ],
          //   ),
          // ),
          // SizedBox(height: 20.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Center the Row in AppBar
            children: [
              Expanded(
                child: InkWell(
                  onTap: (){
                    _pageController.jumpToPage(0);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.blue,
                                width: _currentPageIndex == 0 ? 2 :0
                            )
                        )
                    ),
                    child: Center(
                      child: Text(
                        'Men', // 'Video'
                        style: TextStyle(
                          fontSize: 18.sp, // Using ScreenUtil for scaling
                          fontWeight: _currentPageIndex == 0 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: (){
                    _pageController.jumpToPage(1);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.blue,
                                width: _currentPageIndex == 1 ? 2 :0
                            )
                        )
                    ),
                    child: Center(
                      child: Text(
                        'Women', // 'Video'
                        style: TextStyle(
                          fontSize: 18.sp, // Using ScreenUtil for scaling
                          fontWeight: _currentPageIndex == 1 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: (){
                    _pageController.jumpToPage(2);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.blue,
                                width: _currentPageIndex == 2 ? 2 :0
                            )
                        )
                    ),
                    child: Center(
                      child: Text(
                        'Children', // 'Video'
                        style: TextStyle(
                          fontSize: 18.sp, // Using ScreenUtil for scaling
                          fontWeight: _currentPageIndex == 2 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h,),
          Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index){
                  setState(() {
                    _currentPageIndex=index;
                  });
                },
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: ()=>_showBottomDialog(context),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w),
                          margin: EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: Theme.of(context).textTheme.titleSmall!.color!,
                              )
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_selectedSize==-1? 'Select Size' : "$_selectedSize",
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20.sp),),
                              Icon(Icons.arrow_drop_down,size: 25.sp,)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h,),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            _isLoading=true;
                          });
                          await MyApi.getInstance.updateUserSize(gender: _humanTypeList[index], size: '$_selectedSize');
                          // if(context.mounted) {
                          //   widget.myContext.read<AccountCubit>().isLoggedIn();
                          // }
                          setState(() {
                            _isLoading=false;
                          });
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.pop(widget.myContext,'refresh');
                            // Navigator.pushAndRemoveUntil(widget.myContext, MaterialPageRoute(builder: (builder)=>const MyHomePage()),(Route<dynamic> route) => false);
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 50.w),
                          margin: EdgeInsets.symmetric(horizontal: 20.w),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10.r)
                          ),
                          child: Center(
                            child: Text('Confirm Size',style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontSize: 18.sp,
                                color: Colors.white
                            ),),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )
          ),
          // SizedBox(height: 5.h,),
        ],
      ),
    );
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text(
      //     "Select Your Primary Size",
      //     style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20.sp), // Adjust the title style
      //   ),
      // ),
      body: SafeArea(
        child: _isLoading?
            const Center(child: CircularProgressIndicator(),)
            :
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h,),
            Center(
              child: Text(
                "Select Your Primary Size",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20.sp), // Adjust the title style
              ),
            ),
            // Center(
            //   child: Column(
            //     children: [
            //       Container(
            //         height:100.h,
            //         width: 100.w,
            //         decoration: BoxDecoration(
            //             shape: BoxShape.circle,
            //             image: DecorationImage(
            //                 image: Image.network(widget.userDetails.image??'',).image,
            //                 fit: BoxFit.cover
            //             ),
            //             border: Border.all(
            //                 color: Colors.blue,
            //                 width: 2
            //             )
            //         ),
            //       ),
            //       SizedBox(height: 20.h,),
            //       Text('${widget.userDetails.name}',style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 20.sp),),
            //     ],
            //   ),
            // ),
            SizedBox(height: 20.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Center the Row in AppBar
              children: [
                Expanded(
                  child: InkWell(
                    onTap: (){
                      _pageController.jumpToPage(0);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.blue,
                                  width: _currentPageIndex == 0 ? 2 :0
                              )
                          )
                      ),
                      child: Center(
                        child: Text(
                          'Men', // 'Video'
                          style: TextStyle(
                            fontSize: 18.sp, // Using ScreenUtil for scaling
                            fontWeight: _currentPageIndex == 0 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: (){
                      _pageController.jumpToPage(1);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.blue,
                                  width: _currentPageIndex == 1 ? 2 :0
                              )
                          )
                      ),
                      child: Center(
                        child: Text(
                          'Women', // 'Video'
                          style: TextStyle(
                            fontSize: 18.sp, // Using ScreenUtil for scaling
                            fontWeight: _currentPageIndex == 1 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: (){
                      _pageController.jumpToPage(2);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.blue,
                                  width: _currentPageIndex == 2 ? 2 :0
                              )
                          )
                      ),
                      child: Center(
                        child: Text(
                          'Children', // 'Video'
                          style: TextStyle(
                            fontSize: 18.sp, // Using ScreenUtil for scaling
                            fontWeight: _currentPageIndex == 2 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h,),
            Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index){
                    setState(() {
                      _currentPageIndex=index;
                    });
                  },
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: ()=>_showBottomDialog(context),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w),
                            margin: EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: Theme.of(context).textTheme.titleSmall!.color!,
                                )
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_selectedSize==-1? 'Select Size' : "$_selectedSize",
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20.sp),),
                                Icon(Icons.arrow_drop_down,size: 25.sp,)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h,),
                        InkWell(
                          onTap: () async {
                            setState(() {
                              _isLoading=true;
                            });
                            await MyApi.getInstance.updateUserSize(gender: _humanTypeList[index], size: '$_selectedSize');
                            setState(() {
                              _isLoading=false;
                            });
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.pushAndRemoveUntil(widget.myContext, MaterialPageRoute(builder: (builder)=>const MyHomePage()),(Route<dynamic> route) => false);
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 50.w),
                            margin: EdgeInsets.symmetric(horizontal: 20.w),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10.r)
                            ),
                            child: Center(
                              child: Text('Confirm Size',style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontSize: 18.sp,
                                  color: Colors.white
                              ),),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                )
            ),
            SizedBox(height: 20.h,),
          ],
        ),
      ),
    );
  }

  void _showBottomDialog(BuildContext context){
    showModalBottomSheet(
      isScrollControlled: true,  // Allow dynamic height
      useSafeArea: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setBottomState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: double.infinity,
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: EdgeInsets.symmetric(vertical: 20.h,horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Size',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 22.sp),
                      ),
                      InkWell(
                          onTap: ()=>Navigator.pop(context),
                          child: Icon(Icons.close_sharp,size: 25.sp,)),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: ListView.builder(
                        itemCount: 20,
                        itemBuilder: (context,index){
                          return InkWell(
                            onTap: (){
                              setBottomState(() {
                                _selectedSizeIndex= index;
                              });
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5.h,),
                                  width: double.infinity,
                                  color: index ==_selectedSizeIndex? Colors.blueAccent : Colors.transparent,
                                  child: Center(
                                    child: Text("${6 + index*0.5}",
                                      style: Theme.of(context).textTheme.bodyLarge!
                                          .copyWith(fontSize: 22.sp,
                                          color: index ==_selectedSizeIndex? Colors.white :
                                          Theme.of(context).brightness==Brightness.light? Colors.black : Colors.white
                                      )
                                      ,),
                                  ),
                                ),
                                const Divider()
                              ],
                            ),
                          );
                        }
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  InkWell(
                    onTap: (){
                      setState(() {
                        _selectedSize=6 + (_selectedSizeIndex*0.5);
                      });
                      // updateState();
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: Colors.pink
                      ),
                      child: Center(
                        child: Text('Done',style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white,
                            fontSize: 20.sp
                        ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h,)
                ],
              ),
            );
          },

        );
      },
    );
  }
}
