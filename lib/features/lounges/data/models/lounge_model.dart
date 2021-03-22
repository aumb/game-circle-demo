import 'package:gamecircle/features/lounges/data/models/country_model.dart';
import 'package:gamecircle/features/lounges/data/models/feature_model.dart';
import 'package:gamecircle/features/lounges/data/models/game_model.dart';
import 'package:gamecircle/features/lounges/data/models/gc_location_model.dart';
import 'package:gamecircle/features/lounges/data/models/package_model.dart';
import 'package:gamecircle/features/lounges/data/models/section_information_model.dart';
import 'package:gamecircle/features/lounges/data/models/timing_model.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';

class LoungeModel extends Lounge {
  LoungeModel({
    required int? id,
    required int? places,
    required num? rating,
    required num? reviewCount,
    required bool? featured,
    required String? name,
    required String? logoUrl,
    required String? phoneNumber,
    required CountryModel? country,
    required GCLocationModel? location,
    required List<PackageModel?>? packages,
    required List<TimingModel?>? timings,
    required List<GameModel?>? games,
    required List<SectionInformationModel?>? sectionInformation,
    required List<FeatureModel?>? features,
    required num? distance,
  }) : super(
          id: id,
          places: places,
          rating: rating,
          reviewCount: reviewCount,
          featured: featured,
          name: name,
          logoUrl: logoUrl,
          phoneNumber: phoneNumber,
          country: country,
          location: location,
          packages: packages,
          timings: timings,
          games: games,
          sectionInformation: sectionInformation,
          features: features,
          distance: distance,
        );

  factory LoungeModel.fromJson(Map<String, dynamic>? json) {
    if (json?['data'] != null) json = json?['data'];
    return LoungeModel(
      id: json?['id'],
      places: json?['places'],
      rating: json?['rating'],
      reviewCount: json?['review_count'],
      featured: json?['featured'],
      name: json?['name'],
      logoUrl: json?['logo'],
      phoneNumber: json?['phone_number'],
      features: json?['features'] != null
          ? FeatureModel.fromJsonList(json!['features'])
          : [],
      country: json?['country'] != null
          ? CountryModel.fromJson(json!['country'])
          : null,
      location: json?['location'] != null
          ? GCLocationModel.fromJson(json!['location'])
          : null,
      packages: json?['packages'] != null
          ? PackageModel.fromJsonList(json!['packages'])
          : [],
      timings: json?['timings'] != null
          ? TimingModel.fromJsonList(json!['timings'])
          : [],
      games:
          json?['games'] != null ? GameModel.fromJsonList(json!['games']) : [],
      sectionInformation: json?['sps'] != null
          ? SectionInformationModel.fromJsonList(json!['sections'])
          : [],
      distance: json?['distance'],
    );
  }

  static List<LoungeModel> fromJsonList(List? json) {
    if (json != null && json.isNotEmpty) {
      List<LoungeModel> lounges =
          json.map((lounge) => LoungeModel.fromJson(lounge)).toList();
      return lounges;
    } else {
      return [];
    }
  }
}
