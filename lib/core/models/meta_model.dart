import 'package:gamecircle/core/entities/meta.dart';
import 'package:gamecircle/core/models/links_model.dart';

class MetaModel extends Meta {
  MetaModel({
    required int? currentPage,
    required int? from,
    required int? lastPage,
    required int? perPage,
    required int? to,
    required int? total,
    required String? path,
    required LinksModel? links,
  }) : super(
          currentPage: currentPage,
          from: from,
          lastPage: lastPage,
          perPage: perPage,
          to: to,
          total: total,
          path: path,
          links: links,
        );

  factory MetaModel.fromJson(Map<String, dynamic>? json) {
    return MetaModel(
      currentPage: json?['current_page'],
      from: json?['from'],
      lastPage: json?['last_page'],
      path: json?['path'],
      perPage: json?['per_page'],
      to: json?['to'],
      total: json?['total'],
      links: LinksModel.fromJson(
        json?['links'],
      ),
    );
  }
}
