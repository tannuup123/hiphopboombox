import 'package:boombox/backend/api.dart';
import 'package:boombox/modal/shoe_modal.dart';
import 'package:boombox/modal/sneaker_brand.dart';
import 'package:boombox/screens/main_screens/raffle/new_release/new_release_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NewReleaseCubit extends Cubit<NewReleaseState>{
  NewReleaseCubit():super(NewReleaseInitial());
  String? _month;
  String? _year;
  String? _brandId;

  Future<void> getSneakerRaffle({String? categoryId}) async {
    emit(NewReleaseLoading());
    _year= _year??DateTime.now().year.toString();
    // print(_brandId);

    List<ShoeModal> upcomingList= await MyApi.getInstance.filterSneaker(categoryId: '1',month:_month,
        year:_year, brand: _brandId);

    List<ShoeModal> popularList= await MyApi.getInstance.filterSneaker(categoryId: '2',month:_month,
    year:_year, brand: _brandId);

    List<ShoeModal> pastList= await MyApi.getInstance.filterSneaker(categoryId: '3',month:_month,
    year:_year, brand: _brandId);

    if(!isClosed) {
      emit(NewReleaseLoaded(upcomingList,popularList,pastList));
    }
  }

  set month(String month)=>_month=month;
  set year(String year)=>_year=year;
  set brandId(String brandId)=>_brandId=brandId;

}

class SneakerBrandCubit extends Cubit<SneakerBrandState>{
  SneakerBrandCubit():super(SneakerBrandInitial());
  List<SneakerBrand>? _sneakersBrands;

  Future<void> loadBrands() async {
    emit(SneakerBrandLoading());
    _sneakersBrands= await MyApi.getInstance.getSneakersBrands();
    if(!isClosed) {
      emit(SneakerBrandsLoaded<List<SneakerBrand>>(data: _sneakersBrands??[]));
    }
  }

  void changeBrand(String brand){
    emit(SneakerBrandsLoaded<List<SneakerBrand>>(data: _sneakersBrands??[],brandSelected: brand));
  }

}

class SneakerDateCubit extends Cubit<DateTime?>{
  SneakerDateCubit():super(null);
  DateTime? _dateTime;

  void changeDate(DateTime date){
    _dateTime=date;
    emit(date);
  }

  DateTime? get dateTime=>_dateTime;
}

class NewReleasePageView extends Cubit<int>{
  NewReleasePageView(this._pageController):super(0);
  final PageController _pageController;

  void changePage(int index){
    try{
      _pageController.jumpToPage(index);
      emit(index);
    }
    catch(error){}
  }

  void changeIndicatorIndex(int index){
    emit(index);
  }

  @override
  Future<void> close() {
    _pageController.dispose();
    return super.close();
  }

}