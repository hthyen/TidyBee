import 'package:flutter/material.dart';
import 'package:tidybee_fe_app/features/customer/widgets/profile_widgets/profile_menu_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';

class CustomerProfileScreen extends StatefulWidget {
  final String token;

  const CustomerProfileScreen({super.key, required this.token});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  // Mock data (sau này có thể thay bằng API call)
  String name = 'Esther Howard';
  String email = 'esther.howard@email.com';
  String avatarUrl = 'https://i.pravatar.cc/150?img=47';

  // Method to logout
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
      // Appbar
      appBar: AppBar(
        title: const Text('Tài khoản'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Avatar
            CircleAvatar(radius: 45, backgroundImage: NetworkImage(avatarUrl)),
            const SizedBox(height: 12),

            // Name + Email
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),

            const SizedBox(height: 4),

            Text(email, style: TextStyle(color: Colors.grey[600])),

            const SizedBox(height: 12),

            // Edit Profile Button
            ElevatedButton.icon(
              onPressed: () {
                context.push('/customer-profile/edit');
              },
              icon: const Icon(Icons.edit, size: 18),
              label: const Text('Chỉnh sửa hồ sơ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Divider
            const Divider(thickness: 0.8),

            // Menu items
            Expanded(
              child: ListView(
                children: [
                  // Edit profile
                  ProfileMenuItem(
                    icon: Icons.person_outline,
                    iconColor: AppColors.primary,
                    title: 'Hồ sơ cá nhân',
                    onTap: () => context.push('/customer-profile/edit'),
                  ),

                  // Edit address
                  ProfileMenuItem(
                    icon: Icons.location_on_outlined,
                    iconColor: AppColors.primary,
                    title: 'Địa chỉ của tôi',
                    onTap: () => context.push('/customer-profile/address'),
                  ),

                  // Edit payment method
                  ProfileMenuItem(
                    icon: Icons.credit_card_outlined,
                    iconColor: AppColors.primary,
                    title: 'Phương thức thanh toán',
                    onTap: () => context.push('/customer-profile/payment'),
                  ),

                  // Edit wallet
                  ProfileMenuItem(
                    icon: Icons.account_balance_wallet_outlined,
                    iconColor: AppColors.primary,
                    title: 'Ví của tôi',
                    onTap: () => context.push('/customer-profile/wallet'),
                  ),

                  // Edit voucher
                  ProfileMenuItem(
                    icon: Icons.local_offer_outlined,
                    iconColor: AppColors.primary,
                    title: 'Mã giảm giá của tôi',
                    onTap: () => context.push('/customer-profile/voucher'),
                  ),

                  // Support
                  ProfileMenuItem(
                    icon: Icons.help_outline,
                    iconColor: AppColors.primary,
                    title: 'Trợ giúp & Hỗ trợ',
                    onTap: () {
                      // Bạn có thể thêm 1 route support sau này
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Chức năng đang phát triển'),
                        ),
                      );
                    },
                  ),

                  const Divider(thickness: 0.8),

                  // Logout btn
                  ProfileMenuItem(
                    icon: Icons.logout,
                    title: 'Đăng xuất',
                    iconColor: Colors.red,
                    isLogout: true,
                    onTap: () => _logout(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
