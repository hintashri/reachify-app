extension DateExt on DateTime {
  bool isSameDay(DateTime t) {
    return DateTime(year, month, day) == DateTime(t.year, t.month, t.day);
  }
}
