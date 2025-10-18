import 'package:flutter/material.dart';

class HelperProfileScreen extends StatefulWidget {
  final String? token;

  const HelperProfileScreen({super.key, this.token});

  @override
  State<HelperProfileScreen> createState() => _HelperProfileScreenState();
}

class _HelperProfileScreenState extends State<HelperProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text("helper profile"));
  }
}
