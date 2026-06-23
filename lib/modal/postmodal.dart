import '../backend/api.dart';

class PostModal{
  String? id;
  String? title;
  String? des;
  String? portraitImage;
  String? landscapeImage;
  String? video;
  String? date;
  String? link;
  String? views;
  String? socialMedia;


  PostModal.fromJson(Map<String,dynamic> map):
        id= map['id'],
        title= map['title'],
        des= map['des'],
        portraitImage= "${MyApi.imgUrl}/${map['portrait_image']}",
        landscapeImage= "${MyApi.imgUrl}/${map['image']}",
        video= "${MyApi.imgUrl}/${map['video']}",
        date= map['date'],
        link= map['link'],
        views= map['views'],
        socialMedia= map['social_media'];



}
