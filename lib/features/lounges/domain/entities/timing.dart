import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/entities/enum.dart';

class Timing extends Equatable {
  final bool? open;
  final num? day;
  final DateTime? openTime;
  final DateTime? closeTime;

  Timing({
    required this.day,
    required this.openTime,
    required this.closeTime,
    required this.open,
  });

  @override
  List<Object?> get props => [day, openTime, closeTime, open];
}

class Days extends Enum {
  static const monday = Days._internal("monday");
  static const tuesday = Days._internal("tuesday");
  static const wednesday = Days._internal("wednesday");
  static const thursday = Days._internal("thursday");
  static const friday = Days._internal("friday");
  static const saturday = Days._internal("saturday");
  static const sunday = Days._internal("sunday");
  static const unknown = Days._internal("");

  static const List<Days> values = [
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday,
    sunday,
  ];

  const Days._internal(String value) : super.internal(value);

  factory Days(String raw) => values.firstWhere(
        (val) => val.value == raw,
        orElse: () => unknown,
      );
}
