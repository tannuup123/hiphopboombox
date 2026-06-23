import 'package:boombox/backend/api.dart';
import 'package:boombox/screens/blocked_users/blocked_users.dart';
import 'package:boombox/screens/login/login.dart';
import 'package:boombox/screens/main_screens/account/account_cubit.dart';
import 'package:boombox/screens/main_screens/account/account_state.dart';
import 'package:boombox/screens/main_screens/raffle/user_raffles/user_raffles.dart';
import 'package:boombox/screens/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../main.dart';
import '../../../webview/show_webview.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit,AccountState>(
      builder: (context,state){
        if(state is AccountInitial){
          return const Center(child: CircularProgressIndicator(),);
        }
        else if(state is AccountUserDetails){

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
                  padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 20.w),
                  decoration: BoxDecoration(
                      color: Theme.of(context).brightness==Brightness.dark ?
                      Colors.black54 : Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                        )
                      ]
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 80.h,
                        width: 80.w,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(state.userDetails.image??''),
                                fit: BoxFit.cover
                            ),
                            shape: BoxShape.circle
                        ),
                      ),
                      SizedBox(width: 20.w,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(state.userDetails.name??'',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp
                              ),
                            ),

                            Text(state.userDetails.email??'',
                              style: GoogleFonts.poppins(
                                  fontSize: 15.sp
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(height: 20.h,),

                _textBtn(
                    context: context,
                    onTap: ()=>
                        Navigator.push(context, MaterialPageRoute(builder: (builder)=>Profile(userDetails: state.userDetails,))),
                    icon: Icons.person_2_rounded,
                    text: 'Profile'
                ),
                _divider(),

                _textBtn(
                    context: context,
                    onTap: ()=>
                        Navigator.push(context, MaterialPageRoute(builder: (builder)=>const UserRaffles())).
                        then((value){
                          if(context.mounted && value=='refresh') context.read<AccountCubit>().isLoggedIn();
                        }),
                    icon: Icons.shop,
                    text: 'Raffles'
                ),
                _divider(),

                _textBtn(
                    context: context,
                    onTap: ()=>
                        Navigator.push(context, MaterialPageRoute(builder: (builder)=>const BlockedUsers())),
                    icon: Icons.block,
                    text: 'Blocked Users'
                ),
                _divider(),

                _textBtn(
                    context: context,
                    onTap: ()=>
                        Navigator.push(context, MaterialPageRoute(builder: (builder)=>
                        const ShowWebView(link: 'https://hiphopboombox.com/terms'))),
                    icon: Icons.policy_outlined,
                    text: 'Terms and Policy'
                ),
                _divider(),

                _textBtn(
                    context: context,
                    onTap: ()=>
                        Navigator.push(context, MaterialPageRoute(builder: (builder)=>
                        const ShowWebView(link: 'https://hiphopboombox.com/privacy'))),
                    icon: Icons.verified_user_outlined,
                    text: 'Privacy Policy'
                ),
                _divider(),

                _textBtn(
                    context: context,
                    onTap: ()=>
                        Navigator.push(context, MaterialPageRoute(builder: (builder)=>
                        const ShowWebView(link: 'https://hiphopboombox.com/v1/dmca'))),
                    icon: Icons.lock,
                    text: 'DCMA'
                ),
                _divider(),

                _textBtn(
                    context: context,
                    onTap: ()=>
                        Navigator.push(context, MaterialPageRoute(builder: (builder)=>
                        const ShowWebView(link: 'https://www.hiphopboombox.com/eula'))),
                    icon: Icons.privacy_tip_outlined,
                    text: 'EULA'
                ),
                _divider(),

                _textBtn(
                    context: context,
                    onTap: ()=>
                        _showAlertDialog(context),
                    icon: Icons.delete,
                    text: 'Delete Account'
                ),
                _divider(),

                _textBtn(
                    context: context,
                    onTap: ()=>
                        context.read<AccountCubit>().logout(),
                    icon: Icons.logout_rounded,
                    text: 'Logout'
                ),

                SizedBox(height: 10.h,),
                BlocBuilder<AppVersionCubit,String>(
                  builder: (BuildContext context, state) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Text('App Version: $state',
                        style: GoogleFonts.poppins(
                            color: Theme.of(context).brightness==Brightness.light?
                            Colors.black26 : Colors.white24,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp
                        ),
                      ),
                    );
                  },

                ),
              ],
            ),
          );
        }

        else if(state is AccountLoggedOut){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>const MyHomePage()),(Route<dynamic> route) => false);
          });
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text('Please Login to continue',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp
                ),
              ),
            ),
            SizedBox(height: 10.h,),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>Login()));
                },
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.cyan),
                  padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w))
                ),
                child: Text('Login',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp
                  ),
                ),
              ),
            ),

          ],
        );
      },
    );
  }

  void _showAlertDialog(BuildContext context1) {
    showDialog(
      context: context1,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete account",style: GoogleFonts.poppins(),),
          content: Text("Are you sure want to delete account?",style: GoogleFonts.poppins()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            SizedBox(width: 10.w),
            TextButton(
              onPressed: () async {
                // Handle any action for the confirm button
                Navigator.of(context).pop(); // Close the dialog
                // You can add more logic here if needed
                bool isSuccess= await MyApi.getInstance.deleteAccount();
                if(isSuccess){
                  context1.read<AccountCubit>().logout();
                }
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }


  Widget _textBtn(
      {required BuildContext context, required VoidCallback onTap, required IconData icon, required String text}){
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size:25.sp,),
      label: Text(text,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _divider(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: const Divider(),
    );
  }
}
