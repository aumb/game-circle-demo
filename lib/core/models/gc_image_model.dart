import 'package:gamecircle/core/entities/gc_image.dart';

class GCImageModel extends GCImage {
  GCImageModel({
    required int? id,
    required String? imageUrl,
  }) : super(
          id: id,
          imageUrl: imageUrl,
        );

  factory GCImageModel.fromJson(Map<String, dynamic>? json) {
    return GCImageModel(
      id: json?['id'],
      imageUrl: json?['image'],
    );
  }

  static List<GCImageModel> fromJsonList(List? json) {
    if (json != null && json.isNotEmpty) {
      List<GCImageModel> images =
          json.map((image) => GCImageModel.fromJson(image)).toList();
      return images;
    } else {
      return [];
    }
  }
}
