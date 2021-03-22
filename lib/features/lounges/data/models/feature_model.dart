import 'package:gamecircle/features/lounges/domain/entities/feature.dart';

class FeatureModel extends Feature {
  FeatureModel({
    required String? name,
  }) : super(
          name: name,
        );

  factory FeatureModel.fromJson(Map<String, dynamic>? json) {
    return FeatureModel(
      name: json?['name'],
    );
  }

  static List<FeatureModel> fromJsonList(List? json) {
    if (json != null && json.isEmpty) {
      List<FeatureModel> features =
          json.map((feature) => FeatureModel.fromJson(feature)).toList();
      return features;
    } else {
      return [];
    }
  }
}
