import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tidybee_fe_app/features/auth/model/user.dart';

class UserServices {
  final String baseUrl = dotenv.env['API_LOGIN'] ?? '';

  // Future - asynchronous login
  Future<User?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Forces to use UTF-8 encoding to avoid issues with special characters (Vietnamese)
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final userData = data['data']?['user'];

      final user = User.fromJson(userData);

      // Save data into SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("id", user.id ?? "");
      await prefs.setString("firstName", user.firstName ?? "");
      await prefs.setString("lastName", user.lastName ?? "");
      await prefs.setString("email", user.email ?? "");
      await prefs.setString(
        "avatar",
        user.avatar != null ? jsonEncode(user.avatar) : "",
      );
      await prefs.setString("role", user.role?.toString() ?? "");
      await prefs.setString("phoneNumber", user.phoneNumber ?? "");
      await prefs.setString("accessToken", user.accessToken ?? "");

      return user;
    } else {
      // Handle error
      // ignore: avoid_print
      print('Đăng nhập thất bại: ${response.statusCode}');
      return null;
    }
  }
}
