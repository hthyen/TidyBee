import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  //Method get current location
  static Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      // Check service enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      // Check permission
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }

      if (permission == LocationPermission.deniedForever) return null;

      // Get current location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return position;
    } catch (e) {
      print("Lỗi khi lấy vị trí hiện tại: $e");
      return null;
    }
  }

  static Future<String?> getAddressFromPosition(Position position) async {
    try {
      // Take address from location
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}";
      } else {
        print("Không tìm thấy địa chỉ cho vị trí này.");
        return null;
      }
    } catch (e) {
      print("Lỗi khi lấy địa chỉ từ tọa độ: $e");
      return null;
    }
  }
}
