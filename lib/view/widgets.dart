import 'package:flutter/material.dart';

Widget customTextField({
  required String text,
  required TextEditingController controller,
  String? labelText,
  IconData? prefixIcon,
  IconData? suffixIcon,
  VoidCallback? onSuffixIconPressed,
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,
  String? Function(String?)? validator,
  FocusNode? focusNode,
  bool? readOnly,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: TextFormField(
      readOnly: readOnly ?? false,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      focusNode: focusNode,
      validator: validator,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: text,
        labelText: labelText,
        prefixIcon:
            prefixIcon != null
                ? Icon(prefixIcon, color: Colors.blue.shade700)
                : null,
        suffixIcon:
            suffixIcon != null
                ? IconButton(
                  icon: Icon(suffixIcon, color: Colors.blue.shade700),
                  onPressed: onSuffixIconPressed,
                )
                : null,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    ),
  );
}

Widget customElevatedButton({
  required VoidCallback onPressed,
  required String text,
  IconData? icon,
  Color backgroundColor = Colors.blue,
  Color textColor = Colors.white,
  double width = double.infinity,
  double height = 50,
  bool isLoading = false,
  BorderRadius? borderRadius,
}) {
  return Container(
    width: width,
    height: height,
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(12),
        ),
        elevation: 3,
        shadowColor: backgroundColor.withOpacity(0.5),
      ),
      child:
          isLoading
              ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
              : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
    ),
  );
}

class StandardSearchBar extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final String hintText;

  const StandardSearchBar({
    Key? key,
    this.onChanged,
    this.onClear,
    this.hintText = 'Search...',
  }) : super(key: key);

  @override
  _StandardSearchBarState createState() => _StandardSearchBarState();
}

class _StandardSearchBarState extends State<StandardSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon:
              _searchController.text.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      widget.onClear?.call();
                      widget.onChanged?.call('');
                      setState(() {});
                    },
                  )
                  : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
        ),
        onChanged: (value) {
          setState(() {});
          widget.onChanged?.call(value);
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Example Usage in a Widget
class SearchBarExample extends StatelessWidget {
  const SearchBarExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Bar Demo')),
      body: Column(
        children: [
          StandardSearchBar(
            hintText: 'Search items...',
            onChanged: (value) {
              // Handle search text changes
              print('Search value: $value');
            },
            onClear: () {
              // Handle search clear
              print('Search cleared');
            },
          ),
        ],
      ),
    );
  }
}

void gasSummaryUpdate(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(backgroundColor: Colors.white, actions: [
          
        ],
      );
    },
  );
}
