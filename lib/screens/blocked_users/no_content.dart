import 'package:boombox/screens/blocked_users/blocked_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class NoContent extends StatelessWidget {
  const NoContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.block,color:Colors.grey,size: 100.sp,),
          Text('No content available',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp
              )
          ),
          SizedBox(height: 10.h,),

          Text('Unblock certain users to access their content.',
              style: GoogleFonts.poppins(
                  fontSize: 15.sp
              )
          ),
          SizedBox(height: 10.h,),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (builder)=>const BlockedUsers()));
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
      ),
    );
  }
}
