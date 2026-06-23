import 'package:boombox/screens/main_screens/raffle/raffle_cubit.dart';
import 'package:boombox/screens/main_screens/raffle/raffle_state.dart';
import 'package:boombox/widget/expanded_news.dart';
import 'package:boombox/modal/shoe_modal.dart';
import 'package:boombox/modal/user_details.dart';
import 'package:boombox/screens/main_screens/raffle/payment/payment.dart';
import 'package:boombox/screens/register/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectShoeSize extends StatefulWidget {
  final ShoeModal shoeModal;
  const SelectShoeSize({super.key, required this.shoeModal});

  @override
  State<SelectShoeSize> createState() => _SelectShoeSizeState();
}

class _SelectShoeSizeState extends State<SelectShoeSize> {
  final PageController _pageController= PageController();
  int _currentPageIndex=0;
  num _selectedSize=-1;
  int _selectedSizeIndex=-1;

  final List<String> _humanTypeList=['Men', 'Women', 'Children'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Select Your Size",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20.sp), // Adjust the title style
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).appBarTheme.backgroundColor,
            child: Row(
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
          ),

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(widget.shoeModal.image1,
                        height: MediaQuery.sizeOf(context).height * 0.3,
                        width: double.infinity,
                        // fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 15.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Your Size',style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 20.sp),),
                            SizedBox(height: 20.h,),
                            InkWell(
                              onTap: ()=>_showBottomDialog(context),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      color: Theme.of(context).textTheme.titleSmall!.color!,
                                    )
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_selectedSize==-1? 'Select Size' : "$_selectedSize",
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20.sp),),
                                    Icon(Icons.arrow_drop_down,size: 25.sp,)
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 30.h,),
                            InkWell(
                              onTap: (){
                                if(UserDetails.id==null){
                                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>
                                      Register())
                                  );
                                }
                                else if(_selectedSize==-1){
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Please select a shoe size',
                                          style: GoogleFonts.poppins(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  });
                                }
                                else{
                                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>
                                      Payment(shoeModal: widget.shoeModal,
                                        humanType: _humanTypeList[index],
                                        size: '$_selectedSize',)));
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    color: Colors.blue
                                ),
                                child: Center(
                                  child: Text('Confirm Size',style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: Colors.white,
                                      fontSize: 20.sp
                                  ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  );
                },
              )
          ),

        ],
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
      constraints: BoxConstraints.expand(
          width: double.infinity,
          height: 0.7.sh
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (BuildContext context)=>RaffleCubit()..getShoeSizes(widget.shoeModal.id),
          child: BlocBuilder<RaffleCubit,RaffleState>(
            builder: (BuildContext context, RaffleState state) {
              if(state is RaffleLoading){
                return const Center(child: CircularProgressIndicator());
              }
              else if(state is ShoeSizeLoaded<Map<String,String>>){
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
                                  bool isAvailableSize=state.shoeSizes.containsKey("${6 + index*0.5}");
                                  return InkWell(
                                    onTap: (){
                                      if(isAvailableSize){
                                        setBottomState(() {
                                          _selectedSizeIndex= index;
                                        });
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 5.h,),
                                          width: double.infinity,
                                          color: index ==_selectedSizeIndex? Colors.blueAccent : Colors.transparent,
                                          child: Center(
                                            child: Text("${6 + index*0.5}",//"${6 + index*0.5}"
                                              style: Theme.of(context).textTheme.bodyLarge!
                                                  .copyWith(fontSize: 22.sp,
                                                  fontWeight: isAvailableSize? FontWeight.bold : FontWeight.normal,
                                                  color: index ==_selectedSizeIndex? Colors.white:
                                                  Theme.of(context).brightness==Brightness.light?
                                                  (isAvailableSize? Colors.black : Colors.black38)
                                                      : (isAvailableSize? Colors.white : Colors.white30)
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
                              if(_selectedSizeIndex!=-1){
                                setState(() {
                                  _selectedSize=6 + (_selectedSizeIndex*0.5);
                                });
                              }
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
              }
              return Container();
            },

          ),
        );
      },
    );
  }

}
