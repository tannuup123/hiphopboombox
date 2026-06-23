import 'package:boombox/bloc/bottom_event.dart';
import 'package:boombox/bloc/bottom_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomBlock extends Bloc<BottomEvent,BottomState>{
  BottomBlock(): super(BottomState(0)){
    on((event,emit){

      if(event is SelectEvent){
        emit.call(BottomState(event.index));
      }
    });
  }


}