import 'package:equatable/equatable.dart';

class GCLocation extends Equatable {
  final String? district;
  final String? city;
  final String? address;
  final num? longitude;
  final num? latitude;

  GCLocation({
    required this.district,
    required this.city,
    required this.address,
    required this.longitude,
    required this.latitude,
  });

  @override
  List<Object?> get props => [district, city, address, longitude, latitude];

  // factory GCLocation.fromJson(Map<String, dynamic> json) {
  //   if (json != null) {
  //     return GCLocation(
  //       district: json['district'] != null ? json['district'] : null,
  //       city: json['city'] != null ? json['city'] : null,
  //       address: json['address'] != null ? json['address'] : null,
  //       longitude: json['longitude'] != null ? json['longitude'] : null,
  //       latitude: json['latitude'] != null ? json['latitude'] : null,
  //     );
  //   } else {
  //     return null;
  //   }
  // }
}
