import 'package:boombox/backend/api.dart';
import 'package:boombox/modal/shoe_modal.dart';
import 'package:boombox/screens/main_screens/raffle/user_raffles/user_raffle_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserRaffleCubit extends Cubit<UserRaffleState>{

  UserRaffleCubit():super(UserRaffleInitial());

  Future<void> loadUserRaffles() async {
    emit(UserRaffleLoading());
    List<ShoeModal> shoeList= await MyApi.getInstance.getRafflesOrderedByUsers();
    if(!isClosed){
      emit(UserRaffleLoaded(shoeList));
    }
  }
}