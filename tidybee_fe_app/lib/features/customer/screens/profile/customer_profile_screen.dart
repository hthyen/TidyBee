import 'package:flutter/widgets.dart';

class CustomerProfileScreen extends StatefulWidget {
  final String token;

  const CustomerProfileScreen({super.key, required this.token});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Text("hồ sơ"));
  }
}
