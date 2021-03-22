import 'package:gamecircle/core/entities/links.dart';

class LinksModel extends Links {
  LinksModel({
    required String? first,
    required String? last,
    required String? prev,
    required String? next,
  }) : super(
          first: first,
          last: last,
          prev: prev,
          next: next,
        );

  factory LinksModel.fromJson(Map<String, dynamic>? json) {
    return LinksModel(
      first: json?['first'],
      last: json?['last'],
      prev: json?['prev'],
      next: json?['next'],
    );
  }
}
