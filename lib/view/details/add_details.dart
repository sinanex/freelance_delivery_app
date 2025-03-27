import 'package:flutter/material.dart';
import 'package:gas/controller/data_controller.dart';
import 'package:gas/controller/date_controller.dart';
import 'package:gas/model/model.dart';
import 'package:gas/services/data_services.dart';
import 'package:provider/provider.dart';

class AddDetails extends StatefulWidget {
  final String shopname;
  final String location;

  const AddDetails({super.key, required this.shopname, required this.location});

  @override
  State<AddDetails> createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails> {
  final TextEditingController emptyGasController = TextEditingController();
  final TextEditingController fullGasController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController receiptController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  final Color themeColor = Color(0XFFFFBF1B);

  @override
  void dispose() {
    emptyGasController.dispose();
    fullGasController.dispose();
    amountController.dispose();
    receiptController.dispose();
    super.dispose();
  }

  void _submitData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      DataServices().addAllData(
        shopname: widget.shopname,
        data: Model(
          location: widget.location,
          shopname: widget.shopname,
          date: context.read<DataController>().dateController.text.trim(),
          amount: amountController.text.trim(),
          recipt: receiptController.text.trim(),
          fullGas: fullGasController.text.trim(),
          emptygas: emptyGasController.text.trim(),
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data added successfully'),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding data: $e'),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String? _validateNumeric(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    if (int.tryParse(value) == null) {
      return '$fieldName must be a number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        
        backgroundColor: themeColor,
        elevation: 0,
        title: Text(
          'Add Transaction',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildHeader(), _buildForm()],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.shopname,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add new transaction details',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    List<String> types = ['Bharath Gas', 'Green Gas', 'Go Gas'];
    return Container(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Date Information'),
            SizedBox(height: 16),
            TextFormField(
              controller: context.watch<DataController>().dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Transaction Date',
                hintText: 'Select date',
                prefixIcon: Icon(Icons.calendar_today, color: themeColor),
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_month, color: themeColor),
                  onPressed:
                      () => context.read<DataController>().pickDate(context),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: themeColor, width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a date';
                }
                return null;
              },
            ),

            SizedBox(height: 24),
            _buildSectionTitle('Gas Information'),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: fullGasController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration(
                      'Full Gas',
                      Icons.add_circle_outline,
                    ),
                    validator: (value) => _validateNumeric(value, 'Full gas'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: emptyGasController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration(
                      'Empty Gas',
                      Icons.remove_circle_outline,
                    ),
                    validator: (value) => _validateNumeric(value, 'Empty gas'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Consumer<DateController>(
              builder:
                  (context, dateController, child) =>
                      DropdownButtonFormField<String>(
                        value: dateController.selected,
                        decoration: InputDecoration(
                          labelText: 'Gas Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: themeColor, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.red, width: 1),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                        ),
                        hint: Text('Select Gas Type'),
                        icon: Icon(Icons.arrow_drop_down, color: themeColor),
                        dropdownColor: Colors.white,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        isExpanded: true,
                        items:
                            ['Bharath Gas', 'Green Gas', 'Go Gas'].map((
                              String value,
                            ) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }).toList(),
                        onChanged: (newValue) {
                          dateController.changeDropDownValue(newValue ?? '');
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a gas type';
                          }
                          return null;
                        },
                      ),
            ),

            SizedBox(height: 24),
            _buildSectionTitle('Financial Information'),
            SizedBox(height: 16),
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration('Amount', Icons.attach_money),
              validator: (value) => _validateNumeric(value, 'Amount'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: receiptController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration('Receipt', Icons.receipt_long),
              validator: (value) => _validateNumeric(value, 'Receipt'),
            ),

            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child:
                    _isSubmitting
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('Submitting...'),
                          ],
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save),
                            SizedBox(width: 8),
                            Text(
                              'Save Transaction',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Text('Cancel', style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: themeColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: themeColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: themeColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red, width: 1),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    );
  }
}
