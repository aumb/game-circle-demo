import 'package:gamecircle/features/lounges/domain/entities/country.dart';

class CountryModel extends Country {
  CountryModel({
    required String? name,
    required String? code,
  }) : super(
          code: code,
          name: name,
        );

  factory CountryModel.fromJson(Map<String, dynamic>? json) {
    return CountryModel(
      name: json?['name'],
      code: json?['code'],
    );
  }
}
