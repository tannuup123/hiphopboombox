import 'dart:io';

import 'package:boombox/modal/user_details.dart';
import 'package:boombox/screens/profile/profile_cubit.dart';
import 'package:boombox/screens/profile/profile_state.dart';
import 'package:boombox/screens/register/register_state.dart';
import 'package:boombox/screens/register/regsiter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';

class Profile extends StatelessWidget {
  final String? email,password;
  final UserDetails? userDetails;
  Profile({super.key, this.email, this.password, this.userDetails});

  final TextEditingController _nameController=TextEditingController();

  final GlobalKey<FormState> globalKey=GlobalKey();

  @override
  Widget build(BuildContext context) {
    String profileImg=userDetails!=null?userDetails!.image??'' : '';
    _nameController.text=userDetails!=null? userDetails!.name??'' : '';

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (create)=>ImageCubit()),
        BlocProvider(create: (create)=>RegisterCubit()),
      ],
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('My Details',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
                fontSize: 20.sp
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: globalKey,
                child: Column(
                  children: [
                    SizedBox(height: 5.h,),
                    BlocBuilder<ImageCubit,ImageState>(
                      builder: (context,state){
                        bool isOnline=userDetails!=null;
                        if(state is ImageLoaded){
                          profileImg=state.path;
                          isOnline=state.isOnline;
                        }
                        return InkWell(
                          onTap: context.read<ImageCubit>().pickImage,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 100.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: profileImg.isNotEmpty?
                                        isOnline && userDetails!=null?
                                        Image.network(profileImg,).image
                                            :
                                        Image.file(File(profileImg),).image
                                            :
                                        Image.asset('assets/images/person.png',).image,
                                      fit: profileImg.isNotEmpty? BoxFit.cover: BoxFit.contain
                                    )
                                ),
                              ),
                              Positioned.fill(
                                // right: 8.w,
                                child: Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                          color: Colors.black,
                                          shape: BoxShape.circle
                                      ),
                                      child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle
                                          ),
                                          child: const Icon(Icons.edit,color: Colors.black,size: 18,)),
                                    )),
                              ),
                              Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: state is ImageLoading ? const CircularProgressIndicator(color: Colors.black,):
                                    Container(),
                                  )
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20.h,),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).brightness==Brightness.light?
                          Colors.black12 : Colors.white12,
                          borderRadius: BorderRadius.circular(10.r)
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.h),
                        child: TextFormField(
                          controller: _nameController,
                          validator: (s){
                            return s!.isEmpty?"Name can't be empty" : null;
                          },
                          decoration: InputDecoration(
                              hintText: 'Name',
                              hintStyle: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold

                              ),
                              border: InputBorder.none,
                              suffixIcon: const Icon(Icons.person_2_outlined,)
                          ),
                          style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h,),

                    BlocBuilder<RegisterCubit,RegisterState>(
                        builder: (context,state){
                          if(state is RegisterLoading){
                            return const Center(child: CircularProgressIndicator());
                          }
                          else if(state is RegisterFailed){
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    state.errorMsg,
                                    style: GoogleFonts.poppins(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            });
                          }
                          else if(state is RegisterSuccess){
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>const MyHomePage()),(Route<dynamic> route) => false);
                            });
                          }
                          return InkWell(
                            onTap: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if(globalKey.currentState!.validate()){
                                context.read<RegisterCubit>().uploadProfileImg(email, password, _nameController.text, profileImg);
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(horizontal: 5.w),
                              decoration: BoxDecoration(
                                  color: const Color(0xffee3483),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical:10.h,horizontal: 20.w,),
                                  child: Text(userDetails!=null?"Update":"Continue",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.normal).fontFamily,
                                        fontSize: 22.sp,

                                      )),
                                ),
                              ),
                            ),
                          );
                        }
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
