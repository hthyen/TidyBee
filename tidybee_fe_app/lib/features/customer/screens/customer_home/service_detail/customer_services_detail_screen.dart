import 'package:flutter/material.dart';
import 'package:tidybee_fe_app/core/common_services/location.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';
import 'package:tidybee_fe_app/features/customer/screens/customer_home/service_detail/address_section.dart';
import 'package:tidybee_fe_app/features/customer/screens/customer_home/service_detail/working_time_section.dart';

class CustomerServicesDetailScreen extends StatefulWidget {
  final String title;
  // final IconData icon;
  final String price;

  const CustomerServicesDetailScreen({
    super.key,
    required this.title,
    // required this.icon,
    required this.price,
  });

  @override
  State<CustomerServicesDetailScreen> createState() =>
      _CustomerServicesDetailScreenState();
}

class _CustomerServicesDetailScreenState
    extends State<CustomerServicesDetailScreen> {
  String? _currentAddress;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCurrentAddress();
  }

  //Method get current location
  Future<void> _fetchCurrentAddress() async {
    setState(() => _isLoading = true);

    try {
      // Call method getCurrentPosition
      final position = await LocationService.getCurrentPosition();
      if (position == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Vui lòng bật GPS hoặc cấp quyền truy cập"),
          ),
        );
        return;
      }

      // Call method getAddressFromPosition
      final address = await LocationService.getAddressFromPosition(position);
      setState(() {
        _currentAddress = address ?? "Không xác định được địa chỉ";
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể lấy vị trí hiện tại')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            // Icon(widget.icon, color: Colors.black),
            const SizedBox(width: 8),

            // Text
            Flexible(
              child: Text(
                widget.title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
                // maxLines: 1,
              ),
            ),

            // Text
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 16),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ==== Address section ====
              AddressSection(initialAddress: _currentAddress),

              const SizedBox(height: 12),

              // ==== Working time section ====
              WorkingTimeSection(price: widget.price),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
