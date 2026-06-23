import 'package:flutter_bloc/flutter_bloc.dart';

class ProductSelectCubit extends Cubit<int>{
  ProductSelectCubit():super(0);

  void selectIndex(int index){
    emit(index);
  }

}