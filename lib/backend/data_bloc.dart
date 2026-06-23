import 'package:boombox/backend/api.dart';
import 'package:boombox/backend/data_event.dart';
import 'package:boombox/modal/category_modal.dart';
import 'package:boombox/modal/postmodal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DataFetchBloc extends Bloc<DataEvent,DataState>{

  DataFetchBloc() : super(DataInitial()){
    on<FetchData>((event,state) async {
      state.call(DataLoading());

      try{
        List<PostModal> list=  await MyApi.getInstance.getTrending('w');
        state.call(DataLoaded(list));
      }
      catch(e){
        state.call(DataError(e.toString()));
      }

        });
  }
}

class DataFetchBloc2 extends Bloc<DataEvent,DataState>{
  DataFetchBloc2(): super(DataInitial()){
    on<FetchData2>((event,state) async {
      state.call(DataLoading());
      try{
        List<PostModal> list= await MyApi.getInstance.getPostByDate(event.date);
        state.call(DataLoaded(list));
      }
      catch(e){
        state.call(DataError(e.toString()));
      }
    });
  }

}

class DataFetchBloc3 extends Bloc<DataEvent,DataState>{
  DataFetchBloc3(): super(DataInitial()){
    on<FetchData2>((event,state) async {
      // state.call(DataLoading());
      try{
        List<PostModal> list= await MyApi.getInstance.getPostByDate(event.date);
        state.call(DataLoaded(list));
      }
      catch(e){
        state.call(DataError(e.toString()));
      }
    });
  }
}

class DataFetchBloc4 extends Bloc<DataEvent,DataState>{
  DataFetchBloc4(): super(DataInitial()){
    on<FetchData2>((event,state) async {
      // state.call(DataLoading());
      try{
        List<PostModal> list= await MyApi.getInstance.getPostByDate(event.date);
        state.call(DataLoaded(list));
      }
      catch(e){
        state.call(DataError(e.toString()));
      }
    });
  }
}

class FeaturedDataFetchCubit extends Cubit<DataState>{
  FeaturedDataFetchCubit(): super(DataInitial());

  Future<void> fetchFeaturedPosts() async {
    emit(DataLoading());
    try{
      List<PostModal> list= await MyApi.getInstance.getFeatured();
      if(!isClosed) {
        emit(DataLoaded(list));
      }
    }
    catch(e){
      if(!isClosed) {
        emit(DataError(e.toString()));
      }
    }
  }
}

class CategoriesFetchCubit extends Cubit<DataState>{
  CategoriesFetchCubit(): super(DataInitial());

  Future<void> loadCategories() async {
    try{
      List<CategoryModal> list= await MyApi.getInstance.getCategories();
      emit(CategoriesLoaded(list));
    }
    catch(e){
      emit(DataError(e.toString()));
    }
  }
}

class CategoryPostCubit extends Cubit<CategoryPostState>{
  CategoryPostCubit(): super(CategoryPostInitial());
  bool _hasReachedMax=false;
  int index=-1;

  void toggleCategory(CategoryModal cM,int index){
    if(this.index==index){
      this.index=-1;
      emit(CategoryPostInitial());
    }
    else{
      this.index=index;
      // emit(CategoryPostLoading(index));
      loadPostByCategory(cM, index);
    }
  }
  Future<void> loadPostByCategory(CategoryModal cM, int index) async {
    if(_hasReachedMax) return;
    emit(CategoryPostLoading(index));
    List<PostModal> oldList= state is CategoryPostLoaded? (state as CategoryPostLoaded).list : [];
    String id= cM.id;
    try{
      List<PostModal> postList=await MyApi.getInstance.getVideosByCategory('-1',id,oldList.length);
      if(postList.isEmpty){
        _hasReachedMax=true;
      }
      else{
        oldList.addAll(postList);
      }
      emit(CategoryPostLoaded(oldList,index,_hasReachedMax));
    }
    catch(e){
      // emit(DataError(e.toString()));
    }
  }
}

