import 'package:go_router/go_router.dart';
import 'package:tidybee_fe_app/features/auth/screens/login_screen.dart';
import 'package:tidybee_fe_app/features/auth/screens/register_screen.dart';
import 'package:tidybee_fe_app/features/not_found/not_found_page.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/otp_verification_screen.dart';
import '../../features/auth/screens/reset_password_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: "/login",
    debugLogDiagnostics: true, //console router
    routes: [
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
    ],

    errorBuilder: (context, state) => const NotFoundPage(),
  );
}
