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
}
