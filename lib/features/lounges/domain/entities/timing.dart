import 'package:equatable/equatable.dart';

class Timing extends Equatable {
  final bool? open;
  final num? day;
  final String? openTime;
  final String? closeTime;

  Timing({
    required this.day,
    required this.openTime,
    required this.closeTime,
    required this.open,
  });

  @override
  List<Object?> get props => [day, openTime, closeTime, open];

  // factory Timing.fromJson(Map<String, dynamic> json) {
  //   if (json != null) {
  //     return Timing(
  //       day: json['day'] != null ? json['day'] + 1 : null,
  //       open: json['open'] != null ? json['open'] : false,
  //       openTime: json['openTime'] != null ? json['openTime'] : null,
  //       closeTime: json['closeTime'] != null ? json['closeTime'] : null,
  //     );
  //   } else {
  //     return null;
  //   }
  // }

  // static List<Timing> fromJsonList(List json) {
  //   if (json != null && json.isNotEmpty) {
  //     List<Timing> timings =
  //         json.map((timing) => Timing.fromJson(timing)).toList();
  //     return timings;
  //   } else {
  //     return [];
  //   }
  // }
}
