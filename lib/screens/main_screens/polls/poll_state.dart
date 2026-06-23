import 'package:boombox/modal/poll_modal.dart';

abstract class PollState {}

class PollInitial extends PollState{}
class PollLoading extends PollState{}

class PollLoaded extends PollState{
  final List<PollModal> list;

  PollLoaded(this.list);
}

class PollError extends PollState{}

abstract class VoteState {}

class VoteSelected extends VoteState{
  final int selectedIndex;
  final int submittedIndex;

  VoteSelected(this.selectedIndex, this.submittedIndex);
}