import 'package:flutter/material.dart';
import 'package:tidybee_fe_app/core/common_services/utils_method.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';
import 'package:tidybee_fe_app/features/customer/model/booking.dart';
import 'package:tidybee_fe_app/features/customer/services/booking_services.dart';
import 'package:tidybee_fe_app/features/customer/widgets/confirm_booking_widgets/payment_method_section.dart';

class CustomerConfirmBooking extends StatefulWidget {
  final Booking booking;
  final String token;

  const CustomerConfirmBooking({
    super.key,
    required this.booking,
    required this.token,
  });

  @override
  State<CustomerConfirmBooking> createState() => _CustomerConfirmBookingState();
}

class _CustomerConfirmBookingState extends State<CustomerConfirmBooking> {
  final BookingServices _bookingService = BookingServices();
  late Future<Booking> _futureBooking;
  bool payWithVisa = true;
  String paymentMethod = "SEPAY";

  @override
  void initState() {
    super.initState();
    _fetchBookingById();
  }

  // Method to fetch booking by id
  void _fetchBookingById() async {
    _futureBooking = _bookingService.getUserBookingById(
      widget.token,
      widget.booking.bookingId ?? "",
    );
  }

  // Method to payment
  void _handleConfirmOrder() async {}

  // Map status into text and color
  Map<String, dynamic> _getStatusDisplay(int status) {
    switch (status) {
      case 1:
        return {"text": "Chờ xác nhận", "color": Colors.orange};
      case 2:
        return {"text": "Chờ nhân viên chấp nhận", "color": Colors.blue};
      case 3:
        return {"text": "Đã chấp nhận", "color": Colors.green};
      case 4:
        return {"text": "Đang thực hiện", "color": Colors.purple};
      case 5:
        return {"text": "Hoàn thành", "color": Colors.teal};
      case 6:
        return {"text": "Đã hủy", "color": Colors.red};
      case 7:
        return {"text": "Từ chối", "color": Colors.grey};
      default:
        return {"text": "Không xác định", "color": Colors.black45};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fb),
      // Appbar
      appBar: AppBar(
        title: const Text(
          "Xác nhận yêu cầu",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: FutureBuilder<Booking>(
        future: _futureBooking,
        // Loading
        builder: (context, snapshot) {
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

          final booking = snapshot.data;
          if (booking == null) {
            return const Center(
              child: Text(
                "Không tìm thấy thông tin đơn đặt.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final location = booking.serviceLocation;
          final status = _getStatusDisplay(booking.status ?? 0);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Information
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  shadowColor: AppColors.primary.withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Service title
                        Text(
                          booking.title ?? "Không có tiêu đề",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Service description
                        Text(
                          booking.description ?? "Không có mô tả",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Service status
                        Row(
                          children: [
                            Chip(
                              backgroundColor: (status['color'] as Color)
                                  .withOpacity(0.15),
                              label: Text(
                                status['text'],
                                style: TextStyle(
                                  color: status['color'],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Time information
                _buildInfoCard("Thời gian thực hiện", [
                  // Service start time
                  _buildInfoRow(
                    Icons.access_time,
                    "Bắt đầu:",
                    UtilsMethod.formatDate(
                      booking.scheduledStartTime?.toIso8601String() ?? '',
                    ),
                  ),

                  // Service end time
                  _buildInfoRow(
                    Icons.access_time,
                    "Kết thúc:",
                    UtilsMethod.formatDate(
                      booking.scheduledEndTime?.toIso8601String() ?? '',
                    ),
                  ),

                  // Service price
                  _buildInfoRow(
                    Icons.attach_money,
                    "Giá đơn hàng:",
                    "${UtilsMethod.formatMoney(booking.estimatedPrice ?? 0)}",
                    valueColor: AppColors.primary,
                  ),
                ]),

                const SizedBox(height: 16),

                //Customer address
                _buildInfoCard("Địa điểm thực hiện", [
                  _buildInfoRow(
                    Icons.location_on,
                    "Địa chỉ:",
                    location != null
                        ? "${location.address}, ${location.ward}, ${location.district}, ${location.city}"
                        : "Không rõ địa chỉ",
                  ),
                ]),

                const SizedBox(height: 16),

                // Helper name
                _buildInfoCard("Nhân viên phụ trách", [
                  _buildInfoRow(
                    Icons.person,
                    "Tên nhân viên:",
                    booking.helperName ?? "Chưa có nhân viên",
                    valueColor: AppColors.primary,
                  ),
                ]),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),

      // PaymentSection
      bottomNavigationBar: PaymentSection(
        payWithVisa: payWithVisa,
        onChanged: (value) {
          setState(() {
            payWithVisa = value;
            paymentMethod = value ? "SEPAY" : "CASH";
          });
        },
        onConfirm: _handleConfirmOrder,
      ),
    );
  }

  // --- Widget: card information ---
  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  // --- Widget: row information ---
  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? Colors.black87,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
