import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formatToString() {
    final DateFormat formatter = DateFormat('MMM d, yyyy, h:mm a');
    return formatter.format(this);
  }
}