import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gas/model/model.dart';
import 'package:gas/model/shop_model.dart';
import 'package:gas/services/data_services.dart';

class DataController extends ChangeNotifier {
  DataServices service = DataServices();
  final TextEditingController dateController = TextEditingController();
  bool isLoading = false;
  List<ShopModel> shopdata = [];
  List<Model> allData = [];
  List<ShopModel> filterShopDAta = [];
  DateTime? _selectedDate;

  DateTime? get selectedDate => _selectedDate;

  void getData() async {
    isLoading = true;
    notifyListeners();
    try {
      shopdata = await service.getShopDAta();
      filterShopDAta = shopdata;
      log(shopdata.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void getAllDAta(String shopname, String location) async {
    isLoading = true;
    notifyListeners();
    try {
      allData = await service.getDataFromFireBase(
        shopname: shopname,
        location: location,
      );
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading = false;
    }
    notifyListeners();
  }

  void pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[700]!,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.blue[700]),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      _selectedDate = pickedDate;
      final formattedDate =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      dateController.text = formattedDate;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Showing entries for $formattedDate'),
          action: SnackBarAction(label: 'Clear Filter', onPressed: () {}),
        ),
      );
    }
  }

  void searchShops(String query) {
    log(query);
    if (query.isEmpty) {
      filterShopDAta = shopdata;
    } else {
      query = query.toLowerCase();

      filterShopDAta =
          shopdata.where((shop) {
            return shop.shopname.toLowerCase().contains(query) ||
                shop.location.toLowerCase().contains(query);
          }).toList();
    }
    log(filterShopDAta.toString());
    notifyListeners();
  }
}
