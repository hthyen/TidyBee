import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  //Method get current location
  static Future<Map<String, dynamic>?> getCurrentPosition() async {
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

      return {
        "position": position,
        "latitude": position.latitude,
        "longitude": position.longitude,
      };
    } catch (e) {
      print("Lỗi khi lấy vị trí hiện tại: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getAddressFromPosition(
    Position position,
  ) async {
    try {
      // Take address from location
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        // return "${place.street ?? ''}, ${place.subAdministrativeArea ?? ''}, ${place.administrativeArea ?? ''}";

        return {
          "fullAddress":
              "${place.street ?? ''}, ${place.subAdministrativeArea ?? ''}, ${place.administrativeArea ?? ''}",
          "address": place.street,
          "city": place.administrativeArea,
          "district": place.subAdministrativeArea,
          "ward": place.subAdministrativeArea,
        };
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
