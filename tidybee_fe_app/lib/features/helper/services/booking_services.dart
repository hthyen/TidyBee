import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tidybee_fe_app/features/helper/model/booking_request.dart';

class BookingService {
  final String bookingResponseUrl = dotenv.env['API_BOOKING_RESPONSES'] ?? '';
  final String bookingSearchUrl =
      dotenv.env['API_SEARCH_BOOKINGS_NEARBY'] ?? '';

  /// 🔹 Lấy tất cả công việc gần helper (GET)
  Future<List<BookingRequest>> getAllBookings({required String token}) async {
    try {
      final url = Uri.parse(bookingSearchUrl);
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        final list = decoded['data']?['bookings'] as List?;
        if (list == null) return [];

        final bookings = list.map((e) => BookingRequest.fromJson(e)).toList();
        print('✅ Lấy ${bookings.length} công việc gần helper');
        return bookings;
      } else {
        print('❌ Lỗi ${response.statusCode}: ${response.body}');
        return [];
      }
    } catch (e) {
      print('⚠️ Exception: $e');
      return [];
    }
  }

  /// 🔹 Tạo phản hồi booking (POST)
  Future<bool> createBookingResponse({
    required String token,
    required String bookingRequestId,
    required int proposedPrice,
    required String message,
  }) async {
    try {
      final url = Uri.parse(bookingResponseUrl);
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "bookingRequestId": bookingRequestId,
          "proposedPrice": proposedPrice,
          "message": message,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Tạo phản hồi booking thành công');
        return true;
      } else {
        print('❌ Lỗi tạo phản hồi booking: ${response.statusCode}');
        print('Body lỗi: ${response.body}');
        return false;
      }
    } catch (e) {
      print('⚠️ Exception khi tạo phản hồi booking: $e');
      return false;
    }
  }

  /// 🔹 Lấy thông tin phản hồi booking theo ID (GET)
  Future<Map<String, dynamic>?> getBookingResponse({
    required String token,
    required String responseId,
  }) async {
    try {
      final url = Uri.parse('$bookingResponseUrl/$responseId');
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        print('✅ Lấy phản hồi booking thành công');
        return data;
      } else {
        print('❌ Lỗi lấy phản hồi booking: ${response.statusCode}');
        print('Body lỗi: ${response.body}');
        return null;
      }
    } catch (e) {
      print('⚠️ Exception khi lấy phản hồi booking: $e');
      return null;
    }
  }

  /// 🔹 Cập nhật phản hồi booking (PUT)
  Future<bool> updateBookingResponse({
    required String token,
    required String responseId,
    required String bookingRequestId,
    required int proposedPrice,
    required String message,
  }) async {
    try {
      final url = Uri.parse('$bookingResponseUrl/$responseId');
      final response = await http.put(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "bookingRequestId": bookingRequestId,
          "proposedPrice": proposedPrice,
          "message": message,
        }),
      );

      if (response.statusCode == 200) {
        print('✅ Cập nhật phản hồi booking thành công');
        return true;
      } else {
        print('❌ Lỗi cập nhật phản hồi booking: ${response.statusCode}');
        print('Body lỗi: ${response.body}');
        return false;
      }
    } catch (e) {
      print('⚠️ Exception khi cập nhật phản hồi booking: $e');
      return false;
    }
  }
}
