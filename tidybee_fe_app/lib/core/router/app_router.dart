import 'package:go_router/go_router.dart';
import 'package:tidybee_fe_app/features/auth/screens/login_screen.dart';
import 'package:tidybee_fe_app/features/not_found/not_found_page.dart';

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
    ],

    errorBuilder: (context, state) => const NotFoundPage(),
  );
}
