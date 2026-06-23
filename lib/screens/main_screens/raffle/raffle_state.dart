import 'package:boombox/modal/shoe_modal.dart';

abstract class RaffleState{}

class RaffleInitial extends RaffleState{}

class RaffleLoading extends RaffleState{}

class RaffleLoaded extends RaffleState{
  final List<ShoeModal> shoesList;
  final ShoeModal topShoe;

  RaffleLoaded(this.shoesList, this.topShoe);
}
class ShoeSizeLoaded<T> extends RaffleState{
  final T shoeSizes;

  ShoeSizeLoaded(this.shoeSizes);
}

class RaffleError extends RaffleState{}