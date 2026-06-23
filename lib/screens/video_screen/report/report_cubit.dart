import 'package:flutter_bloc/flutter_bloc.dart';

class ReportCubit extends Cubit<String>{

  ReportCubit():super('');

  void itemSelected(String? value){
    if(value!=null){
      emit(value);
    }
  }
}