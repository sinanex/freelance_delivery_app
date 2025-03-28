class ShopModel {
  final String shopname;
  final String location;
 String? id;
 final String phone;
  ShopModel({this.id,required this.location, required this.shopname,required this.phone});

  factory ShopModel.fromJson(Map<String, dynamic> json,String id) {
    return ShopModel(phone: json['phone'],
      location:json['location'], shopname: json['shopname'],id: id);
  }

  Map<String,dynamic>toJson(){
    return {
      'phone':phone,
      'shopname':shopname,
      'location':location
    };
  }
}
