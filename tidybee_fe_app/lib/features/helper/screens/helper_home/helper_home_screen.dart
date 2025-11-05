import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';
import 'package:tidybee_fe_app/core/common_services/format_money.dart';
import 'package:tidybee_fe_app/features/helper/model/helper.dart';
import 'package:tidybee_fe_app/features/helper/services/helper_services.dart';
import 'package:tidybee_fe_app/features/helper/services/earnings_service.dart';
import 'package:tidybee_fe_app/features/helper/model/earnings/earnings_statistics_model.dart';
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
  final EarningsService _earningsService = EarningsService();

  Helper? _helper;
  EarningsStatisticsModel? _earnings;
  bool _isLoading = true;
  bool _isWithdrawing = false;

  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> _loadData() async {
    if (_isDisposed) return;

    setState(() => _isLoading = true);

    try {
      final helper = await _fetchHelper();
      final earnings = await _earningsService.getEarningsStatistics(
        widget.token,
      );

      if (mounted && !_isDisposed) {
        setState(() {
          _helper = helper;
          _earnings = earnings;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Lỗi load: $e');
      if (mounted && !_isDisposed) {
        setState(() => _isLoading = false);
      }
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
    final hasDescription = helper.description?.trim().isNotEmpty == true;
    final hasExperience = helper.experience?.trim().isNotEmpty == true;
    final hasLanguages = helper.languages?.trim().isNotEmpty == true;
    final address = helper.location?['address']?.toString().trim();
    final hasLocation = address?.isNotEmpty == true;
    final hasServices = helper.services != null && helper.services!.isNotEmpty;
    return !(hasDescription &&
        hasExperience &&
        hasLanguages &&
        hasLocation &&
        hasServices);
  }

  Future<void> _requestWithdraw() async {
    if (_isDisposed) return;

    final data = _earnings?.data;
    if (data == null || (data.pendingAmount ?? 0) <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Không có tiền để rút")));
      }
      return;
    }

    if (!mounted) return;
    setState(() => _isWithdrawing = true);

    final earningIds = ["pending_all"];

    try {
      final response = await _earningsService.requestPayout(
        token: widget.token,
        earningIds: earningIds,
        payoutMethod: "BANK_TRANSFER",
        notes: "Rút tiền tự động từ app",
      );

      if (mounted) {
        if (response?.success == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response!.message ?? "Rút tiền thành công!"),
              backgroundColor: Colors.green,
            ),
          );
          await _loadData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response?.message ?? "Rút tiền thất bại"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted && !_isDisposed) {
        setState(() => _isWithdrawing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _earnings?.data;
    final totalEarnings = (data?.totalEarnings ?? 0).toDouble();
    final paidOut = (data?.paidOutAmount ?? 0).toDouble();
    final pending = (data?.pendingAmount ?? 0).toDouble();
    final fees = (data?.totalPlatformFees ?? 0).toDouble();

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
            onPressed: () {},
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
                  if (_helper != null && _isProfileIncomplete(_helper))
                    IncompleteProfileBox(helper: _helper!, token: widget.token),
                  const SizedBox(height: 16),

                  _buildEarningsCard(totalEarnings, paidOut, pending, fees),

                  const SizedBox(height: 20),

                  UpcomingJobCard(
                    title: "Dọn nhà 3 phòng",
                    address: "Quận 7, TP.HCM",
                    time: "14:00 - 16:00",
                    date: "Hôm nay",
                    salary: 380000,
                    onTap: () {},
                  ),

                  const SizedBox(height: 20),

                  QuickStatsRow(
                    completedJobs: data?.completedBookings ?? 0,
                    rating: 4.8,
                    pendingJobs: data?.totalBookings != null
                        ? (data!.totalBookings! - (data.completedBookings ?? 0))
                        : 0,
                  ),

                  const SizedBox(height: 20),

                  _buildQuickActions(),

                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }

  Widget _buildEarningsCard(
    double total,
    double paidOut,
    double pending,
    double fees,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Thu nhập của bạn",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildEarningRow(
            "Tổng thu nhập",
            total,
            AppColors.primary,
            isBold: true,
            fontSize: 24,
          ),
          const Divider(height: 24, thickness: 1),
          _buildEarningRow("Đã rút", paidOut, Colors.green[600]!),
          _buildEarningRow("Đang chờ", pending, Colors.orange[600]!),
          _buildEarningRow("Phí nền tảng", fees, Colors.red[600]!),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isWithdrawing ? null : _requestWithdraw,
              icon: _isWithdrawing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.account_balance_wallet, size: 18),
              label: Text(
                _isWithdrawing ? "Đang xử lý..." : "Rút tiền",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: pending > 0 ? AppColors.primary : Colors.grey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningRow(
    String label,
    double amount,
    Color color, {
    bool isBold = false,
    double fontSize = 16,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Text(
            UtilsMethod.formatMoney(amount),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _actionButton(Icons.work_outline, "Xem công việc", () {}),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _actionButton(Icons.calendar_today, "Lịch làm việc", () {}),
        ),
      ],
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
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
