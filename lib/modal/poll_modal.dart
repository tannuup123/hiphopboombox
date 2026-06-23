import '../backend/api.dart';

class PollModal{
  final QuestionModal questionModal;
  final List<OptionsModal> optionList;

  PollModal(this.questionModal, this.optionList);
}

class QuestionModal{
  final String pollId;
  final String portraitImage;
  final String landscapeImage;
  final String question;
  final String answer;

  QuestionModal.fromJson(Map<String,dynamic> json):
      pollId=json['id'],
      portraitImage='${MyApi.imgUrl}/${json['portrait_image']}',
      landscapeImage='${MyApi.imgUrl}/${json['landscape_img']}',
      question=json['question'],
      answer=json['answer'];
}

class OptionsModal{
  final String optionId;
  final String pollId;
  final String optionText;
  final String votes;
  final String date;

  OptionsModal.fromJson(Map<String, dynamic> json):
      optionId=json['id'],
      pollId=json['poll_id'],
      optionText=json['option_text'],
      votes=json['votes'],
      date=json['date'];
}