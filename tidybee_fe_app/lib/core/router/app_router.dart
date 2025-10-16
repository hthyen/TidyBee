import 'package:go_router/go_router.dart';
import 'package:tidybee_fe_app/features/auth/screens/login_screen.dart';

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
  );
}
