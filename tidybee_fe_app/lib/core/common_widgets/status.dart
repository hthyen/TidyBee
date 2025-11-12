import 'package:flutter/material.dart';

/// Map general process status code to display text, icon, and color
(String text, IconData icon, Color color) mapProcessStatus(int status) {
  switch (status) {
    case 1: // Pending
      return ("Đang chờ xử lý", Icons.hourglass_empty, Colors.orange);
    case 2: // Processing
      return ("Đang xử lý", Icons.sync, Colors.blue);
    case 3: // Completed
      return ("Hoàn thành", Icons.check_circle_outline, Colors.green);
    case 4: // Failed
      return ("Thất bại", Icons.error_outline, Colors.redAccent);
    default:
      return ("Không xác định", Icons.help_outline, Colors.grey);
  }
}

/// Map payment method to display text, icon, and color
(String text, IconData icon, Color color) mapPaymentMethod(int? method) {
  switch (method) {
    case 1:
      return ('Tiền mặt', Icons.money, Colors.green);
    case 4:
      return ('Sepay', Icons.qr_code_2, Colors.teal);
    default:
      return ('Không xác định', Icons.help_outline, Colors.grey);
  }
}
