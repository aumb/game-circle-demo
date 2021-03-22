import 'package:gamecircle/core/entities/pagination.dart';
import 'package:gamecircle/core/models/meta_model.dart';

class PaginationModel extends Pagination {
  PaginationModel({
    required List<dynamic>? items,
    required MetaModel meta,
  }) : super(
          items: items,
          meta: meta,
        );

  factory PaginationModel.fromJson(Map<String, dynamic>? json) {
    return PaginationModel(
      items: json?['data'],
      meta: MetaModel.fromJson(json?['meta']?['pagination']),
    );
  }
}
