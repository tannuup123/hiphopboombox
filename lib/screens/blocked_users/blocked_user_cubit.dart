import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlockedUserCubit extends Cubit<bool>{

  BlockedUserCubit():super(false);

  Future<void> isAdminBlocked() async {
    final prefs= await SharedPreferences.getInstance();
    //todo: change default value to false
    emit(prefs.getBool('isAdminBlocked')??false);
  }

  Future<void> blockAdmin() async {
    final prefs= await SharedPreferences.getInstance();
    prefs.setBool('isAdminBlocked', true);
    emit(true);
  }

  Future<void> unblockAdmin() async {
    final prefs= await SharedPreferences.getInstance();
    prefs.setBool('isAdminBlocked', false);
    emit(false);
  }
}