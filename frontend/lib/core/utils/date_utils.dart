import 'package:intl/intl.dart';

class AppDateUtils {
  /// Formats a DateTime into a professional "Joined on MMM DD, YYYY" string.
  static String formatJoinDate(DateTime date) {
    return 'Joined on ${DateFormat('MMM dd, yyyy').format(date)}';
  }
}
