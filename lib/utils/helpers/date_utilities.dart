class DateUtilities {
  static String getTimeString(DateTime dateTime) {
    var hour = dateTime.hour >= 10 ? dateTime.hour : '0${dateTime.hour}';
    var minute = dateTime.minute >= 10
        ? dateTime.minute
        : '0${dateTime.minute}';

    return '$hour:$minute';
  }

  static String getDateString(DateTime dateTime) {
    var day = dateTime.day >= 10 ? dateTime.day : '0${dateTime.day}';
    var month = dateTime.month >= 10 ? dateTime.month : '0${dateTime.month}';
    var year = dateTime.year;

    return '$day-$month-$year';
  }

  static String getDateTimeString(DateTime dateTime) {
    return '${getDateString(dateTime)} ${getTimeString(dateTime)}';
  }

  /// Returns a DateTime object from a string in the format 'dd-mm-yyyy hh:mm'.
  static DateTime getDateTimeFromString(String dateTimeString) {
    final dateTimeList = dateTimeString.split(' ');

    if (dateTimeList.isEmpty || dateTimeList.length > 2) {
      throw Exception(
        'Invalid date time string. expected format is \'dd-mm-yyyy hh:mm\'',
      );
    }

    final dateString = dateTimeList[0];
    final timeString = dateTimeList.length == 2 ? dateTimeList[1] : '00:00';

    final dateList = dateString.split('-');
    final timeList = timeString.split(':');

    for (var i = 0; i < dateList.length; i++) {
      int? value = int.tryParse(dateList[i]);
      if (value == null) {
        throw Exception(
          'Invalid date time string. expected format is \'dd-mm-yyyy hh:mm\'',
        );
      }
    }

    return DateTime(
      int.parse(dateList[2]),
      int.parse(dateList[1]),
      int.parse(dateList[0]),
      int.parse(timeList[0]),
      int.parse(timeList[1]),
    );
  }

  static String getWeekDayFromDateTime(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'monday';
      case 2:
        return 'tuesday';
      case 3:
        return 'wednesday';
      case 4:
        return 'thursday';
      case 5:
        return 'friday';
      case 6:
        return 'saturday';
      case 7:
        return 'sunday';
      default:
        throw Exception('Invalid date time string');
    }
  }
}
