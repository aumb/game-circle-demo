import 'package:gamecircle/features/lounges/data/models/spec_model.dart';
import 'package:gamecircle/features/lounges/domain/entities/section_information.dart';

class SectionInformationModel extends SectionInformation {
  SectionInformationModel({
    required int? id,
    required String? name,
    required num? price,
    required List<SpecModel?>? specs,
  }) : super(
          id: id,
          name: name,
          price: price,
          specs: specs,
        );

  factory SectionInformationModel.fromJson(Map<String, dynamic>? json) {
    return SectionInformationModel(
        id: json?['id'],
        name: json?['name'],
        price: json?['price'],
        specs: json?['specs'] != null
            ? SpecModel.fromJsonList(json?['specs'])
            : null);
  }
  static List<SectionInformationModel> fromJsonList(List? json) {
    if (json != null && json.isNotEmpty) {
      List<SectionInformationModel> packages = json
          .map((package) => SectionInformationModel.fromJson(package))
          .toList();
      return packages;
    } else {
      return [];
    }
  }
}
