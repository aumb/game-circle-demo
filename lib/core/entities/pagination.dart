import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/entities/meta.dart';

class Pagination extends Equatable {
  final List<dynamic>? items;
  final Meta meta;

  Pagination({
    required this.items,
    required this.meta,
  });

  @override
  List<Object?> get props => [items, meta];
}
