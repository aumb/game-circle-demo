import 'package:gamecircle/features/lounges/domain/entities/package.dart';

class PackageModel extends Package {
  PackageModel({
    required num? price,
    required num? hours,
  }) : super(
          price: price,
          hours: hours,
        );

  factory PackageModel.fromJson(Map<String, dynamic>? json) {
    return PackageModel(
      price: json?['price'],
      hours: json?['hours'],
    );
  }
  static List<PackageModel> fromJsonList(List? json) {
    if (json != null && json.isNotEmpty) {
      List<PackageModel> packages =
          json.map((package) => PackageModel.fromJson(package)).toList();
      return packages;
    } else {
      return [];
    }
  }
}
