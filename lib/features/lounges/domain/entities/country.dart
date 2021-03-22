import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final String? name;
  final String? code;

  Country({
    required this.name,
    required this.code,
  });

  @override
  List<Object?> get props => [name, code];
}
