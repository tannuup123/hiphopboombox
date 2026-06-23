import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/video_screen/report/report_cubit.dart';

class ReportAlert{

  static void showReportDialog(BuildContext context){
    final List<String> options = [
      'Sexual content',
      'Violent or repulsive content',
      'Hateful or abusive content',
      'Harassment or bullying',
      'Harmful or dangerous acts',
      'Misinformation',
      'Child abuse',
      'Legal issue',
      'Promotes terrorism',
      'Spam or misleading',
    ];
    showDialog(
        context: context,
        builder: (context) {
          return BlocProvider(
            create: (BuildContext context)=>ReportCubit(),
            child: BlocBuilder<ReportCubit,String>(
              builder: (BuildContext context, String selectedValue) {
                return Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
                  elevation: 16,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Report',
                              style: TextStyle(color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.sp
                              ),
                            ),
                            SizedBox(height: 15.h),
                            Text("What's going on",
                              style: TextStyle(color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.sp
                              ),
                            ),
                            SizedBox(height: 15.h),
                            Text("We'll review all the community guidelines, so don’t stress about making the perfect choice.",
                              style: TextStyle(color: Colors.black,
                                  fontSize: 16.sp
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      for (String option in options)
                        RadioListTile<String>(
                          title: Text(option,
                            style: TextStyle(
                                fontSize: 18.sp
                            ),),
                          value: option,
                          groupValue: selectedValue,
                          onChanged: (String? value) {
                            context.read<ReportCubit>().itemSelected(value);
                          },
                        ),

                      SizedBox(height: 20.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: ()=>Navigator.pop(context),
                            child: Text('Cancel',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp
                              ),),
                          ),
                          SizedBox(width: 20.w,),

                          InkWell(
                            onTap: (){
                              WidgetsBinding.instance.addPostFrameCallback((_) =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Thank you for reporting. If we determine that this violates our community guidelines, we will remove the user from our platform',
                                        style: GoogleFonts.poppins(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.blue,
                                    ),
                                  ));
                              Navigator.pop(context);
                            },
                            child: Text('Report',
                              style: TextStyle(
                                  color: selectedValue.isNotEmpty? Colors.blue : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp
                              ),),
                          ),
                          SizedBox(width: 20.w,),
                        ],
                      ),
                      SizedBox(height: 15.h,),
                    ],
                  ),
                );
              },
            ),
          );
        }
    );
  }

}