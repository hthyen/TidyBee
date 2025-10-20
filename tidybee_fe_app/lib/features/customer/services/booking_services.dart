import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tidybee_fe_app/core/common_widgets/error_messages.dart';
import 'package:tidybee_fe_app/features/customer/model/booking.dart';

class BookingServices {
  final String requestBookingUrl = dotenv.env['API_REQUEST_BOOKING'] ?? '';

  // Future - asynchronous createBooking
  Future<Booking?> createBooking(
    Map<String, dynamic> newBooking,
    String token,
  ) async {
    final url = Uri.parse('$requestBookingUrl');

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(newBooking),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Booking.fromJson(data['data']);
    } else {
      final errorMessage = _extractErrorMessage(response);
      throw Exception(errorMessage);
    }
  }

  String _extractErrorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map && body['message'] != null) {
        return ErrorMessages.from(body['message']);
      }
      return ErrorMessages.from(response.body.toString());
    } catch (_) {
      return ErrorMessages.from(response.body.toString());
    }
  }
}
