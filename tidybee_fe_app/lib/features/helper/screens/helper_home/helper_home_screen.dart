import 'package:flutter/material.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';
import 'package:tidybee_fe_app/features/helper/model/booking_request.dart';
import 'package:tidybee_fe_app/features/helper/model/helper.dart';
import 'package:tidybee_fe_app/features/helper/services/booking_services.dart';
import 'package:tidybee_fe_app/features/helper/widgets/helper_home/incomplete_profile_box.dart';
import 'package:tidybee_fe_app/features/helper/widgets/helper_home/job_card.dart';

class HelperHomeScreen extends StatefulWidget {
  final String token;
  const HelperHomeScreen({super.key, required this.token});

  @override
  State<HelperHomeScreen> createState() => _HelperHomeScreenState();
}

class _HelperHomeScreenState extends State<HelperHomeScreen> {
  final BookingService _bookingService = BookingService();
  Helper? _helper;
  bool _isLoading = true;
  bool _isProfileIncomplete = false;

  late Future<List<BookingRequest>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    // ⚙️ Nếu sau này bạn cần lấy HelperProfile, đặt code ở đây
    // Ví dụ:
    // _helper = await HelperService().getHelperProfile(token: widget.token);

    setState(() {
      _isProfileIncomplete = _helper == null; // chỉ demo placeholder
      _bookingsFuture = _fetchBookings();
      _isLoading = false;
    });
  }

  Future<List<BookingRequest>> _fetchBookings() async {
    try {
      final bookings = await _bookingService.getAllBookings(
        token: widget.token,
      );
      print('✅ Đã tải ${bookings.length} công việc khả dụng');
      return bookings;
    } catch (e) {
      print('❌ Lỗi khi tải booking: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      appBar: AppBar(
        title: const Text("Tidybee"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _bookingsFuture = _fetchBookings();
                });
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  /// 🧩 Hộp cảnh báo hồ sơ chưa hoàn thiện
                  if (_isProfileIncomplete && _helper != null)
                    IncompleteProfileBox(helper: _helper!, token: widget.token),

                  const SizedBox(height: 20),

                  /// 🔹 Tiêu đề khu vực
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Công việc mới",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Icon(Icons.filter_list, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 10),

                  /// 📦 Danh sách công việc thật từ API
                  FutureBuilder<List<BookingRequest>>(
                    future: _bookingsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
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
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Không có công việc nào khả dụng.',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: bookings.map((job) {
                          final title = job.title ?? 'Không có tiêu đề';
                          final district =
                              job.locationAddress ?? 'Không rõ khu vực';
                          final date = job.scheduledDate != null
                              ? '${job.scheduledDate!.day}/${job.scheduledDate!.month}/${job.scheduledDate!.year}'
                              : 'Chưa xác định';
                          final time = job.scheduledDate != null
                              ? '${job.scheduledDate!.hour.toString().padLeft(2, '0')}:${job.scheduledDate!.minute.toString().padLeft(2, '0')}'
                              : '';
                          final salary = job.budget ?? 0;
                          final hours = job.estimatedDuration ?? 0;

                          return JobCard(
                            title: title,
                            district: district,
                            date: date,
                            time: time,
                            hours: hours,
                            salary: salary,
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
