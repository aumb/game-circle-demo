import 'package:gamecircle/core/entities/enum.dart';

class LoungeFilterOption extends Enum {
  static const unknown = LoungeFilterOption._internal("");
  static const distance = LoungeFilterOption._internal("Distance");
  static const name = LoungeFilterOption._internal("Name");
  static const rating = LoungeFilterOption._internal("Rating");

  static const List<LoungeFilterOption> values = [
    distance,
    name,
    rating,
  ];

  const LoungeFilterOption._internal(String value) : super.internal(value);

  factory LoungeFilterOption(String raw) => values.firstWhere(
        (val) => val.value == raw,
        orElse: () => unknown,
      );
}
