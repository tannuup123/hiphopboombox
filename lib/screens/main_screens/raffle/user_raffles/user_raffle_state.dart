import 'package:boombox/modal/shoe_modal.dart';

abstract class UserRaffleState{}

class UserRaffleInitial extends UserRaffleState{}
class UserRaffleLoading extends UserRaffleState{}
class UserRaffleLoaded extends UserRaffleState{
  final List<ShoeModal> list;

  UserRaffleLoaded(this.list);
}