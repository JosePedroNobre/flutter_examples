import 'package:intl/intl.dart';

DateTime dateFromString(String dateString) {
  return dateString != null && dateString.isNotEmpty
      ? DateFormat('yyyy-MM-dd').parse(dateString)
      : null;
}

String dateFormatShort(DateTime date) {
  return date != null ? DateFormat('yyyy-MM-dd').format(date) : null;
}

String dateFormatLong(DateTime date) {
  return date != null ? DateFormat('MMM yyyy').format(date) : null;
}
