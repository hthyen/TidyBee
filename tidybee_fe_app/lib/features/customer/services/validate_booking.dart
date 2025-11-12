import 'package:flutter/material.dart';

class ValidateBooking {
  static bool validateBooking(
    BuildContext context, {
    required double? latitude,
    required double? longitude,
    required String? address,
    required TimeOfDay? startTime,
    required TimeOfDay? endTime,
    required String? note,
  }) {
    if (latitude == null || longitude == null) {
      return showError(context, "Không thể xác định vị trí, vui lòng bật GPS.");
    }

    if (address == null || address.isEmpty) {
      return showError(context, "Địa chỉ không được để trống.");
    }

    if (startTime == null) {
      return showError(context, "Vui lòng chọn thời gian bắt đầu.");
    }

    if (endTime == null) {
      return showError(context, "Vui lòng chọn thời gian kết thúc.");
    }

    if (note == null || note.isEmpty) {
      return showError(context, "Ghi chú không được để trống.");
    }

    return true;
  }

  static bool showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
    return false;
  }
}
