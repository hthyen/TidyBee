import 'package:flutter/material.dart';
import 'package:tidybee_fe_app/core/common_services/location.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';

class CustomerServicesDetailScreen extends StatefulWidget {
  final String title;
  final IconData icon;

  const CustomerServicesDetailScreen({
    super.key,
    required this.title,
    required this.icon,
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
            Icon(widget.icon, color: Colors.black),

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

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Address
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
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
                                _currentAddress ??
                                    "Không xác định được địa chỉ",
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
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                          ),
                          onPressed: _fetchCurrentAddress,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
