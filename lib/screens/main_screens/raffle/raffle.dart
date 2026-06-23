import 'package:boombox/widget/expanded_news.dart';
import 'package:boombox/widget/report_alert.dart';
import 'package:boombox/modal/shoe_modal.dart';
import 'package:boombox/modal/user_details.dart';
import 'package:boombox/screens/login/login.dart';
import 'package:boombox/screens/main_screens/account/account_cubit.dart';
import 'package:boombox/screens/main_screens/raffle/new_release/new_release.dart';
import 'package:boombox/screens/main_screens/raffle/raffle_cubit.dart';
import 'package:boombox/screens/main_screens/raffle/raffle_state.dart';
import 'package:boombox/screens/main_screens/raffle/select_shoe_size/select_primary_size.dart';
import 'package:boombox/screens/main_screens/raffle/select_shoe_size/select_shoe_size.dart';
import 'package:boombox/screens/main_screens/raffle/user_raffles/user_raffles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../main.dart';

class Raffle extends StatelessWidget {
  const Raffle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RaffleCubit,RaffleState>(
      builder: (BuildContext context, RaffleState state) {
        if(state is RaffleLoading){
          return const Center(child: CircularProgressIndicator(),);
        }
        else if(state is RaffleLoaded){
          List<ShoeModal> shoeList=state.shoesList;
          if(state.shoesList.isNotEmpty){
            if(UserDetails.id!=null && (state.shoesList[0].primarySize==null || state.shoesList[0].primarySize==''
                || state.shoesList[0].primarySize=='0'|| state.shoesList[0].primarySize=='-1' )){
              // WidgetsBinding.instance.addPostFrameCallback((duration){
              //   Navigator.push(context, MaterialPageRoute(builder: (builder)=> const UserRaffles()));
              // });

            }
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top:10.h,bottom: 1.h, left: 20.w,right: 20.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Tooltip(
                          message: "This is your primary size for all raffles. You will automatically be entered into any raffle featuring this size at no additional cost. Please note that this size cannot be changed.",
                          textAlign: TextAlign.center,
                          triggerMode: TooltipTriggerMode.tap,
                          margin: EdgeInsets.only(top: 10.h,left: 10.w,right: 80.w),
                          showDuration: const Duration(seconds: 10),
                          onTriggered: (){
                            if(UserDetails.id==null){
                              Navigator.push(context, MaterialPageRoute(builder: (builder)=>Login()));
                            }
                            else if(UserDetails.id!=null && (state.shoesList[0].primarySize==null || state.shoesList[0].primarySize==''
                                || state.shoesList[0].primarySize=='0'|| state.shoesList[0].primarySize=='-1' )){
                              Navigator.push(context, MaterialPageRoute(builder: (builder)=> const UserRaffles())).
                            then((value){
                              if(context.mounted && value=='refresh'){
                                context.read<RaffleCubit>().getRaffle();
                                context.read<AccountCubit>().isLoggedIn();
                              };
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                            decoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Center(
                              child: Text(
                                UserDetails.id==null ?
                                'Select primary size':
                                (state.shoesList[0].primarySize==null || state.shoesList[0].primarySize==''
                                    || state.shoesList[0].primarySize=='0'|| state.shoesList[0].primarySize=='-1' )? 'Select primary size'
                                    : 'Primary Size-> ${state.shoesList[0].primarySize}(${state.shoesList[0].gender?.substring(0,1).toUpperCase()})',
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontSize: 18.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Tooltip(
                        message: 'Some raffles may offer additional sizes. If you choose to participate with an additional size, a designated fee will apply for each additional size entry.',
                        textAlign: TextAlign.center,
                        triggerMode: TooltipTriggerMode.tap,
                        margin: EdgeInsets.only(top: 10.h,left: 80.w,right: 10.w),
                        showDuration: const Duration(seconds: 10),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Center(
                            child: Text(
                              '\$11',
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontSize: 18.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Image.network(state.topShoe.image1,
                  height: MediaQuery.sizeOf(context).height*0.26,
                ),
                SizedBox(height: 10.h,),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 20.w),
                  child: InkWell(
                    onTap: (){
                      if(UserDetails.id!=null){
                        Navigator.push(context, MaterialPageRoute(builder: (builder)=> SelectShoeSize(shoeModal: state.topShoe,)));
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(state.topShoe.title,style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 18.sp),),
                              SizedBox(height: 5.h,),
                              Text(state.topShoe.description,
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15.sp),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20.w,),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                  color: Theme.of(context).brightness==Brightness.light ? Colors.black26 : Colors.white24
                              )
                          ),
                          child: Image.network(state.topShoe.image2,
                            height: 60.h,width: 100.w,),
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
                          child: Image.network(state.topShoe.image3,
                            height: 60.h,width: 100.w,),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h,),
                const Divider(),
                SizedBox(height: 10.h,),

                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context,index){
                        if(shoeList[index].id==state.topShoe.id){
                          return Container();
                        }
                        return InkWell(
                          onTap: ()=>context.read<RaffleCubit>().changeShoe(index),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(shoeList[index].title,style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 18.sp),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 5.h,),
                                      Text(shoeList[index].description,
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15.sp),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 20.w,),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                          color: Theme.of(context).brightness==Brightness.light ? Colors.black26 : Colors.white24
                                      )
                                  ),
                                  child: Image.network(shoeList[index].image1,
                                    height: 60.h,width: 100.w,),
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
                                  child: Image.network(shoeList[index].image2,
                                    height: 60.h,width: 100.w,),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context,index){
                        if(shoeList[index].id==state.topShoe.id){
                          return Container();
                        }
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: const Divider(),
                        );
                      },
                      itemCount: shoeList.length
                  ),
                ),

                SizedBox(height: 10.h,),
                // Visibility(
                //   visible: UserDetails.id!=null,
                //   child: InkWell(
                //     onTap: ()=>
                //         Navigator.push(context, MaterialPageRoute(builder: (builder)=> SelectShoeSize(shoeModal: state.topShoe,))),
                //     child: Container(
                //       width: double.infinity,
                //       padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 50.w),
                //       margin: EdgeInsets.symmetric(horizontal: 20.w),
                //       decoration: BoxDecoration(
                //           color: Colors.blue,
                //           borderRadius: BorderRadius.circular(10.r)
                //       ),
                //       child: Center(
                //         child: Text('Additional Sizes \$11',style: Theme.of(context).textTheme.titleMedium!.copyWith(
                //             fontSize: 18.sp,
                //             color: Colors.white
                //         ),),
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(height: 5.h,),
                InkWell(
                  onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (builder)=>NewRelease())),
                  child: Text('New Release',style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 18.sp,
                      color: Colors.pink,
                    letterSpacing: 2,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.pink
                  ),),
                ),
                SizedBox(height: 10.h,)
              ],
            );
          }
        }
        else if(state is RaffleError){
          return const Center(
            child: Text('No raffles are available right now'),
          );
        }
        return Container();
      },
    );
  }
}
