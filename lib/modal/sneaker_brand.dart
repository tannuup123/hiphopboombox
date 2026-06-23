class SneakerBrand{
  final String id;
  final String brand;

  SneakerBrand({required this.id, required this.brand});

  factory SneakerBrand.fromJson(Map<String,dynamic> json){
    return SneakerBrand(id: json['id'], brand: json['brand']);
  }
}