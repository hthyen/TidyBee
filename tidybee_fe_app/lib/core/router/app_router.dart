import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:tidybee_fe_app/features/auth/screens/login_screen.dart';
import 'package:tidybee_fe_app/features/auth/screens/register_screen.dart';
import 'package:tidybee_fe_app/features/customer/screens/customer_booking/customer_booking_screen.dart';
import 'package:tidybee_fe_app/features/customer/screens/customer_bottom_navigate.dart';
import 'package:tidybee_fe_app/features/customer/screens/customer_home/customer_home_screen.dart';
import 'package:tidybee_fe_app/features/customer/screens/customer_home/service_detail/customer_services_detail_screen.dart';
import 'package:tidybee_fe_app/features/customer/screens/customer_profile/customer_profile_screen.dart';
import 'package:tidybee_fe_app/features/customer/screens/customer_profile/edit_profile_screen.dart';
import 'package:tidybee_fe_app/features/customer/screens/customer_profile/address_screen.dart';
import 'package:tidybee_fe_app/features/customer/screens/customer_profile/payment_method_screen.dart';
import 'package:tidybee_fe_app/features/customer/screens/customer_profile/wallet_screen.dart';
import 'package:tidybee_fe_app/features/customer/screens/customer_profile/voucher_screen.dart';
import 'package:tidybee_fe_app/features/helper/screens/helper_booking/helper_booking_screen.dart';
import 'package:tidybee_fe_app/features/helper/screens/helper_bottom_navigate.dart';
import 'package:tidybee_fe_app/features/helper/screens/helper_home/helper_home_screen.dart';
import 'package:tidybee_fe_app/features/helper/screens/helper_profile/helper_profile_screen.dart';
import 'package:tidybee_fe_app/features/helper/screens/helper_profile/edit_personal_info_screen.dart';
import 'package:tidybee_fe_app/features/helper/screens/helper_profile/edit_work_info_screen.dart';
import 'package:tidybee_fe_app/features/chat/screen/chat_list_screen.dart';
import 'package:tidybee_fe_app/features/chat/screen/chat_screen.dart';
import 'package:tidybee_fe_app/features/not_found/not_found_page.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/otp_verification_screen.dart';
import '../../features/auth/screens/reset_password_screen.dart';

class AppRouter {
  static final _rootCustomerNavigatorKey = GlobalKey<NavigatorState>();
  static final _rootHelperNavigatorKey = GlobalKey<NavigatorState>();

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
          final extra = state.extra;
          String? token;
          String? currentUserId;

          if (extra is Map<String, dynamic>) {
            token = extra['token'] as String?;
            currentUserId = extra['currentUserId'] as String?;
          } else if (extra is String) {
            token = extra; // fallback cũ
          }

          // Push token into CustomerBottomNavigate
          return CustomerBottomNavigate(
            token: token,
            currentUserId: currentUserId,
            child: child,
          );
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
              final bottom = context
                  .findAncestorWidgetOfExactType<CustomerBottomNavigate>();
              return ChatListScreen(
                token: bottom?.token ?? '',
                currentUserId: bottom?.currentUserId ?? '',
              );
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
            routes: [
              GoRoute(
                path: "edit",
                name: "edit-profile",
                builder: (context, state) => const EditProfileScreen(),
              ),

              GoRoute(
                path: "address",
                name: "address",
                builder: (context, state) => const AddressScreen(),
              ),

              GoRoute(
                path: "payment",
                name: "payment-method",
                builder: (context, state) => const PaymentMethodScreen(),
              ),

              GoRoute(
                path: "wallet",
                name: "wallet",
                builder: (context, state) => const WalletScreen(),
              ),

              GoRoute(
                path: "voucher",
                name: "voucher",
                builder: (context, state) => const VoucherScreen(),
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: "/customer-service-detail",
        name: "customer-service-detail",
        builder: (context, state) {
          // Lấy dữ liệu từ state.extra
          if (state.extra is Map<String, dynamic>) {
            final data = state.extra as Map<String, dynamic>;
            final String title = data["title"] ?? "Dịch vụ";
            final String price = data["price"] ?? "";
            final int id = data["id"] ?? 0;
            final String description = data["description"] ?? "Mô tả";

            return CustomerServicesDetailScreen(
              title: title,
              id: id,
              price: price,
              description: description,
            );
          }
          return const NotFoundPage();
        },
      ),

      // ================= HELPER =================
      ShellRoute(
        navigatorKey: _rootHelperNavigatorKey,
        builder: (context, state, child) {
          // Take token from state.extra
          final extra = state.extra;
          String? token;
          String? currentUserId;

          if (extra is Map<String, dynamic>) {
            token = extra['token'] as String?;
            currentUserId = extra['currentUserId'] as String?;
          } else if (extra is String) {
            token = extra; // fallback cũ
          }
          // Push token into HelperBottomNavigate
          return HelperBottomNavigate(
            token: token,
            currentUserId: currentUserId,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: "/helper-homepage",
            name: "helper-homepage",
            builder: (context, state) {
              // Take token from parent widget (HelperBottomNavigate)
              final bottomWidget = context
                  .findAncestorWidgetOfExactType<HelperBottomNavigate>();
              final token = bottomWidget?.token ?? '';

              return HelperHomeScreen(token: token);
            },
          ),
          GoRoute(
            path: "/helper-booking",
            name: "helper-booking",
            builder: (context, state) {
              // Take token from parent widget (HelperBottomNavigate)
              final bottomWidget = context
                  .findAncestorWidgetOfExactType<HelperBottomNavigate>();
              final token = bottomWidget?.token ?? '';

              return HelperBookingScreen(token: token);
            },
          ),

          GoRoute(
            path: "/helper-profile",
            name: "helper-profile",
            builder: (context, state) {
              // Take token from parent widget (HelperBottomNavigate)
              final bottomWidget = context
                  .findAncestorWidgetOfExactType<HelperBottomNavigate>();
              final token = bottomWidget?.token ?? '';

              return HelperProfileScreen(token: token);
            },
            routes: [
              // Route: edit personal information
              GoRoute(
                path: "edit-personal",
                name: "edit-helper-personal",
                builder: (context, state) {
                  final extra = state.extra as Map<String, dynamic>?;
                  final token = extra?["token"] as String? ?? '';
                  final helper = extra?["helper"];
                  return EditPersonalInfoScreen(helper: helper, token: token);
                },
              ),

              // Route: edit work information
              GoRoute(
                path: "edit-work",
                name: "edit-helper-work",
                builder: (context, state) {
                  final extra = state.extra as Map<String, dynamic>?;
                  final token = extra?["token"] as String? ?? '';
                  final helper = extra?["helper"];
                  return EditWorkInfoScreen(helper: helper, token: token);
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: "/chat-detail",
        name: "chat-detail",
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;

          // DEBUG: In ra để kiểm tra
          print('AppRouter - currentUserId: ${extra['currentUserId']}');
          print('AppRouter - roomId: ${extra['roomId']}');

          return ChatScreen(
            token: extra['token'] as String,
            roomId: extra['roomId'] as String,
            opponentName: extra['opponentName'] as String,
            currentUserId: extra['currentUserId'] as String,
          );
        },
      ),
    ],

    errorBuilder: (context, state) => const NotFoundPage(),
  );
}
