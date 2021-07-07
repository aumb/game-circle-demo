import 'package:gamecircle/core/entities/enum.dart';

class ReviewsFilterOption extends Enum {
  static const unknown = ReviewsFilterOption._internal("");
  static const mostRecent = ReviewsFilterOption._internal("updated_at");
  static const highestRated = ReviewsFilterOption._internal("rating");
  static const lowestRated = ReviewsFilterOption._internal("-rating");

  static const List<ReviewsFilterOption> values = [
    mostRecent,
    highestRated,
    lowestRated,
  ];

  String get valueText {
    if (value == ReviewsFilterOption.mostRecent.value) {
      return "most_recent";
    } else if (value == ReviewsFilterOption.highestRated.value) {
      return "highest_rated";
    } else if (value == ReviewsFilterOption.lowestRated.value) {
      return "lowest_rated";
    } else {
      return "";
    }
  }

  const ReviewsFilterOption._internal(String value) : super.internal(value);

  factory ReviewsFilterOption(String raw) => values.firstWhere(
        (val) => val.value == raw,
        orElse: () => unknown,
      );
}
