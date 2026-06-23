abstract class BottomEvent{}

class SelectEvent extends BottomEvent{
  final int index;
  SelectEvent(this.index);
}