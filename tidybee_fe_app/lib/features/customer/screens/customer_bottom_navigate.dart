import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';

class CustomerBottomNavigate extends StatefulWidget {
  final Widget child;
  final String? token;
  final String? currentUserId;

  const CustomerBottomNavigate({
    super.key,
    required this.child,
    this.token,
    this.currentUserId,
  });

  @override
  State<CustomerBottomNavigate> createState() => _CustomerBottomNavigateState();
}

class _CustomerBottomNavigateState extends State<CustomerBottomNavigate> {
  // Track the currently selected tab index
  int _currentIndex = 0;

  // Define routes corresponding to each bottom nav item
  final List<String> _routes = [
    '/customer-homepage',
    '/customer-chat',
    '/customer-booking',
    '/customer-profile',
  ];

  // Handle tab change when user taps a bottom nav item
  void _onItemTapped(int index) {
    if (index != _currentIndex) {
      setState(() => _currentIndex = index);

      // Transmission token & currentUserId
      context.go(
        _routes[index],
        extra: {'token': widget.token, 'currentUserId': widget.currentUserId},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child, // Display the page content
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppColors.primary, // Highlighted icon color
        unselectedItemColor: Colors.grey, // Unselected icon color
        showUnselectedLabels: false, // Hide labels for unselected items
        type: BottomNavigationBarType.fixed, // Prevent shifting animation

        items: const [
          // Homepage
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),

          // Chat
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Tin nhắn',
          ),

          // Booking
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_outlined),
            activeIcon: Icon(Icons.event_note),
            label: 'Đặt lịch',
          ),

          // Profile
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }
}
