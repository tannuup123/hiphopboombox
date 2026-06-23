import 'package:boombox/modal/user_details.dart';
import 'package:boombox/screens/register/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../backend/api.dart';

class RegisterCubit extends Cubit<RegisterState>{

  RegisterCubit(): super(RegisterInitial());

  Future<void> register(String? email,String? password,String name,String image,String ip) async {
    // if(validateEmail(email).isNotEmpty){
    //   emit(RegisterFailed(validateEmail(email)));
    //   return;
    // }
    // if(validatePass(password).isNotEmpty){
    //   emit(RegisterFailed(validatePass(password)));
    //   return;
    // }
    emit(RegisterLoading());
    bool isSuccess=await MyApi.getInstance.register(email!, password!,name, image,ip);

    if(isSuccess){
      final prefs= await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn',true);
      prefs.setString('email',email);
      emit(RegisterSuccess());
    }
    else{
      emit(RegisterFailed('Wrong email or password'));
    }
  }

  Future<void> uploadProfileImg(String? email,String? password,String name,String path)async {
    // print('path $path');
    emit(RegisterLoading());
    if(UserDetails.id!=null){
      String img= path.contains('http')?
      path.replaceAll(MyApi.imgUrl, '') : await MyApi.getInstance.uploadImage(path);
      await MyApi.getInstance.updateUserDetails(name: name, image: img);
      emit(RegisterSuccess());
    }
    else{
      if(path.isEmpty){
        emit(RegisterFailed('Image is required'));
        return;
      }
      else if(name.isEmpty){
        emit(RegisterFailed('Name is required'));
        return;
      }
      String img= await MyApi.getInstance.uploadImage(path);
      if(img.isEmpty){
        emit(RegisterFailed('Image not uploaded'));
        return;
      }
      String ip= await MyApi.getInstance.getIp();
      // print("$email, $password, $name, $img, $ip");
      register(email, password, name, img, ip);
    }
  }

  Future<void> validate(String email,String password) async {
    if(validateEmail(email).isNotEmpty){
      emit(RegisterFailed(validateEmail(email)));
      return;
    }
    if(validatePass(password).isNotEmpty){
      emit(RegisterFailed(validatePass(password)));
      return;
    }
    emit(RegisterSuccess());
  }

  String validateEmail(String email){
    if(email.trim().isEmpty){
      return "Email can't be empty";
    }
    else if(!email.contains('@') || !email.contains('.')){
      return "Invalid email";
    }
    return '';
  }

  String validatePass(String pass){
    if(pass.trim().isEmpty){
      return "Password can't be empty";
    }
    else if(pass.length<=4){
      return "Password length should be more than 4";
    }
    return '';
  }



}