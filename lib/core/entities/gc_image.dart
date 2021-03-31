import 'package:equatable/equatable.dart';

class GCImage extends Equatable {
  final int? id;
  final String? imageUrl;

  GCImage({
    this.id,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, imageUrl];
}
