import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode>{
  ThemeMode _themeMode = ThemeMode.light;

  ThemeCubit():super(ThemeMode.light);

  Future<void> getSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    if(isDarkMode){
      _themeMode=ThemeMode.dark;
    }
    else{
      _themeMode=ThemeMode.light;
    }
    if(!isClosed){
      emit(_themeMode);
    }
  }

  void changeTheme(){
    if(_themeMode == ThemeMode.dark){
      _themeMode=ThemeMode.light;
    }
    else{
      _themeMode=ThemeMode.dark;
    }
    if(!isClosed){
      emit(_themeMode);
    }
    saveTheme();
  }

  Future<void> saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _themeMode==ThemeMode.dark);
  }

}