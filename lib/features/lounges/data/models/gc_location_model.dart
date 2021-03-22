import 'package:gamecircle/features/lounges/domain/entities/gc_location.dart';

class GCLocationModel extends GCLocation {
  GCLocationModel({
    required String? district,
    required String? city,
    required String? address,
    required num? longitude,
    required num? latitude,
  }) : super(
          district: district,
          city: city,
          address: address,
          latitude: latitude,
          longitude: longitude,
        );

  factory GCLocationModel.fromJson(Map<String, dynamic>? json) {
    return GCLocationModel(
      district: json?['district'],
      city: json?['city'],
      address: json?['address'],
      longitude: json?['longitude'],
      latitude: json?['latitude'],
    );
  }
}
