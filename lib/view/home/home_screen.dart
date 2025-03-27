import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gas/controller/data_controller.dart';
import 'package:gas/model/shop_model.dart';
import 'package:gas/view/details/details_screen.dart';
import 'package:gas/services/data_services.dart';
import 'package:gas/view/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController shopnameController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<DataController>().getData());
  }

  @override
  void dispose() {
    shopnameController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddShopDialog(context),
        icon: const Icon(Icons.add_business_rounded),
        label: const Text('Add Shop'),
        backgroundColor: Color(0XFFFFBF1B),
        elevation: 4,
      ),
      appBar: AppBar(
        backgroundColor: Color(0XFFFFBF1B),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<DataController>().getData(),
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Consumer<DataController>(
            builder:
                (context, provider, child) => StandardSearchBar(
                  onChanged: (value) {
                    provider.searchShops(value);
                  },
                ),
          ),
          _buildShopList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildShopList() {
    return Expanded(
      child: Consumer<DataController>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0XFFFFBF1B)),
                  const SizedBox(height: 16),
                  Text(
                    'Loading shops...',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            );
          }

          if (value.shopdata.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.abc, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No shops available',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add a new shop using the button below',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: value.filterShopDAta.length,
            itemBuilder: (context, index) {
              final shop = value.filterShopDAta[index];
              return _buildShopCard(shop);
            },
          );
        },
      ),
    );
  }

  Widget _buildShopCard(ShopModel shop) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailsScreen(data: shop)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.shopname,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          shop.location,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddShopDialog(BuildContext context) {
    shopnameController.clear();
    locationController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.add_business, color: Colors.blue[700]),
              const SizedBox(width: 8),
              const Text("Add New Shop"),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                customTextField(
                  text: 'Shop Name',
                  controller: shopnameController,
                ),
                const SizedBox(height: 16),
                customTextField(
                  text: 'Location',
                  controller: locationController,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[700])),
            ),
            ElevatedButton(
              onPressed: () {
                if (shopnameController.text.trim().isNotEmpty &&
                    locationController.text.trim().isNotEmpty) {
                  final data = ShopModel(
                    location: locationController.text.trim(),
                    shopname: shopnameController.text.trim(),
                  );
                  DataServices().addShop(data: data);
                  Navigator.pop(context);

                  // Show success snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Shop "${shopnameController.text.trim()}" added successfully',
                      ),
                      backgroundColor: Colors.green[600],
                      behavior: SnackBarBehavior.floating,
                      action: SnackBarAction(
                        label: 'REFRESH',
                        textColor: Colors.white,
                        onPressed:
                            () => context.read<DataController>().getData(),
                      ),
                    ),
                  );

                  Future.delayed(const Duration(milliseconds: 500), () {
                    context.read<DataController>().getData();
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0XFFFFBF1B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              child: const Text('Add Shop'),
            ),
          ],
        );
      },
    );
  }
}
