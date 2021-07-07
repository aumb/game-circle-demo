import 'package:gamecircle/core/utils/gc_date_utils.dart';
import 'package:gamecircle/features/lounges/domain/entities/timing.dart';
import 'package:intl/intl.dart';

class TimingModel extends Timing {
  TimingModel({
    required bool? open,
    required num? day,
    required DateTime? openTime,
    required DateTime? closeTime,
  }) : super(
          open: open,
          day: day,
          openTime: openTime,
          closeTime: closeTime,
        );

  factory TimingModel.fromJson(Map<String, dynamic>? json) {
    return TimingModel(
      day: json?['day'],
      open: json?['open'],
      openTime: json?['open_time'] != null
          ? DateFormat('Hms', 'en_US').parse(json?['open_time'])
          // GCDateUtils().getDateTimeFromTime()
          : null,
      closeTime: json?['close_time'] != null
          ? GCDateUtils().getDateTimeFromTime(json?['close_time'])
          : null,
    );
  }
  static List<TimingModel> fromJsonList(List? json) {
    if (json != null && json.isNotEmpty) {
      List<TimingModel> timings =
          json.map((timing) => TimingModel.fromJson(timing)).toList();
      return timings;
    } else {
      return [];
    }
  }
}
