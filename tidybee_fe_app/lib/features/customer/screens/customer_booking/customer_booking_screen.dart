import 'package:flutter/widgets.dart';

class CustomerBookingScreen extends StatefulWidget {
  final String token;

  const CustomerBookingScreen({super.key, required this.token});

  @override
  State<CustomerBookingScreen> createState() => _CustomerBookingScreenState();
}

class _CustomerBookingScreenState extends State<CustomerBookingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Text("Đặt lịch"));
  }
}
