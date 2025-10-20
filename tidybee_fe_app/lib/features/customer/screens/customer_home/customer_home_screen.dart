import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tidybee_fe_app/features/customer/widgets/homepage_widgets/home_banner_slide.dart';
import 'package:tidybee_fe_app/features/customer/widgets/homepage_widgets/home_header.dart';
import 'package:tidybee_fe_app/features/customer/widgets/homepage_widgets/home_services.dart';

class CustomerHomeScreen extends StatefulWidget {
  final String token;

  const CustomerHomeScreen({super.key, required this.token});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadPref();
  }

  void _loadPref() async {
    final prefs = await SharedPreferences.getInstance();
    final firstName = prefs.getString('firstName');
    final lastName = prefs.getString('lastName');

    setState(() {
      _userName = "${firstName ?? ''} ${lastName ?? ''}".trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // Header
              HomeHeader(userName: _userName ?? ""),

              SizedBox(height: 12),

              // Slide images
              HomeBannerSlide(),

              SizedBox(height: 12),

              // Home services
              HomeServices(),
            ],
          ),
        ),
      ),
    );
  }
}
