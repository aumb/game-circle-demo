import 'package:gamecircle/features/lounges/domain/entities/timing.dart';

class TimingModel extends Timing {
  TimingModel({
    required bool? open,
    required num? day,
    required String? openTime,
    required String? closeTime,
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
      openTime: json?['openTime'],
      closeTime: json?['closeTime'],
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
