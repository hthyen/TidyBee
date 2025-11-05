import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';
import 'package:tidybee_fe_app/features/helper/model/booking_request.dart';
import 'package:tidybee_fe_app/features/helper/services/booking_services.dart';

class HelperBookingScreen extends StatefulWidget {
  final String? token;
  const HelperBookingScreen({super.key, this.token});

  @override
  State<HelperBookingScreen> createState() => _HelperBookingScreenState();
}

class _HelperBookingScreenState extends State<HelperBookingScreen> {
  late final BookingService _bookingService;
  bool _isLoading = true;
  List<BookingRequest> _bookings = [];

  @override
  void initState() {
    super.initState();
    _bookingService = BookingService();
    _loadAcceptedBookings();
  }

  Future<void> _loadAcceptedBookings() async {
    if (widget.token == null || !mounted) return;

    setState(() => _isLoading = true);

    try {
      final bookings = await _bookingService.getAvailableBookingsForHelper(
        token: widget.token!,
      );

      if (!mounted) return;

      setState(() {
        _bookings = bookings;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi kết nối: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Công việc đã nhận"),
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAcceptedBookings,
              child: _bookings.isEmpty ? _buildEmptyState() : _buildJobList(),
            ),
    );
  }

  Widget _buildJobList() {
    // Sắp xếp theo ngày gần nhất
    final sorted = _bookings
      ..sort((a, b) {
        final dateA =
            a.scheduledDate ?? DateTime.now().add(const Duration(days: 365));
        final dateB =
            b.scheduledDate ?? DateTime.now().add(const Duration(days: 365));
        return dateA.compareTo(dateB);
      });

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        final job = sorted[index];
        return _buildJobCard(job);
      },
    );
  }

  Widget _buildJobCard(BookingRequest job) {
    final time = job.scheduledDate != null
        ? "${job.scheduledDate!.hour.toString().padLeft(2, '0')}:${job.scheduledDate!.minute.toString().padLeft(2, '0')} - ${_endTime(job)}"
        : "Chưa xác định";
    final hours = job.estimatedDuration ?? 0;
    final createdAgo = job.createdAt != null
        ? _timeAgo(job.createdAt!)
        : "Vừa nhận";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              const Icon(Icons.cleaning_services, color: Colors.blueAccent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  job.title ?? "Dịch vụ",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                job.locationAddress ?? "Quận ?",
                style: const TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Day + time
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(_formatDate(job.scheduledDate)),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text("$time • $hours giờ"),
            ],
          ),

          const SizedBox(height: 12),

          // Booking time
          Row(
            children: [
              Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                createdAgo,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Price
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "${NumberFormat('#,##0').format(job.budget ?? 0)}đ",
              style: const TextStyle(
                color: Colors.orangeAccent,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _endTime(BookingRequest job) {
    if (job.scheduledDate == null || job.estimatedDuration == null)
      return "??:??";
    final end = job.scheduledDate!.add(Duration(hours: job.estimatedDuration!));
    return "${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}";
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "Chưa xác định";
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final jobDay = DateTime(date.year, date.month, date.day);

    if (jobDay == today) return "Hôm nay";
    if (jobDay == tomorrow) return "Ngày mai";
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return "Vừa nhận";
    if (diff.inMinutes < 60) return "${diff.inMinutes} phút trước";
    if (diff.inHours < 24) return "${diff.inHours} giờ trước";
    return "${diff.inDays} ngày trước";
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              "Bạn chưa có công việc nào",
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Khi khách hàng chọn bạn, công việc sẽ xuất hiện ở đây",
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
