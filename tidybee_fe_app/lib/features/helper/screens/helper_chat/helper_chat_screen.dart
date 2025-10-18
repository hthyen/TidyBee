import 'package:flutter/material.dart';

class HelperChatScreen extends StatefulWidget {
  final String? token;

  const HelperChatScreen({super.key, this.token});

  @override
  State<HelperChatScreen> createState() => _HelperChatScreenState();
}

class _HelperChatScreenState extends State<HelperChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text("helper chat"));
  }
}
