import 'package:boombox/backend/api.dart';
import 'package:boombox/modal/shoe_modal.dart';
import 'package:boombox/screens/main_screens/raffle/raffle_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RaffleCubit extends Cubit<RaffleState>{
  RaffleCubit(): super(RaffleInitial());
  List<ShoeModal> _shoesList=[];

  Future<void> getRaffle() async {
    emit(RaffleLoading());
    _shoesList=await MyApi.getInstance.getRaffle();
    if(!isClosed && _shoesList.isNotEmpty){
      emit(RaffleLoaded(_shoesList,_shoesList[0]));
    }
    else if (!isClosed){
      emit(RaffleError());
    }
  }

  void changeShoe(int index){
    emit(RaffleLoaded(_shoesList, _shoesList[index]));
  }

  Future<void> getShoeSizes(String raffleId) async {
    emit(RaffleLoading());
    Map<String,String> map= await MyApi.getInstance.getRaffleSize(raffleId);
    if(!isClosed) emit(ShoeSizeLoaded<Map<String,String>>(map));
  }

}