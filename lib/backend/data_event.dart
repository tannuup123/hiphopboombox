import '../modal/category_modal.dart';
import '../modal/postmodal.dart';

abstract class DataEvent{}

class FetchData extends DataEvent{}
class FetchData2 extends DataEvent{
  String date;
  FetchData2(this.date);
}

abstract class DataState{}

class DataInitial extends DataState{}

class DataLoading extends DataState{}

class DataLoaded extends DataState{
  final List<PostModal> list;

  DataLoaded(this.list);
}

class CategoriesLoaded extends DataState{
  final List<CategoryModal> list;

  CategoriesLoaded(this.list);
}

class DataError extends DataState {
  final String message;

  DataError(this.message);
}


abstract class CategoryPostState{}

class CategoryPostInitial extends CategoryPostState{}

class CategoryPostLoading extends CategoryPostState{
  final int index;

  CategoryPostLoading(this.index);
}

class CategoryPostLoaded extends CategoryPostState{
  final int index;
  final List<PostModal> list;
  final bool hasReachedMax;

  CategoryPostLoaded(this.list, this.index, this.hasReachedMax);
}