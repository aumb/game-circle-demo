import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/entities/links.dart';

class Meta extends Equatable {
  final int? currentPage;
  final int? from;
  final int? lastPage;
  final int? perPage;
  final int? to;
  final int? total;
  final String? path;
  final Links? links;

  Meta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.perPage,
    required this.to,
    required this.total,
    required this.path,
    required this.links,
  });

  @override
  List<Object?> get props =>
      [currentPage, from, lastPage, perPage, to, total, path];
}
