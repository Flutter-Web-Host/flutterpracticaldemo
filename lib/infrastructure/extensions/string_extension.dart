import 'package:intl/intl.dart';

extension DateFormteExtension on String {

  String convertDate() {
    // Parse the string into a DateTime object
    DateTime dateTime = DateTime.parse(this);

    // Get the day part for adding 'st', 'nd', 'rd', or 'th'
    int day = dateTime.day;
    String daySuffix;

    if (day == 1 || day == 21 || day == 31) {
      daySuffix = 'st';
    } else if (day == 2 || day == 22) {
      daySuffix = 'nd';
    } else if (day == 3 || day == 23) {
      daySuffix = 'rd';
    } else {
      daySuffix = 'th';
    }

    // Combine the formatted date with the day suffix
    return '$day$daySuffix ${DateFormat('MMM yyyy').format(dateTime)}';
  }

  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
