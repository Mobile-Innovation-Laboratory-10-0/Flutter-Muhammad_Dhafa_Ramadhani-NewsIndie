import 'package:intl/intl.dart';

class Helpers {
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  static String calculateReadTime(String? text) {
    if (text == null || text.isEmpty) return '1 min read';

    final wordCount = text.split(' ').length;
    final minutes = (wordCount / 200).ceil();

    return '$minutes min read';
  }

  static String truncateString(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  static bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }
}
