import 'package:flutter/material.dart';
import '../widgets/base_auth_layout.dart';
import '../widgets/register_form.dart';
import '../../../core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseAuthLayout(
      title: "Đăng ký tài khoản",
      form: RegisterForm(),
      bottomSection: Column(
        children: [
          TextButton(
            onPressed: () {
              context.push("/forgot-password");
            },
            child: Text(
              "Quên mật khẩu?",
              style: TextStyle(color: AppColors.primary),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
      showGoogleButton: true,
      onGooglePressed: null,
    );
  }
}
