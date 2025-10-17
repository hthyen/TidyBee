import 'package:flutter/widgets.dart';

class CustomerChatScreen extends StatefulWidget {
  final String token;

  const CustomerChatScreen({super.key, required this.token});

  @override
  State<CustomerChatScreen> createState() => _CustomerChatScreenState();
}

class _CustomerChatScreenState extends State<CustomerChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Text("Chat"));
  }
}
