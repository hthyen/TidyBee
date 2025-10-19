import 'package:flutter/material.dart';

class AddressSection extends StatefulWidget {
  final String? initialAddress;

  const AddressSection({super.key, required this.initialAddress});

  @override
  State<AddressSection> createState() => _AddressSectionState();
}

class _AddressSectionState extends State<AddressSection> {
  String? _currentAddress;

  @override
  void initState() {
    super.initState();
    _currentAddress = widget.initialAddress;
  }

  @override
  void didUpdateWidget(AddressSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialAddress != widget.initialAddress) {
      setState(() {
        _currentAddress = widget.initialAddress;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Address ui
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon
          const Icon(Icons.location_on, color: Colors.blueAccent),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text address
                Text(
                  _currentAddress ?? "Không xác định được địa chỉ",
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    height: 1.0,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Add address description
                const Text(
                  "Thêm mô tả địa chỉ",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    height: 1.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Button to edit address
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
