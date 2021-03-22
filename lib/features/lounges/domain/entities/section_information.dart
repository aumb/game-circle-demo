import 'package:equatable/equatable.dart';
import 'package:gamecircle/features/lounges/domain/entities/spec.dart';

class SectionInformation extends Equatable {
  final int? id;
  final String? name;
  final num? price;
  final List<Spec?>? specs;

  SectionInformation({
    required this.id,
    required this.name,
    required this.price,
    required this.specs,
  });

  @override
  List<Object?> get props => [id, name, price, specs];
}
