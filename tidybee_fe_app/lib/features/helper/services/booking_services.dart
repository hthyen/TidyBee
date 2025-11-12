import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tidybee_fe_app/features/helper/model/booking_request.dart';

class BookingService {
  final String bookingAssignedUrl = dotenv.env['API_ASSIGNED_BOOKING'] ?? '';
  final String bookingRequestUrl = dotenv.env['API_REQUEST_BOOKING'] ?? '';

  Future<List<BookingRequest>> getAvailableBookingsForHelper({
    required String token,
  }) async {
    try {
      final url = Uri.parse(bookingAssignedUrl);
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        final list = decoded['data'] as List?;
        if (list == null) return [];

        final bookings = list.map((e) => BookingRequest.fromJson(e)).toList();
        print('Lấy ${bookings.length} việc mới (available for helper)');
        return bookings;
      } else {
        print('Lỗi API available: ${response.statusCode}');
        print('Body: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Exception khi lấy việc mới: $e');
      return [];
    }
  }

  Future<bool> performBookingAction({
    required String token,
    required String bookingId,
    required int action,
    String? notes,
    int? finalPrice,
    String? cancellationReason,
  }) async {
    try {
      final url = Uri.parse('$bookingRequestUrl/$bookingId/action');

      final body = <String, dynamic>{"action": action};

      if (notes != null) body["notes"] = notes;
      if (finalPrice != null) body["finalPrice"] = finalPrice;
      if (cancellationReason != null)
        body["cancellationReason"] = cancellationReason;

      final response = await http.post(
        url,
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }
}
