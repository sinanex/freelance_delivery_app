import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:gas/controller/data_controller.dart';
import 'package:gas/model/shop_model.dart';
import 'package:gas/view/details/add_details.dart';
import 'package:gas/view/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatefulWidget {
  final ShopModel data;
  const DetailsScreen({super.key, required this.data});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DataController>().getAllDAta(
      widget.data.shopname,
      widget.data.location,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.data.shopname,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on, color: Colors.white70, size: 16),
                  SizedBox(width: 4),
                  Text(
                    widget.data.location,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
        toolbarHeight: 80,
        actions: [
          IconButton(
            onPressed: () async {
              final Uri phoneUri = Uri.parse("tel:+91${widget.data.phone}");
              if (await canLaunchUrl(phoneUri)) {
                await launchUrl(phoneUri);
              } else {
                log("Could not launch phone call");
              }
            },
            icon: Icon(Icons.phone),
          ),
          IconButton(
            onPressed: () async {
              final result = await showCalendarDatePicker2Dialog(
                value: [],
                context: context,
                config: CalendarDatePicker2WithActionButtonsConfig(
                  calendarType: CalendarDatePicker2Type.range,
                ),
                dialogSize: Size(MediaQuery.of(context).size.width * 0.8, 400),
              );

              if (result != null) {}
            },
            icon: Icon(Icons.calendar_month),
          ),
        ],
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 247, 196, 69),
      ),
      body: Consumer<DataController>(
        builder:
            (context, value, child) =>
                value.isLoading
                    ? Center(
                      child: Container(
                        color: Colors.white,
                        child: CircularProgressIndicator(),
                      ),
                    )
                    : Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 16, top: 10),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0XFFFFBF1B),
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => AddDetails(
                                          shopname: widget.data.shopname,
                                          location: widget.data.location,
                                        ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.add),
                              label: Text("ADD"),
                            ),
                          ),
                        ),
                        _buildDataList(),
                        _buildBottomContainer(),
                      ],
                    ),
      ),
    );
  }

  Widget _buildDataList() {
    return Expanded(
      child: Consumer<DataController>(
        builder: (context, value, child) {
          if (value.allData.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No data available',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add new entries using the button below',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: value.allData.length,
            itemBuilder: (context, index) {
              final data = value.allData[index];
              final int fullGas = int.parse(data.fullGas);
              final int emptyGas = int.parse(data.emptygas);

              final int amount = int.parse(data.amount);
              final int receipt = int.parse(data.recipt);
              final int ob = receipt - amount;
              final String type = data.type;

              return Card(
                color: Colors.white,
                elevation: 2,
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data.date,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blue[800],
                            ),
                          ),

                          Text(
                            type,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                      Divider(height: 24),
                      _buildInfoRow(
                        'Full Gas',
                        fullGas.toString(),
                        Icons.arrow_upward_rounded,
                        Colors.green,
                      ),
                      _buildInfoRow(
                        'Empty Gas',
                        emptyGas.toString(),
                        Icons.arrow_downward_rounded,
                        Colors.red,
                      ),
                      SizedBox(height: 16),
                      _buildInfoRow(
                        'Amount',
                        '₹${amount.toString()}',
                        Icons.payments_outlined,
                        Colors.blue,
                      ),
                      _buildInfoRow(
                        'Receipt',
                        '₹${receipt.toString()}',
                        Icons.receipt_long_outlined,
                        Colors.purple,
                      ),
                      _buildInfoRow(
                        'Outstanding Balance',
                        '₹${ob.toString()}',
                        Icons.account_balance_wallet_outlined,
                        ob > 0 ? Colors.green : Colors.red,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(width: 8),
          Text(
            '$label:',
            style: TextStyle(fontSize: 15, color: Colors.grey[600]),
          ),
          SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomContainer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, -3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Consumer<DataController>(
        builder: (context, dataController, child) {
          int totalAmount = 0;
          int totalReceipt = 0;
          int totalGasBalance = 0;

          for (var data in dataController.allData) {
            totalAmount += int.parse(data.amount);
            totalReceipt += int.parse(data.recipt);
            totalGasBalance +=
                (int.parse(data.fullGas) - int.parse(data.emptygas));
          }

          int outstandingBalance = totalReceipt - totalAmount;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Summary",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    IconButton(onPressed: (){
                      gasSummaryUpdate(context);
                    }, icon: Icon(Icons.edit,color: Colors.blue,))
                  ],
                ),
              ),
              Row(
                children: [
                  _buildSummaryItem(
                    "Total Amount",
                    "₹$totalAmount",
                    Icons.payments_outlined,
                    Colors.blue,
                  ),
                  _buildSummaryItem(
                    "Total Received",
                    "₹$totalReceipt",
                    Icons.receipt_long_outlined,
                    Colors.purple,
                  ),
                  _buildSummaryItem(
                    "Outstanding",
                    "₹$outstandingBalance",
                    Icons.account_balance_wallet_outlined,
                    outstandingBalance >= 0 ? Colors.green : Colors.red,
                  ),
                ],
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.gas_meter_outlined, color: Colors.blue[700]),
                    SizedBox(width: 8),
                    Text(
                      "Total Gas Balance: ",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "$totalGasBalance",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            totalGasBalance >= 0
                                ? Colors.green[700]
                                : Colors.red[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
  

}
