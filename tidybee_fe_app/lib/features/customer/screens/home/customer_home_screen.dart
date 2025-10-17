import 'package:flutter/widgets.dart';

class CustomerHomeScreen extends StatefulWidget {
  final String token;

  const CustomerHomeScreen({super.key, required this.token});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Text("trang chủ"));
  }
}
