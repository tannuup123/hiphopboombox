import 'package:boombox/modal/user_details.dart';
import 'package:boombox/screens/main_screens/raffle/select_shoe_size/select_primary_size.dart';
import 'package:boombox/screens/main_screens/raffle/user_raffles/user_raffle_cubit.dart';
import 'package:boombox/screens/main_screens/raffle/user_raffles/user_raffle_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../account/account_cubit.dart';
import '../../account/account_state.dart';

class UserRaffles extends StatelessWidget {
  const UserRaffles({super.key,});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (create)=>UserRaffleCubit()..loadUserRaffles()),
        BlocProvider(create: (context){
          return AccountCubit()..isLoggedIn();
        })
      ],
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: BlocBuilder<AccountCubit,AccountState>(
            builder: (context,state){
              if(state is AccountInitial){
                return const Center(child: CircularProgressIndicator(),);
              }
              else if(state is AccountUserDetails){
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h,),
                      Center(
                        child: Column(
                          children: [
                            Container(
                              height:100.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: Image.network(state.userDetails.image??'',).image,
                                      fit: BoxFit.cover
                                  ),
                                  border: Border.all(
                                      color: Colors.blue,
                                      width: 2
                                  )
                              ),
                            ),
                            SizedBox(height: 20.h,),
                            Text('${state.userDetails.name}',style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 20.sp),),
                          ],
                        ),
                      ),
                      SizedBox(height: 5.h,),
                      if(state.userDetails.primarySize=='0' || state.userDetails.primarySize=='-1')
                        SelectPrimarySize(myContext: context)
                      else
                        Center(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 20.h),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: "Primary Size :"
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
                                      text: '  ${state.userDetails.primarySize}'
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
                            ),
                          ),
                        ),
                      // SizedBox(height: 5.h,),
                      Text('Raffles',style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 20.sp),),
                      SizedBox(height: 20.h,),

                      BlocBuilder<UserRaffleCubit,UserRaffleState>(
                        builder: (BuildContext context, UserRaffleState state) {
                          if(state is UserRaffleLoading){
                            return const Center(child: CircularProgressIndicator(),);
                          }
                          else if(state is UserRaffleLoaded){
                            return Expanded(
                                child: ListView.separated(
                                    itemBuilder: (context,index){
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(state.list[index].title,
                                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 18.sp),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 5.h,),
                                                Text(state.list[index].description,
                                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15.sp),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 10.w,),
                                          Container(
                                            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10.r),
                                                border: Border.all(
                                                    color: Theme.of(context).brightness==Brightness.light ? Colors.black26 : Colors.white24
                                                )
                                            ),
                                            child: Image.network(state.list[index].image1,
                                              height: 60.h,width: 100.w,),
                                          )
                                        ],
                                      );
                                    },
                                    separatorBuilder: (context,index){
                                      return Column(
                                        children: [
                                          SizedBox(height: 5.h,),
                                          const Divider(),
                                          SizedBox(height: 5.h,),
                                        ],
                                      );
                                    },
                                    itemCount: state.list.length
                                )
                            );
                          }
                          return Container();
                        },

                      )
                    ],
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
