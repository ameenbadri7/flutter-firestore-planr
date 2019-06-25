class DateHelper {
  static final DateHelper _instance = DateHelper.internal();

  factory DateHelper() => _instance;

  DateHelper.internal();

  static final DateTime now = DateTime.now();
  static final DateTime tomorrow = DateTime(now.year, now.month, now.day + 1);
  static final DateTime dayAftertomorrow =
      DateTime(now.year, now.month, now.day + 2);
  static final DateTime today = DateTime(now.year, now.month, now.day);

  static bool isToday(DateTime date) {
    if (date == null) return false;
    return date.isBefore(tomorrow) &&
        (date.isAfter(today) || date.isAtSameMomentAs(today));
  }

  static bool isTomorrow(DateTime date) {
    if (date == null) return false;
    return date.isBefore(dayAftertomorrow) &&
        (date.isAfter(tomorrow) || date.isAtSameMomentAs(tomorrow));
  }

  static bool isOverdue(DateTime date) {
    if (date == null) return false;
    return date.isBefore(today);
  }

  static bool isUpcoming(DateTime date) {
    if (date == null) return false;
    return date.isAfter(dayAftertomorrow) ||
        date.isAtSameMomentAs(dayAftertomorrow);
  }
}
