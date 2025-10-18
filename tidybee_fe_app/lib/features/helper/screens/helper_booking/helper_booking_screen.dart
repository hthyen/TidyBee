import 'package:flutter/material.dart';

class HelperBookingScreen extends StatefulWidget {
  final String? token;

  const HelperBookingScreen({super.key, this.token});

  @override
  State<HelperBookingScreen> createState() => _HelperBookingScreenState();
}

class _HelperBookingScreenState extends State<HelperBookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text("helper booking"));
  }
}
