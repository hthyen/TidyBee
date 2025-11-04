// features/helper/screens/helper_booking_screen.dart

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
  int _selectedTabIndex = 0; // 0: Việc mới, 1: Đã nhận
  int _selectedDateIndex = 0;

  late final BookingService _bookingService;
  bool _isLoading = true;
  List<BookingRequest> _allBookings = [];
  List<BookingRequest> _filteredBookings = [];

  final List<DateTime> _dates = List.generate(
    7,
    (i) => DateTime.now().add(Duration(days: i)),
  );

  @override
  void initState() {
    super.initState();
    _bookingService = BookingService();
    _loadData();
  }

  Future<void> _loadData() async {
    if (widget.token == null) return;

    setState(() => _isLoading = true);

    try {
      final bookings = _selectedTabIndex == 0
          ? await _bookingService.getAvailableBookingsForHelper(
              token: widget.token!,
            ) // DÙNG API MỚI
          : await _bookingService.getAvailableBookingsForHelper(
              token: widget.token!,
            ); // Giữ nguyên

      setState(() {
        _allBookings = bookings;
        _filterBookings();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }

  void _filterBookings() {
    final selectedDate = _dates[_selectedDateIndex];
    final startOfDay = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    final endOfDay = startOfDay.add(const Duration(days: 1));

    _filteredBookings = _allBookings.where((job) {
      final jobDate = job.scheduledDate;
      if (jobDate == null) return false;
      return jobDate.isAfter(startOfDay) && jobDate.isBefore(endOfDay);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Quản lý lịch làm việc"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Tabs
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildTabButton("Việc mới", 0),
                _buildTabButton("Đã nhận", 1),
              ],
            ),
          ),

          // Date picker
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _dates.length,
              itemBuilder: (context, index) {
                final date = _dates[index];
                final isSelected = index == _selectedDateIndex;
                final day = DateFormat('E', 'vi').format(date).toUpperCase();
                final dayNum = date.day;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDateIndex = index;
                      _filterBookings();
                    });
                  },
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          day,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dayNum.toString(),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadData,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredBookings.isEmpty
                  ? _buildEmptyState()
                  : _buildJobList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
            _selectedDateIndex = 0;
            _loadData();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? AppColors.primary : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJobList() {
    final morningJobs = _filteredBookings
        .where((j) => j.scheduledDate!.hour < 12)
        .toList();
    final afternoonJobs = _filteredBookings
        .where((j) => j.scheduledDate!.hour >= 12)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          if (morningJobs.isNotEmpty)
            _buildShiftSection("Buổi sáng", morningJobs),
          if (afternoonJobs.isNotEmpty)
            _buildShiftSection("Buổi chiều", afternoonJobs),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildShiftSection(String title, List<BookingRequest> jobs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        ...jobs.map((job) => _buildJobCard(job)).toList(),
      ],
    );
  }

  Widget _buildJobCard(BookingRequest job) {
    final time = job.scheduledDate != null
        ? "${job.scheduledDate!.hour.toString().padLeft(2, '0')}:${job.scheduledDate!.minute.toString().padLeft(2, '0')} - ${_endTime(job)}"
        : "Chưa xác định";
    final hours = job.estimatedDuration ?? 0;
    final otherHelpers =
        (job.selectedHelperIds?.length ?? 1) - 1; // trừ bản thân
    final createdAgo = job.createdAt != null
        ? _timeAgo(job.createdAt!)
        : "Vừa xong";

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
          // Tiêu đề + quận
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

          const SizedBox(height: 8),

          // Thời gian + giờ làm
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(_formatDate(job.scheduledDate)),
              const SizedBox(width: 12),
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text("$time • $hours giờ"),
            ],
          ),

          const SizedBox(height: 8),

          // Thông tin bổ sung: Số helper khác + Thời gian tạo
          Row(
            children: [
              Icon(Icons.people, size: 16, color: Colors.orange[700]),
              const SizedBox(width: 4),
              Text(
                "$otherHelpers helper khác được chọn",
                style: TextStyle(fontSize: 13, color: Colors.orange[700]),
              ),
              const Spacer(),
              Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                createdAgo,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Giá
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
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _timeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return "Vừa xong";
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
            Text(
              _selectedTabIndex == 0
                  ? "Không có việc mới hôm nay"
                  : "Bạn chưa nhận việc nào",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
