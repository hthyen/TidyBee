// features/helper/screens/helper_home_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';
import 'package:tidybee_fe_app/features/helper/model/helper.dart';
import 'package:tidybee_fe_app/features/helper/services/helper_services.dart';
import 'package:tidybee_fe_app/features/helper/widgets/helper_home/earnings_card.dart';
import 'package:tidybee_fe_app/features/helper/widgets/helper_home/incomplete_profile_box.dart';
import 'package:tidybee_fe_app/features/helper/widgets/helper_home/quick_stats_row.dart';
import 'package:tidybee_fe_app/features/helper/widgets/helper_home/upcoming_job_card.dart';

class HelperHomeScreen extends StatefulWidget {
  final String token;
  const HelperHomeScreen({super.key, required this.token});

  @override
  State<HelperHomeScreen> createState() => _HelperHomeScreenState();
}

class _HelperHomeScreenState extends State<HelperHomeScreen> {
  final HelperServices _helperService = HelperServices();

  Helper? _helper;
  bool _isLoading = true;

  // Dữ liệu giả lập (sẽ lấy từ API sau)
  double _todayEarnings = 0;
  double _weekEarnings = 0;
  int _completedJobsThisWeek = 0;
  double _rating = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final helper = await _fetchHelper();

      // Giả lập dữ liệu thu nhập & stats (thay bằng API thật sau)
      await Future.delayed(const Duration(milliseconds: 800));
      _todayEarnings = 450000; // 450k
      _weekEarnings = 2800000; // 2.8tr
      _completedJobsThisWeek = 12;
      _rating = 4.8;

      setState(() {
        _helper = helper;
        _isLoading = false;
      });
    } catch (e) {
      print('Lỗi load dữ liệu: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<Helper?> _fetchHelper() async {
    final prefs = await SharedPreferences.getInstance();
    final helperId = prefs.getString('id');
    if (helperId == null) return null;
    return await _helperService.getHelper(widget.token, helperId);
  }

  bool _isProfileIncomplete(Helper? helper) {
    if (helper == null) return true;

    return helper.description?.isEmpty != false ||
        helper.experience?.isEmpty != false ||
        helper.languages?.isEmpty != false ||
        helper.location == null ||
        helper.location?.isEmpty != false ||
        helper.hourlyRate == null ||
        helper.services == null ||
        helper.services!.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      appBar: AppBar(
        title: const Text(
          "Tidybee",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Mở trang thông báo
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 1. Hoàn thiện hồ sơ
                  if (_helper != null && _isProfileIncomplete(_helper))
                    IncompleteProfileBox(helper: _helper!, token: widget.token),

                  const SizedBox(height: 16),

                  // 2. Lợi nhuận hôm nay & tuần
                  EarningsCard(
                    today: _todayEarnings,
                    week: _weekEarnings,
                    onWithdraw: () {
                      // TODO: Mở trang rút tiền
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Chuyển đến trang rút tiền...'),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // 3. Công việc sắp tới (chỉ 1 cái nổi bật)
                  UpcomingJobCard(
                    title: "Dọn nhà 3 phòng",
                    address: "Quận 7, TP.HCM",
                    time: "14:00 - 16:00",
                    date: "Hôm nay",
                    salary: 380000,
                    onTap: () {
                      // TODO: Mở chi tiết job
                    },
                  ),

                  const SizedBox(height: 20),

                  // 4. Thống kê nhanh
                  QuickStatsRow(
                    completedJobs: _completedJobsThisWeek,
                    rating: _rating,
                    pendingJobs: 2,
                  ),

                  const SizedBox(height: 20),

                  // 5. Nút hành động nhanh
                  _buildQuickActions(),

                  const SizedBox(height: 80), // Để bottom nav không che
                ],
              ),
            ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _actionButton(
            icon: Icons.work_outline,
            label: "Xem công việc",
            onTap: () {
              // TODO: Chuyển sang tab "Công việc"
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _actionButton(
            icon: Icons.calendar_today,
            label: "Lịch làm việc",
            onTap: () {
              // TODO: Chuyển sang tab "Lịch"
            },
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
