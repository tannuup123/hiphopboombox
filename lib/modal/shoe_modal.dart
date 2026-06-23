import 'package:boombox/backend/api.dart';

class ShoeModal {
  String id;
  String title;
  String? primarySize;
  String? gender;
  String description;
  String retailPrice;
  String resellPrice;
  String brand;
  String logo;
  String date;
  String image1;
  String image2;
  String image3;
  String image4;
  String image5;

  factory ShoeModal.fromJson(Map<String, dynamic> json, String primarySize,String gender) {

    return ShoeModal(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      primarySize: primarySize,
      gender: gender,
      description: json['description'] ?? '',
      retailPrice: json['retail_price'] ?? '',
      resellPrice: json['resell_price'] ?? '',
      brand: json['brand'] ?? '',
      logo: "${MyApi.imgUrl}/${json['logo']}",
      date: json['date'] ?? '',
      image1: "${MyApi.imgUrl}/${json['image1']}",
      image2: "${MyApi.imgUrl}/${json['image2']}",
      image3: "${MyApi.imgUrl}/${json['image3']}",
      image4: "${MyApi.imgUrl}/${json['image4']}",
      image5: "${MyApi.imgUrl}/${json['image5']}",
    );
  }

  ShoeModal({
    required this.id,
    required this.title,
    this.primarySize,
    this.gender,
    required this.description,
    required this.retailPrice,
    required this.resellPrice,
    required this.brand,
    required this.logo,
    required this.date,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.image4,
    required this.image5,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'primary_size': title,
      'gender': gender,
      'description': description,
      'retail_price': retailPrice,
      'resell_price': resellPrice,
      'brand': brand,
      'logo': logo,
      'date': date,
      'image1': image1,
      'image2': image2,
      'image3': image3,
      'image4': image4,
      'image5': image5,
    };
  }
}
