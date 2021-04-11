import 'package:intl/intl.dart';

class GCDateUtils {
  String getStrDate(DateTime? date, {String? pattern, String? locale}) {
    DateFormat defaultFormat = locale != null
        ? DateFormat('dd/MM/yyyy', locale)
        : DateFormat('dd/MM/yyyy');

    if (date == null || date.millisecondsSinceEpoch == 0) {
      return '';
    }

    DateFormat? format;
    if (pattern != null) {
      try {
        format =
            locale != null ? DateFormat(pattern, locale) : DateFormat(pattern);
      } on Exception catch (e) {
        throw ('errorDatePattern: $e');
      }
    }

    String formattedDate;
    if (format != null) {
      formattedDate = format.format(date);
    } else {
      formattedDate = defaultFormat.format(date);
    }
    return formattedDate;
  }

  DateTime getDateTimeFromTime(String time) {
    DateTime now = DateTime.now();
    List<String> timeList = time.split(":");

    int? hour = int.tryParse(timeList.first);
    int? minute = int.tryParse(timeList[1]);

    DateTime dateTime =
        DateTime(now.year, now.month, now.day, hour ?? 0, minute ?? 0);

    return dateTime;
  }
}
