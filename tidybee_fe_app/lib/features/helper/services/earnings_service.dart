import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tidybee_fe_app/features/helper/model/earnings/earnings_statistics_model.dart';
import 'package:tidybee_fe_app/features/helper/model/earnings/payout_request_model.dart';

class EarningsService {
  final String earningsStatisticsUrl =
      dotenv.env['API_EARNINGS_STATISTICS'] ?? '';
  final String requestPayoutUrl =
      dotenv.env['API_EARNINGS_REQUEST_PAYOUT'] ?? '';

  Future<EarningsStatisticsModel?> getEarningsStatistics(String token) async {
    try {
      final url = Uri.parse(earningsStatisticsUrl);
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return EarningsStatisticsModel.fromJson(data);
      } else {
        print('Lỗi tải thống kê earnings: ${response.statusCode}');
        print('Body lỗi: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Lỗi exception khi tải thống kê earnings: $e');
      return null;
    }
  }

  //Request payout
  Future<PayoutResponseModel?> requestPayout({
    required String token,
    required List<String> earningIds,
    required String payoutMethod,
    String? notes,
  }) async {
    try {
      final url = Uri.parse(requestPayoutUrl);

      final requestBody = PayoutRequestModel(
        earningIds: earningIds,
        payoutMethod: payoutMethod,
        notes: notes,
      );

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return PayoutResponseModel.fromJson(data);
      } else {
        print('Lỗi yêu cầu rút tiền: ${response.statusCode}');
        print('Body lỗi: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Lỗi exception khi yêu cầu rút tiền: $e');
      return null;
    }
  }
}
