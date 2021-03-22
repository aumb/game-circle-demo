import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/entities/enum.dart';

class Spec extends Equatable {
  final int? id;
  final String? name;
  final SpecType? type;

  Spec({
    required this.id,
    required this.name,
    required this.type,
  });

  @override
  List<Object?> get props => [id, name, type];
}

class SpecType extends Enum {
  static const unknown = SpecType._internal("");
  static const keyboard = SpecType._internal("K");
  static const mouse = SpecType._internal("M");
  static const headset = SpecType._internal("H");
  static const gpu = SpecType._internal("G");
  static const chair = SpecType._internal("C");
  static const monitor = SpecType._internal("M");

  static const List<SpecType> values = [
    keyboard,
    mouse,
    headset,
    gpu,
    chair,
    monitor,
    unknown,
  ];

  const SpecType._internal(String value) : super.internal(value);

  factory SpecType(String raw) => values.firstWhere(
        (val) => val.value == raw,
        orElse: () => unknown,
      );
}
