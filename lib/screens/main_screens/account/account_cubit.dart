import 'package:boombox/backend/api.dart';
import 'package:boombox/modal/user_details.dart';
import 'package:boombox/screens/main_screens/account/account_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountCubit extends Cubit<AccountState>{
  AccountCubit():super(AccountInitial());

  Future<void> isLoggedIn() async {
    final prefs= await SharedPreferences.getInstance();
    bool isLoggedIn=prefs.getBool('isLoggedIn')??false;
    if(isLoggedIn){
      UserDetails userDetails= await MyApi.getInstance.getUserDetails(prefs.getString('email')??'');
      prefs.setString('userId', UserDetails.id??''); //setting the userId
      if(!isClosed) {
        emit(AccountUserDetails(userDetails));
      }
    }
    else{
      if(!isClosed) {
        emit(AccountNotLoggedIn());
      }
    }
  }

  Future<void> logout() async {
    final prefs= await SharedPreferences.getInstance();
    prefs.clear();
    UserDetails.id=null;
    emit(AccountLoggedOut());
  }
}

class AppVersionCubit extends Cubit<String>{
  AppVersionCubit():super('0');

  Future<void> getAppDetails() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    // String buildNumber = packageInfo.buildNumber;

    emit(version);
  }
}