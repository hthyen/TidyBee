import 'package:tidybee_fe_app/features/helper/model/booking_request.dart';
import 'package:tidybee_fe_app/features/helper/services/booking_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperHomeViewModel {
  final BookingService bookingService;
  final String token;

  HelperHomeViewModel({required this.bookingService, required this.token});

  Future<List<BookingRequest>> fetchBookings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final helperId = prefs.getString('id');
      if (helperId == null) {
        print('⚠️ Không tìm thấy helperId trong SharedPreferences');
        return [];
      }

      final bookings = await bookingService.getAllBookings(token: token);
      print('✅ Đã tải ${bookings.length} booking');
      return bookings;
    } catch (e) {
      print('❌ Lỗi khi lấy danh sách booking: $e');
      return [];
    }
  }
}
