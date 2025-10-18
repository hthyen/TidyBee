import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tidybee_fe_app/core/common_widgets/notification_service.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';
import 'package:tidybee_fe_app/features/auth/model/user.dart';
import 'package:tidybee_fe_app/features/auth/services/user_services.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  bool showPassword = false;
  bool showConfirmPassword = false;
  bool isLoading = false;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  int selectedRole = 1;
  String? selectedGender;
  DateTime? selectedDateOfBirth;

  // Create instance object of RegisterServices
  final UserServices userServices = UserServices();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Method register
  Future<void> handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    // Create new object
    final newUser = {
      "firstName": firstNameController.text,
      "lastName": lastNameController.text,
      "email": emailController.text,
      "phoneNumber": phoneController.text,
      "password": passwordController.text,
      "role": selectedRole,
      "dateOfBirth": "${selectedDateOfBirth?.toIso8601String()}Z",
      "gender": selectedGender,
    };

    try {
      final User? registeredUser = await userServices.register(newUser);

      // If user leave this screen then stop logic below
      if (!mounted) return;

      if (registeredUser != null) {
        NotificationService.showSuccess(context, "Đăng ký thành công!");
        context.go("/login");
      } else {
        NotificationService.showError(
          context,
          "Đăng ký thất bại. Vui lòng thử lại.",
        );
      }
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().replaceFirst("Exception: ", "");

      NotificationService.showError(context, message);
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Role Selection
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Bạn muốn đăng ký với vai trò gì?",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      // Customer
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() => selectedRole = 1);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: selectedRole == 1
                                  ? AppColors.primary.withValues(alpha: 0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selectedRole == 1
                                    ? AppColors.primary
                                    : Colors.grey[300]!,
                                width: selectedRole == 1 ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 32,
                                  color: selectedRole == 1
                                      ? AppColors.primary
                                      : Colors.grey[600],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Khách hàng",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: selectedRole == 1
                                        ? AppColors.primary
                                        : Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Helper
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() => selectedRole = 2);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: selectedRole == 2
                                  ? AppColors.primary.withValues(alpha: 0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selectedRole == 2
                                    ? AppColors.primary
                                    : Colors.grey[300]!,
                                width: selectedRole == 2 ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.cleaning_services,
                                  size: 32,
                                  color: selectedRole == 2
                                      ? AppColors.primary
                                      : Colors.grey[600],
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  "Người dọn dẹp",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: selectedRole == 2
                                        ? AppColors.primary
                                        : Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Form fields
            Column(
              children: [
                // First name
                TextFormField(
                  controller: firstNameController,
                  decoration: _inputDecoration("Họ"),
                  // Validate
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập họ";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Last name
                TextFormField(
                  controller: lastNameController,
                  decoration: _inputDecoration("Tên"),
                  // Validate
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập tên";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Gender
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: _inputDecoration("Giới tính"),
                  items: const [
                    DropdownMenuItem(value: "Nam", child: Text("Nam")),
                    DropdownMenuItem(value: "Nữ", child: Text("Nữ")),
                  ],
                  onChanged: (value) {
                    setState(() => selectedGender = value);
                  },
                  // Validate
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng chọn giới tính";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Birth
                GestureDetector(
                  // Open date picker
                  onTap: () async {
                    FocusScope.of(context).unfocus(); // Hide keyboard
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate:
                          selectedDateOfBirth ?? DateTime(2003), //init date
                      firstDate: DateTime(1990), //min date
                      lastDate: DateTime(2005), //max date
                      locale: const Locale('vi', 'VN'),
                    );

                    if (picked != null) {
                      setState(() => selectedDateOfBirth = picked);
                    }
                  },

                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: _inputDecoration(
                        "Ngày sinh",
                      ).copyWith(suffixIcon: const Icon(Icons.calendar_today)),
                      // Controller
                      controller: TextEditingController(
                        text: selectedDateOfBirth == null
                            ? ''
                            : "${selectedDateOfBirth!.day.toString().padLeft(2, '0')}/"
                                  "${selectedDateOfBirth!.month.toString().padLeft(2, '0')}/"
                                  "${selectedDateOfBirth!.year}",
                      ),
                      // Validate
                      validator: (value) {
                        if (selectedDateOfBirth == null) {
                          return "Vui lòng chọn ngày sinh";
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: emailController,
                  decoration: _inputDecoration("Email"),
                  keyboardType: TextInputType.emailAddress,
                  // Validate
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập email";
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return "Email không hợp lệ";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Phone
                TextFormField(
                  controller: phoneController,
                  decoration: _inputDecoration("Số điện thoại"),
                  keyboardType: TextInputType.phone,
                  // Validate
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập số điện thoại";
                    }
                    if (!RegExp(r'^(84|0)(3|5|7|8|9)\d{8}$').hasMatch(value)) {
                      return "Số điện thoại không hợp lệ";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: passwordController,
                  obscureText: !showPassword,
                  decoration: _inputDecoration("Mật khẩu").copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() => showPassword = !showPassword);
                      },
                    ),
                  ),
                  // Validate
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập mật khẩu";
                    }
                    if (value.length < 6) {
                      return "Mật khẩu phải có ít nhất 6 ký tự";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Confirm password
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: !showConfirmPassword,
                  decoration: _inputDecoration("Nhập lại mật khẩu").copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        showConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(
                          () => showConfirmPassword = !showConfirmPassword,
                        );
                      },
                    ),
                  ),
                  // Validate
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập lại mật khẩu";
                    }
                    if (value != passwordController.text) {
                      return "Mật khẩu không khớp";
                    }
                    return null;
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Register button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isLoading ? "Đang đăng ký..." : "Đăng ký",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
