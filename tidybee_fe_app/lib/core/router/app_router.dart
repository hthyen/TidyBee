import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:tidybee_fe_app/features/auth/screens/login_screen.dart';
import 'package:tidybee_fe_app/features/auth/screens/register_screen.dart';
import 'package:tidybee_fe_app/features/customer/screens/customer_booking/customer_booking_screen.dart';
import 'package:tidybee_fe_app/features/customer/screens/customer_chat/customer_chat_screen.dart';
import 'package:tidybee_fe_app/features/customer/screens/customer_bottom_navigate.dart';
import 'package:tidybee_fe_app/features/customer/screens/customer_home/customer_home_screen.dart';
import 'package:tidybee_fe_app/features/customer/screens/customer_profile/customer_profile_screen.dart';
import 'package:tidybee_fe_app/features/not_found/not_found_page.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/otp_verification_screen.dart';
import '../../features/auth/screens/reset_password_screen.dart';

class AppRouter {
  static final _rootCustomerNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: "/login",
    debugLogDiagnostics: true, //console router
    routes: [
      // ================= AUTH =================
      GoRoute(
        path: "/login",
        name: "login",
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: "/register",
        name: "register",
        builder: (context, state) => const RegisterScreen(),
      ),

      GoRoute(
        path: "/forgot-password",
        name: "forgot-password",
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      GoRoute(
        path: "/otp",
        name: "otp",
        builder: (context, state) {
          // get email from ForgotPasswordPage
          final email =
              (state.extra is String && (state.extra as String).isNotEmpty)
              ? state.extra as String
              : 'Không xác định';
          return OtpVerificationScreen(email: email);
        },
      ),

      GoRoute(
        path: "/reset-password",
        name: "reset-password",
        builder: (context, state) {
          if (state.extra is Map<String, dynamic>) {
            final data = state.extra as Map<String, dynamic>;
            final email = data["email"] as String? ?? "";
            final otp = data["otp"] as String? ?? "";
            return ResetPasswordScreen(email: email, otp: otp);
          }
          return const NotFoundPage();
        },
      ),

      // ================= CUSTOMER =================
      ShellRoute(
        navigatorKey: _rootCustomerNavigatorKey,
        builder: (context, state, child) {
          // Take token from state.extra
          final token = state.extra is String ? state.extra as String : null;

          // Push token into CustomerBottomNavigate
          return CustomerBottomNavigate(token: token, child: child);
        },
        routes: [
          GoRoute(
            path: "/customer-homepage",
            name: "customer-homepage",
            builder: (context, state) {
              // Take token from parent widget (CustomerBottomNavigate)
              final bottomWidget = context
                  .findAncestorWidgetOfExactType<CustomerBottomNavigate>();
              final token = bottomWidget?.token ?? '';

              return CustomerHomeScreen(token: token);
            },
          ),

          GoRoute(
            path: "/customer-chat",
            name: "customer-chat",
            builder: (context, state) {
              // Take token from parent widget (CustomerBottomNavigate)
              final bottomWidget = context
                  .findAncestorWidgetOfExactType<CustomerBottomNavigate>();
              final token = bottomWidget?.token ?? '';

              return CustomerChatScreen(token: token);
            },
          ),

          GoRoute(
            path: "/customer-booking",
            name: "customer-booking",
            builder: (context, state) {
              // Take token from parent widget (CustomerBottomNavigate)
              final bottomWidget = context
                  .findAncestorWidgetOfExactType<CustomerBottomNavigate>();
              final token = bottomWidget?.token ?? '';

              return CustomerBookingScreen(token: token);
            },
          ),

          GoRoute(
            path: "/customer-profile",
            name: "customer-profile",
            builder: (context, state) {
              // Take token from parent widget (CustomerBottomNavigate)
              final bottomWidget = context
                  .findAncestorWidgetOfExactType<CustomerBottomNavigate>();
              final token = bottomWidget?.token ?? '';

              return CustomerProfileScreen(token: token);
            },
          ),
        ],
      ),
    ],

    errorBuilder: (context, state) => const NotFoundPage(),
  );
}
