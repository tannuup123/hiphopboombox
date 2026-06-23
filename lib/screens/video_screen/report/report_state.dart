abstract class ReportState{}

class OptionSelected extends ReportState{
  final String value;

  OptionSelected(this.value);
}
