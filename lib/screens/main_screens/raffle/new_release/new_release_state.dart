import 'package:boombox/modal/shoe_modal.dart';

abstract class NewReleaseState{}

class NewReleaseInitial extends NewReleaseState{}
class NewReleaseLoading extends NewReleaseState{}

class NewReleaseLoaded extends NewReleaseState{
  final List<ShoeModal> upcomingList;
  final List<ShoeModal> popularList;
  final List<ShoeModal> pastList;

  NewReleaseLoaded(this.upcomingList, this.popularList, this.pastList);
}

abstract class SneakerBrandState{}
class SneakerBrandInitial extends SneakerBrandState{}
class SneakerBrandLoading extends SneakerBrandState{}

class SneakerBrandsLoaded<T> extends SneakerBrandState{
  final T data;
  final String? brandSelected;

  SneakerBrandsLoaded({required this.data,this.brandSelected});
}



