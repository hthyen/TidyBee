import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tidybee_fe_app/core/common_widgets/error_messages.dart';
import 'package:tidybee_fe_app/features/customer/model/booking.dart';

class BookingServices {
  final String requestBookingUrl = dotenv.env['API_REQUEST_BOOKING'] ?? '';
  final String getBooking = dotenv.env['API_GET_BOOKING'] ?? '';
  final String setHelperForBooking =
      dotenv.env['API_ASSIGN_HELPER_FOR_BOOKING'] ?? '';
  final String getBookingById = dotenv.env['API_GET_BOOKING_BY_ID'] ?? '';

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

  // Future - asynchronous get user booking
  Future<List<Booking>> getUserBooking(String token) async {
    final url = Uri.parse('$getBooking');

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      // Forces to use UTF-8 encoding to avoid issues with special characters (Vietnamese)
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final bookingsData = data['data']['bookings'];

      if (bookingsData == null || bookingsData is! List) {
        throw Exception('Lỗi lấy booking');
      }

      // Parse into booking model
      final bookings = bookingsData
          .map<Booking>((json) => Booking.fromJson(json))
          .toList();

      return bookings;
    } else {
      final errorMessage = _extractErrorMessage(response);
      throw Exception(errorMessage);
    }
  }

  // Future - asynchronous get Booking By Id
  Future<Booking> getUserBookingById(String token, String bookingId) async {
    final url = Uri.parse('$getBookingById/$bookingId');

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      // Forces to use UTF-8 encoding to avoid issues with special characters (Vietnamese)
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes))['data'];

      // Convert JSON → Booking model
      return Booking.fromJson(jsonData);
    } else {
      final errorMessage = _extractErrorMessage(response);
      throw Exception(errorMessage);
    }
  }

  // Set helper for booing
  Future<Booking?> assignHelperToBooking({
    required String bookingId,
    required String helperId,
    required String token,
    String? note,
  }) async {
    final response = await http.post(
      Uri.parse('$setHelperForBooking/$bookingId/select-helpers'),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "selectedHelperIds": [helperId],
        "additionalNotes": note ?? "",
      }),
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
