import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LightTheme{

  ThemeData get lightTheme {
    return ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black12,
        hintColor: Colors.black54,

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blueAccent,
        ),
        textTheme: TextTheme(
          titleMedium: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
          ),
          titleSmall: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 30.sp,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 15.sp,
            fontWeight: FontWeight.normal,
          ),
          bodySmall: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 12.sp,
            fontWeight: FontWeight.normal,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xffee3483),
          unselectedItemColor: Colors.black,
          selectedIconTheme: IconThemeData(
            color: Color(0xffee3483),
          ),
          unselectedIconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.black,
        ),
        textButtonTheme: const TextButtonThemeData(
            style: ButtonStyle(
                iconColor: WidgetStatePropertyAll(Colors.black)
            )
        ),
      dividerColor: Colors.black26,
      tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
              color: Colors.grey.shade300
          ),
          textStyle: GoogleFonts.poppins(
            color: Colors.black,
              fontSize: 16.sp
          )
      ),

      // Define more light theme properties here
    );

  }
}