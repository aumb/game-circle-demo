import 'package:equatable/equatable.dart';
import 'package:gamecircle/features/lounges/domain/entities/country.dart';
import 'package:gamecircle/features/lounges/domain/entities/feature.dart';
import 'package:gamecircle/features/lounges/domain/entities/game.dart';
import 'package:gamecircle/features/lounges/domain/entities/gc_location.dart';
import 'package:gamecircle/features/lounges/domain/entities/package.dart';
import 'package:gamecircle/features/lounges/domain/entities/section_information.dart';
import 'package:gamecircle/features/lounges/domain/entities/timing.dart';

class Lounge extends Equatable {
  final int? id;
  final int? places;
  final num? rating;
  final num? reviewCount;
  final bool? featured;
  final String? name;
  final String? logoUrl;
  final String? phoneNumber;
  final Country? country;
  final GCLocation? location;
  final List<Package?>? packages;
  final List<Timing?>? timings;
  final List<Game?>? games;
  final List<SectionInformation?>? sectionInformation;
  final List<Feature?>? features;
  final num? distance;

  Lounge({
    required this.id,
    required this.places,
    required this.rating,
    required this.reviewCount,
    required this.featured,
    required this.name,
    required this.logoUrl,
    required this.phoneNumber,
    required this.country,
    required this.location,
    required this.packages,
    required this.timings,
    required this.games,
    required this.sectionInformation,
    required this.features,
    required this.distance,
  });

  @override
  List<Object?> get props => [
        id,
        places,
        rating,
        reviewCount,
        featured,
        name,
        logoUrl,
        phoneNumber,
        country,
        location,
        packages,
        timings,
        games,
        sectionInformation,
        features,
        distance,
      ];
}
