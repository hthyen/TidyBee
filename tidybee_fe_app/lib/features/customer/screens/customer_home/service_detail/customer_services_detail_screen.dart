import 'package:flutter/material.dart';
import 'package:tidybee_fe_app/core/common_services/format_money.dart';
import 'package:tidybee_fe_app/core/common_services/location.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';
import 'package:tidybee_fe_app/features/customer/screens/customer_home/service_detail/address_section.dart';
import 'package:tidybee_fe_app/features/customer/screens/customer_home/service_detail/note_section.dart';
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
  // ignore: unused_field
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

              // ==== Note section ====
              NoteSection(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      // Section booking
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        // Decoration
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),

        child: SafeArea(
          child: Row(
            children: [
              // Left side (Money)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    const Text(
                      "Tổng tiền",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),

                    const SizedBox(height: 4),

                    // Title money
                    Text(
                      "${UtilsMethod.formatMoney(double.parse(widget.price))}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // Button order
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã đặt dịch vụ!')),
                  );
                },

                // Text
                child: const Text(
                  "Đặt dịch vụ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
