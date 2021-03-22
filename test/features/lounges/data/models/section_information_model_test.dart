import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/features/lounges/data/models/section_information_model.dart';
import 'package:gamecircle/features/lounges/domain/entities/section_information.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tSectionInformationModel = SectionInformationModel.fromJson(
      json.decode(fixture('section_information.json')));
  final tSectionInformationModelList = SectionInformationModel.fromJsonList(
      json.decode(fixture('section_information_list.json')));

  test(
    'should be a subclass of SectionInformation and List<SectionInformation> entities',
    () async {
      // assert
      expect(tSectionInformationModelList, isA<List<SectionInformation>>());
      expect(tSectionInformationModel, isA<SectionInformation>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid List<SectionInformation> when fromJsonList is called',
      () async {
        // arrange

        // act
        final result = SectionInformationModel.fromJsonList(
            json.decode(fixture('section_information_list.json')));
        expect(result, tSectionInformationModelList);
      },
    );

    test(
      'should return a valid model when called',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('section_information.json'));
        // act
        final result = SectionInformationModel.fromJson(jsonMap);
        // assert
        expect(result, tSectionInformationModel);
      },
    );
  });
}
