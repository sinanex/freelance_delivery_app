class ShopModel {
  final String shopname;
  final String location;
 String? id;
  ShopModel({this.id,required this.location, required this.shopname});

  factory ShopModel.fromJson(Map<String, dynamic> json,String id) {
    return ShopModel(location:json['location'], shopname: json['shopname'],id: id);
  }

  Map<String,dynamic>toJson(){
    return {
      'shopname':shopname,
      'location':location
    };
  }
}
