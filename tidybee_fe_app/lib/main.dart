import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tidybee_fe_app/core/router/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  // Load .env file
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,

      // Translate for Flutter (support for datepicker)
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Init that what language app will support
      supportedLocales: const [Locale('en', ''), Locale('vi', '')],
    );
  }
}
