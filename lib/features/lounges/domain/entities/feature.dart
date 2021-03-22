import 'package:equatable/equatable.dart';

class Feature extends Equatable {
  final String? name;

  Feature({
    required this.name,
  });

  @override
  List<Object?> get props => [name];
}
