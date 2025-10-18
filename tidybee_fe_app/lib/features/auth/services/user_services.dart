import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tidybee_fe_app/core/common_widgets/error_messages.dart';
import 'package:tidybee_fe_app/features/auth/model/user.dart';

class UserServices {
  final String loginUrl = dotenv.env['API_LOGIN'] ?? '';
  final String registerUrl = dotenv.env['API_REGISTER'] ?? '';

  // Future - asynchronous login
  Future<User?> login(String email, String password) async {
    final url = Uri.parse('$loginUrl');

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

  // Future - asynchronous register
  Future<User?> register(Map<String, dynamic> newUser) async {
    final url = Uri.parse('$registerUrl');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(newUser),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return User.fromJson(data['data']?['user']);
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
