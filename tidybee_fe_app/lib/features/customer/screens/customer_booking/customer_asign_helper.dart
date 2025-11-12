import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tidybee_fe_app/core/common_services/utils_method.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';
import 'package:tidybee_fe_app/features/customer/model/booking.dart';
import 'package:tidybee_fe_app/features/customer/model/helper.dart';
import 'package:tidybee_fe_app/features/customer/services/booking_services.dart';
import 'package:tidybee_fe_app/features/customer/services/helper_services.dart';

class CustomerAsignHelper extends StatefulWidget {
  final Booking booking;
  final String token;

  const CustomerAsignHelper({
    super.key,
    required this.booking,
    required this.token,
  });

  @override
  State<CustomerAsignHelper> createState() => _CustomerAsignHelperState();
}

class _CustomerAsignHelperState extends State<CustomerAsignHelper> {
  final HelperServices _helperServices = HelperServices();
  final BookingServices _bookingService = BookingServices();
  late Future<List<Helper>> _futureHelper;

  @override
  void initState() {
    super.initState();
    _fetchEligibleHelpers();
  }

  // Fetch Eligible Helpers
  void _fetchEligibleHelpers() async {
    _futureHelper = _helperServices.getEligibleHelpers(
      widget.booking.bookingId ?? "",
      widget.token,
    );

    print(_futureHelper);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar
      appBar: AppBar(
        title: const Text(
          "Lựa chọn nhân viên",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),

      body: FutureBuilder<List<Helper>>(
        future: _futureHelper,
        builder: (context, snapshot) {
          // Icon when waiting for loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Lỗi tải dữ liệu: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final helpers = snapshot.data ?? [];

          if (helpers.isEmpty) {
            return const Center(
              child: Text(
                "Không có nhân viên phù hợp",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // Render helper UI
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: helpers.length,
            itemBuilder: (context, index) {
              final helper = helpers[index];
              final rating = helper.rating ?? 0.0;

              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _showConfirmationDialog(helper),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    // Avatar name
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.primary.withOpacity(0.15),
                      child: Text(
                        (helper.helperName != null &&
                                helper.helperName!.isNotEmpty)
                            ? helper.helperName![0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),

                    // Helper name
                    title: Text(
                      helper.helperName ?? "Không tên",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),

                        // Helper Rating
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber[600],
                              size: 18,
                            ),

                            const SizedBox(width: 4),

                            // Helper rating
                            Text(
                              "$rating (${helper.totalRatings} đánh giá)",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        // Helper price
                        Text(
                          "Giá: ${UtilsMethod.formatMoney(helper.pricePerHour ?? 0)}/giờ",
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Helper address
                        Text(
                          helper.location?.address ?? "Không rõ địa chỉ",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Dialog confirm
  void _showConfirmationDialog(Helper helper) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        // Title
        title: const Text(
          "Xác nhận lựa chọn",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        // Content
        content: Text(
          "Bạn có chắc muốn chọn nhân viên ${helper.helperName} không?",
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          // Cancel btn
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Hủy",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          // Confirm btn
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              final booking = await _bookingService.assignHelperToBooking(
                bookingId: widget.booking.bookingId ?? "",
                helperId: helper.helperId ?? "",
                token: widget.token,
              );

              if (booking != null) {
                context.go(
                  "/customer-confirm-booking",
                  extra: {"token": widget.token, "booking": widget.booking},
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Lỗi chọn nhân viên"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text(
              "Xác nhận",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
