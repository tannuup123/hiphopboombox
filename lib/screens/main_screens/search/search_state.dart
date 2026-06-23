import '../../../modal/postmodal.dart';

abstract class SearchState{}

class SearchInitial extends SearchState{}
class SearchLoading extends SearchState{}
class SearchLoaded extends SearchState{
  final List<PostModal> list;

  SearchLoaded(this.list);
}

class RecentLoaded extends SearchState{
  final List<String> list;

  RecentLoaded(this.list);
}