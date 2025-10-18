import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';
import 'package:tidybee_fe_app/features/helper/model/helper.dart';
import 'package:tidybee_fe_app/features/helper/services/helper_services.dart';
import 'package:tidybee_fe_app/features/helper/widgets/helper_profile/helper_profile_card.dart';
import 'package:tidybee_fe_app/features/helper/widgets/helper_profile/helper_profile_header.dart';
import 'package:tidybee_fe_app/features/helper/widgets/helper_profile/helper_profile_info_row.dart';
import 'package:tidybee_fe_app/features/helper/widgets/helper_profile/incomplete_profile_card.dart';
import 'package:go_router/go_router.dart';

class HelperProfileScreen extends StatefulWidget {
  final String token;

  const HelperProfileScreen({super.key, required this.token});

  @override
  State<HelperProfileScreen> createState() => _HelperProfileScreenState();
}

class _HelperProfileScreenState extends State<HelperProfileScreen> {
  final HelperServices _helperServices = HelperServices();

  /// Check if profile is incomplete
  bool _isProfileIncomplete(Helper helper) {
    return helper.description == null ||
        helper.description!.isEmpty ||
        helper.experience == null ||
        helper.experience!.isEmpty ||
        helper.languages == null ||
        helper.languages!.isEmpty ||
        helper.location == null ||
        helper.location!.isEmpty ||
        helper.hourlyRate == null ||
        helper.services == null ||
        helper.services!.isEmpty;
  }

  /// Fetch helper info from API
  Future<Helper?> _fetchHelper() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final helperId = prefs.getString('id');
      if (helperId == null) return null;

      return await _helperServices.getHelper(widget.token, helperId);
    } catch (e) {
      print('❌ Lỗi khi tải thông tin helper: $e');
      return null;
    }
  }

  /// Format date
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '—';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return dateString;
    }
  }

  /// Logout
  Future<void> _logout(BuildContext context) async {
    final confirm =
        await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Xác nhận'),
            content: const Text('Bạn có chắc muốn đăng xuất?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Đăng xuất'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirm) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (context.mounted) {
      context.go("/login");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã đăng xuất')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      appBar: AppBar(
        title: const Text('Hồ sơ cộng tác viên'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: FutureBuilder<Helper?>(
        future: _fetchHelper(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Lỗi khi tải thông tin cộng tác viên: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final helper = snapshot.data;
          if (helper == null) {
            return const Center(child: Text("Không tải được dữ liệu"));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// Warning: profile incomplete
                if (_isProfileIncomplete(helper))
                  IncompleteProfileCard(
                    helper: helper,
                    token: widget.token,
                    onUpdated: () => setState(() {}),
                  ),

                const SizedBox(height: 16),

                /// Profile header
                HelperProfileHeader(helper: helper, onEdit: () {}),
                const SizedBox(height: 20),

                /// Personal information
                HelperProfileCard(
                  title: 'Thông tin cá nhân',
                  icon: Icons.person,
                  onEdit: () {
                    context.pushNamed(
                      "edit-helper-personal",
                      extra: {"token": widget.token, "helper": helper},
                    );
                  },
                  children: [
                    HelperProfileInfoRow(
                      title: 'Mô tả',
                      value: helper.description ?? '—',
                    ),
                    HelperProfileInfoRow(
                      title: 'Kinh nghiệm',
                      value: helper.experience ?? '—',
                    ),
                    HelperProfileInfoRow(
                      title: 'Ngôn ngữ',
                      value: helper.languages ?? '—',
                    ),
                    HelperProfileInfoRow(
                      title: 'Khu vực',
                      value: helper.location ?? '—',
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                /// Work information
                HelperProfileCard(
                  title: 'Thông tin công việc',
                  icon: Icons.work,
                  onEdit: () {
                    context
                        .pushNamed(
                          "edit-helper-work",
                          extra: {"token": widget.token, "helper": helper},
                        )
                        .then((updated) {
                          if (updated == true) setState(() {});
                        });
                  },
                  children: [
                    HelperProfileInfoRow(
                      title: 'Giá theo giờ',
                      value:
                          '${NumberFormat('#,##0').format(helper.hourlyRate ?? 0)} đ',
                    ),
                    HelperProfileInfoRow(
                      title: 'Dịch vụ',
                      value: helper.services?.join(', ') ?? '—',
                    ),
                    HelperProfileInfoRow(
                      title: 'Giờ làm việc',
                      value:
                          (helper.workingHoursStart != null &&
                              helper.workingHoursEnd != null)
                          ? '${helper.workingHoursStart} - ${helper.workingHoursEnd}'
                          : '—',
                    ),
                    HelperProfileInfoRow(
                      title: 'Ngày làm việc',
                      value: helper.workingDays?.join(', ') ?? '—',
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                /// System
                HelperProfileCard(
                  title: 'Hệ thống',
                  icon: Icons.shield,
                  children: [
                    HelperProfileInfoRow(
                      title: 'Xác minh lý lịch',
                      value: (helper.backgroundChecked ?? false)
                          ? 'Đã xác minh'
                          : 'Chưa xác minh',
                    ),
                    HelperProfileInfoRow(
                      title: 'Tài liệu',
                      value: '${helper.documents?.length ?? 0} tài liệu',
                    ),
                    HelperProfileInfoRow(
                      title: 'Ngày tạo',
                      value: _formatDate(helper.createdAt?.toString()),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// Logout button
                ElevatedButton.icon(
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    'Đăng xuất',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    shadowColor: Colors.redAccent.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
