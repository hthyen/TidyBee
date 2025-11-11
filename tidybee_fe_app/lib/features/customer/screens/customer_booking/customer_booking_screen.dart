import 'package:flutter/material.dart';
import 'package:tidybee_fe_app/core/common_services/utils_method.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';
import 'package:tidybee_fe_app/features/customer/model/booking.dart';
import 'package:tidybee_fe_app/features/customer/services/booking_services.dart';

class CustomerBookingScreen extends StatefulWidget {
  final String token;

  const CustomerBookingScreen({super.key, required this.token});

  @override
  State<CustomerBookingScreen> createState() => _CustomerBookingScreenState();
}

class _CustomerBookingScreenState extends State<CustomerBookingScreen> {
  final BookingServices _bookingServices = BookingServices();

  late Future<List<Booking>> _userBookingFuture;

  @override
  void initState() {
    super.initState();
    // Get active order
    _userBookingFuture = _bookingServices.getUserBooking(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      // Appbar
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          "Yêu cầu lịch giúp",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),

      body: FutureBuilder<List<Booking>>(
        future: _userBookingFuture,
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi tải dữ liệu: ${snapshot.error}"));
          }

          final userBooking = snapshot.data;

          // Dont have booking
          if (userBooking == null || userBooking.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.hourglass_empty, size: 60, color: Colors.orange),

                  SizedBox(height: 16),

                  Text(
                    "Bạn chưa có yêu cầu nào",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Have order
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: userBooking.length,
            itemBuilder: (context, index) {
              final booking = userBooking[index];
              final address =
                  booking.serviceLocation?.address ?? "Không rõ địa chỉ";
              final notes = booking.customerNotes ?? "Không có ghi chú";

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 3,

                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        booking.title ?? "Không có tiêu đề",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      //Description
                      Text(
                        booking.description ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black54),
                      ),

                      const SizedBox(height: 8),

                      // User notes
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.notes,
                            color: Colors.blueGrey,
                            size: 18,
                          ),

                          const SizedBox(width: 4),

                          Expanded(
                            child: Text(
                              notes,
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Address
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.redAccent,
                            size: 18,
                          ),

                          const SizedBox(width: 4),

                          Expanded(
                            child: Text(
                              address,
                              style: const TextStyle(color: Colors.black87),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Time
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: Colors.blueAccent,
                            size: 18,
                          ),

                          const SizedBox(width: 6),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Start
                                Text(
                                  "Bắt đầu: ${UtilsMethod.formatDate(booking.scheduledStartTime?.toIso8601String() ?? '')}",
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 13,
                                  ),
                                ),

                                // End
                                Text(
                                  "Kết thúc: ${UtilsMethod.formatDate(booking.scheduledEndTime?.toIso8601String() ?? '')}",
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Price
                      Row(
                        children: [
                          const Icon(
                            Icons.attach_money,
                            color: Colors.green,
                            size: 18,
                          ),

                          const SizedBox(width: 4),

                          Text(
                            UtilsMethod.formatMoney(
                              booking.estimatedPrice ?? 0,
                            ),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      if (booking.helperId == null)
                        Row(
                          children: const [
                            Icon(
                              Icons.person_outline,
                              color: Colors.orange,
                              size: 20,
                            ),

                            SizedBox(width: 6),

                            Text(
                              "Vui lòng chọn nhân viên",
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
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
}
