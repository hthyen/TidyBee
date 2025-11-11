import 'package:intl/intl.dart';

class UtilsMethod {
  // Format money
  static String formatMoney(double value) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    return formatter.format(value);
  }

  // Method format datetime
  static String formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      return DateFormat('dd/MM/yyyy HH:mm:ss').format(date);
    } catch (_) {
      return isoString;
    }
  }
}
