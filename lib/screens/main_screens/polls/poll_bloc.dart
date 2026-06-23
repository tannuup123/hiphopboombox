import 'package:boombox/backend/api.dart';
import 'package:boombox/modal/poll_modal.dart';
import 'package:boombox/screens/main_screens/polls/poll_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PollCubit extends Cubit<PollState>{
  PollCubit():super(PollInitial());

  Future<void> fetchPoll() async {
    emit(PollLoading());
    List<PollModal> list= await MyApi.getInstance.getPoll();
    emit(PollLoaded(list));
  }

}

class VoteCubit extends Cubit<VoteState>{
  VoteCubit():super(VoteSelected(-1, -1));
  int _selectedIndex=-1;
  String? _pollId;
  String? _optionId;


  Future<void> optionSelected(int optionIndex,String pollId,String optionId) async {
    _selectedIndex=optionIndex;
    _pollId=pollId;
    _optionId=optionId;
    emit(VoteSelected(optionIndex, -1));
  }

  Future<void> optionSubmitted() async {
    emit(VoteSelected(_selectedIndex, _selectedIndex));
    await MyApi.getInstance.updateVote(_pollId!, _optionId!);
    await MyApi.getInstance.insertUserSubmittedPoll(_pollId!);
  }

}