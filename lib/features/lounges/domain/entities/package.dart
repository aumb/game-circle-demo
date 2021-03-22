import 'package:equatable/equatable.dart';

class Package extends Equatable {
  final num? price;
  final num? hours;

  Package({
    required this.price,
    required this.hours,
  });

  @override
  List<Object?> get props => [price, hours];

  // factory Package.fromJson(Map<String, dynamic> json) {
  //   if (json != null) {
  //     return Package(
  //       price: json['price'] != null ? json['price'] : null,
  //       hours: json['hours'] != null ? json['hours'] : null,
  //     );
  //   } else {
  //     return null;
  //   }
  // }

  // static List<Package> fromJsonList(List json) {
  //   if (json != null && json.isNotEmpty) {
  //     List<Package> packages =
  //         json.map((package) => Package.fromJson(package)).toList();
  //     return packages;
  //   } else {
  //     return [];
  //   }
  // }
}
