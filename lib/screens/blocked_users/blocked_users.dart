import 'package:boombox/screens/blocked_users/blocked_user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';

class BlockedUsers extends StatelessWidget {
  const BlockedUsers({super.key});

  @override
  Widget build(BuildContext context) {
    bool isStart=true;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (create)=>BlockedUserCubit()..isAdminBlocked())
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset('assets/images/logo_white.png', height: 25.h,),
          centerTitle: true,
        ),
        body: SafeArea(
            child: BlocListener<BlockedUserCubit,bool>(
              listener: (BuildContext context, bool isAdminBlocked) {
                if(!isAdminBlocked && !isStart){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>const MyHomePage()),(Route<dynamic> route) => false);
                }
              },
              child: BlocBuilder<BlockedUserCubit,bool>(
                builder: (BuildContext context, bool isAdminBlocked) {
                  if(isAdminBlocked) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
                      child: Column(
                        children: [
                          Center(
                            child: Text('Blocked Users',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.sp
                                )
                            ),
                          ),
                          SizedBox(height: 30.h,),
                          Expanded(
                              child: ListView.separated(
                                  itemBuilder: (context,index){
                                    return Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Theme.of(context).brightness==Brightness.light?
                                              Colors.black : Colors.white,)
                                          ),
                                          padding: EdgeInsets.all(10.r),
                                          child: ClipRRect(
                                            child: Icon(Icons.person,size: 35.sp,),
                                          ),
                                        ),
                                        SizedBox(width: 10.w,),
                                        Text('Admin',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.sp
                                            )
                                        ),
                                        const Spacer(),
                                        InkWell(
                                          onTap: (){
                                            isStart=false;
                                            context.read<BlockedUserCubit>().unblockAdmin();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: BorderRadius.circular(10.r)
                                            ),
                                            padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
                                            child: Text('Unblock',
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15.sp
                                                )
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context,index)=>SizedBox(height: 20.h,),
                                  itemCount: 1
                              )
                          )
                        ],
                      ),
                    );
                  }
                  else{
                    return Center(
                      child: Text('No blocked users',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp
                          )
                      ),
                    );
                  }
                },

              ),
            )
        ),
      ),
    );
  }
}
