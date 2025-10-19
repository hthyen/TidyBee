import 'package:flutter/material.dart';
import 'package:tidybee_fe_app/features/helper/model/booking_request.dart';
import 'package:tidybee_fe_app/features/helper/screens/helper_home/helper_home_viewmodel.dart';
import 'package:tidybee_fe_app/features/helper/services/booking_services.dart';

class HelperHomeScreen extends StatefulWidget {
  final String token;

  const HelperHomeScreen({super.key, required this.token});

  @override
  State<HelperHomeScreen> createState() => _HelperHomeScreenState();
}

class _HelperHomeScreenState extends State<HelperHomeScreen> {
  late Future<List<BookingRequest>> _bookingsFuture;

  @override
  void initState() {
    super.initState();

    final viewModel = HelperHomeViewModel(
      bookingService: BookingService(),
      token: widget.token,
    );

    _bookingsFuture = viewModel.fetchBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Công việc khả dụng',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<BookingRequest>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                '❌ Lỗi khi tải dữ liệu: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final bookings = snapshot.data ?? [];

          if (bookings.isEmpty) {
            return const Center(
              child: Text(
                'Không có công việc nào khả dụng.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final job = bookings[index];

              final title = job.title ?? 'Không có tiêu đề';
              final district = job.locationAddress ?? 'Không rõ khu vực';
              final date = job.scheduledDate != null
                  ? '${job.scheduledDate!.day}/${job.scheduledDate!.month}/${job.scheduledDate!.year}'
                  : 'Chưa xác định';
              final time = job.scheduledDate != null
                  ? '${job.scheduledDate!.hour.toString().padLeft(2, '0')}:${job.scheduledDate!.minute.toString().padLeft(2, '0')}'
                  : '';
              final salary = job.budget ?? 0;
              final hours = job.estimatedDuration ?? 0;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    '$district • $date $time • $hours phút',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  trailing: Text(
                    '${salary.toStringAsFixed(0)} đ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
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
}
