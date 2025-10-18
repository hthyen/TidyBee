import 'package:flutter/material.dart';

class HelperHomeScreen extends StatefulWidget {
  final String? token;

  const HelperHomeScreen({super.key, this.token});

  @override
  State<HelperHomeScreen> createState() => _HelperHomeScreenState();
}

class _HelperHomeScreenState extends State<HelperHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text("helper homepage"));
  }
}
