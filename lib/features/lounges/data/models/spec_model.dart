import 'package:gamecircle/features/lounges/domain/entities/spec.dart';

class SpecModel extends Spec {
  SpecModel({
    required int? id,
    required String? name,
    required SpecType type,
  }) : super(
          id: id,
          name: name,
          type: type,
        );

  factory SpecModel.fromJson(Map<String, dynamic>? json) {
    return SpecModel(
      id: json?['id'],
      name: json?['name'],
      type: SpecType(json?['type']),
    );
  }
  static List<SpecModel> fromJsonList(List? json) {
    if (json != null && json.isNotEmpty) {
      List<SpecModel> specs =
          json.map((spec) => SpecModel.fromJson(spec)).toList();
      return specs;
    } else {
      return [];
    }
  }
}
