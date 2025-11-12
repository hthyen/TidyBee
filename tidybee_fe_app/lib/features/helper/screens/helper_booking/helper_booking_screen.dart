import 'package:flutter/material.dart';
import 'package:tidybee_fe_app/features/helper/model/booking_request.dart';
import 'package:tidybee_fe_app/features/helper/services/booking_services.dart';
import 'package:tidybee_fe_app/features/helper/widgets/helper_booking/booking_calendar.dart';
import 'package:tidybee_fe_app/features/helper/widgets/helper_booking/job_card.dart';
import 'package:tidybee_fe_app/features/helper/widgets/helper_booking/empty_state.dart';
import 'package:tidybee_fe_app/features/chat/model/chat_room.dart';
import 'package:tidybee_fe_app/features/chat/screen/chat_screen.dart';
import 'package:tidybee_fe_app/features/chat/services/chat_service.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';

class HelperBookingScreen extends StatefulWidget {
  final String? token;
  const HelperBookingScreen({super.key, this.token});

  @override
  State<HelperBookingScreen> createState() => _HelperBookingScreenState();
}

class _HelperBookingScreenState extends State<HelperBookingScreen>
    with TickerProviderStateMixin {
  late final BookingService _bookingService;
  late TabController _tabController;

  bool _isLoading = true;
  List<BookingRequest> _allBookings = [];
  List<BookingRequest> _upcoming = [];
  List<BookingRequest> _completed = [];

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _bookingService = BookingService();
    _tabController = TabController(length: 2, vsync: this);
    _loadBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    if (widget.token == null || !mounted) return;
    setState(() => _isLoading = true);

    try {
      final bookings = await _bookingService.getAvailableBookingsForHelper(
        token: widget.token!,
      );
      if (!mounted) return;

      setState(() {
        _allBookings = bookings;
        _classifyBookings();
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    }
  }

  void _classifyBookings() {
    _upcoming = _allBookings.where((b) => b.status != 5).toList();
    _completed = _allBookings.where((b) => b.status == 5).toList();
    _upcoming.sort(
      (a, b) => (a.scheduledStartTime ?? farFuture).compareTo(
        b.scheduledStartTime ?? farFuture,
      ),
    );
  }

  static final farFuture = DateTime.now().add(const Duration(days: 365));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Lịch Công Việc"),
        centerTitle: true,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Sắp tới"),
            Tab(text: "Hoàn thành"),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [_buildUpcomingTab(), _buildCompletedTab()],
            ),
    );
  }

  Widget _buildUpcomingTab() {
    return RefreshIndicator(
      onRefresh: _loadBookings,
      child: Column(
        children: [
          BookingCalendar(
            upcoming: _upcoming,
            selectedDay: _selectedDay,
            focusedDay: _focusedDay,
            onDaySelected: (selected, focused) => setState(() {
              _selectedDay = selected;
              _focusedDay = focused;
            }),
          ),
          Expanded(child: _buildJobList(_upcoming)),
        ],
      ),
    );
  }

  Widget _buildCompletedTab() {
    return RefreshIndicator(
      onRefresh: _loadBookings,
      child: _completed.isEmpty
          ? EmptyState(message: "Chưa có công việc hoàn thành")
          : _buildJobList(_completed),
    );
  }

  Widget _buildJobList(List<BookingRequest> jobs) {
    final filtered = jobs.where((job) {
      if (job.scheduledDate == null) return true;
      final jobDay = DateTime(
        job.scheduledDate!.year,
        job.scheduledDate!.month,
        job.scheduledDate!.day,
      );
      final selected = DateTime(
        _selectedDay.year,
        _selectedDay.month,
        _selectedDay.day,
      );
      return jobDay == selected;
    }).toList();

    if (filtered.isEmpty && _tabController.index == 0) {
      return EmptyState(message: "Không có việc vào ngày này");
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filtered.length,
      itemBuilder: (context, index) => JobCard(
        job: filtered[index],
        token: widget.token!,
        onStart: _startJob,
        onComplete: _completeJob,
        onChat: _openChat,
      ),
    );
  }

  // === HÀNH ĐỘNG ===
  Future<void> _startJob(BookingRequest job) async {
    if (job.id == null || job.scheduledStartTime == null) return;

    final now = DateTime.now();
    final startTime = job.scheduledStartTime!;
    final earliestStart = startTime.subtract(const Duration(minutes: 15));

    // Kiểm tra: chưa tới giờ - 15 phút
    if (now.isBefore(earliestStart)) {
      final minutesLeft = earliestStart.difference(now).inMinutes;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Chưa tới giờ! Vui lòng đợi $minutesLeft phút nữa."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Xác nhận
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Bắt đầu công việc"),
        content: Text("Xác nhận bắt đầu:\n${job.title}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Bắt đầu"),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    final success = await _bookingService.performBookingAction(
      token: widget.token!,
      bookingId: job.id!,
      action: 4, // Bắt đầu
    );

    setState(() => _isLoading = false);

    if (success) {
      await _loadBookings();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Đã bắt đầu công việc!"),
          backgroundColor: Colors.blue,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lỗi khi bắt đầu"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _completeJob(BookingRequest job) async {
    if (job.id == null || job.scheduledEndTime == null) return;

    final now = DateTime.now();
    final endTime = job.scheduledEndTime!;
    final earliestComplete = endTime.subtract(const Duration(minutes: 15));

    // Kiểm tra: chưa tới giờ - 15 phút
    if (now.isBefore(earliestComplete)) {
      final minutesLeft = earliestComplete.difference(now).inMinutes;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Chưa tới giờ hoàn thành! Vui lòng đợi $minutesLeft phút.",
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (job.status != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vui lòng bắt đầu công việc trước!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Xác nhận
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hoàn thành công việc"),
        content: Text("Xác nhận hoàn thành:\n${job.title}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Hoàn thành"),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    final success = await _bookingService.performBookingAction(
      token: widget.token!,
      bookingId: job.id!,
      action: 5,
    );

    setState(() => _isLoading = false);

    if (success) {
      await _loadBookings();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Công việc đã hoàn thành!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lỗi khi hoàn thành"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _openChat(BookingRequest job) async {
    if (job.id == null || job.customerId == null || job.helperId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Thiếu thông tin"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final chatService = ChatService(widget.token!, job.helperId!);
      ChatRoom? room = await chatService.createChatRoom(
        bookingId: job.id!,
        customerId: job.customerId!,
        helperId: job.helperId!,
      );

      // Nếu đã có phòng → lấy tin nhắn để kiểm tra
      if (room != null) {
        final messages = await chatService.getMessages(
          roomId: room.id,
          page: 1,
          pageSize: 1,
        );
        final hasMessages = messages.isNotEmpty;

        // CHỈ GỬI CHÀO NẾU CHƯA CÓ TIN NHẮN
        if (!hasMessages) {
          await chatService.sendMessage(
            roomId: room.id,
            content: "Xin chào! Tôi là helper, đã nhận công việc của bạn.",
          );
        }
      }

      setState(() => _isLoading = false);

      if (room == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Không thể tạo phòng"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            token: widget.token!,
            roomId: room.id,
            opponentName: "Khách hàng",
            currentUserId: job.helperId!,
          ),
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: $e"), backgroundColor: Colors.red),
      );
    }
  }
}
