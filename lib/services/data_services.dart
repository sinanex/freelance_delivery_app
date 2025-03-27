import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas/model/model.dart';
import 'package:gas/model/shop_model.dart';

class DataServices {
  final shopdata = FirebaseFirestore.instance.collection('shop');
  final alldata = FirebaseFirestore.instance.collection('data');

  Future<List<Model>> getDataFromFireBase({required String shopname,required String location}) async {
    log(location.toString());
    try {
      final QuerySnapshot snapshot = await alldata.doc(shopname).collection('alldata').where('location',isEqualTo: location).get();
      return snapshot.docs
          .map(
            (doc) => Model.fromJson(doc.data() as Map<String, dynamic>, doc.id),
          )
          .toList();
    } catch (e) {
      log("Error Fetching Data: $e");
      throw Exception("Error Fetching Data");
    }
  }

  void addShop({required ShopModel data}) async {
    try {
      await shopdata.add(data.toJson());
      log('successs');
    } on FirebaseException catch (e) {
      log(e.toString());
    }
  }

  void addAllData({required String shopname, required Model data}) async {
    try {
      await alldata.doc(shopname).collection('alldata').add(data.toJSon());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<ShopModel>> getShopDAta() async {
    try {
      final QuerySnapshot snapshot = await shopdata.get();
      return snapshot.docs
          .map(
            (json) => ShopModel.fromJson(
              json.data() as Map<String, dynamic>,
              json.id,
            ),
          )
          .toList();
    } catch (e) {
      log(e.toString());
    }
    throw Exception('error');
  }


}
