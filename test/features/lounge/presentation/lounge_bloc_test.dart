import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/features/favorites/domain/usecases/toggle_lounge_favorite_status.dart';
import 'package:gamecircle/features/lounge/domain/usecases/get_lounge.dart';
import 'package:gamecircle/features/lounge/presentation/bloc/lounge_bloc.dart';
import 'package:gamecircle/features/lounges/data/models/lounge_model.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';

class MockGetLounge extends Mock implements GetLounge {}

class MockToggleFavoriteStatus extends Mock
    implements ToggleLoungeFavoriteStatus {}

void main() {
  late LoungeBloc loungeBloc;
  late MockGetLounge mockGetLounge;
  late MockToggleFavoriteStatus mockToggleFavoriteStatus;

  late Lounge tLounge;

  //TODO: add toggle favorite to tests
  //TODO: add utils to tests

  setUp(() {
    tLounge = LoungeModel.fromJson(json.decode(fixture('lounge.json')));
    registerFallbackValue<GetLoungeParams>(GetLoungeParams(
      id: 2,
    ));
    mockGetLounge = MockGetLounge();
    mockToggleFavoriteStatus = MockToggleFavoriteStatus();
    loungeBloc = LoungeBloc(
      lounge: tLounge,
      toggleLoungeFavoriteStatus: mockToggleFavoriteStatus,
      getLounge: mockGetLounge,
    );
  });

  group('getLounges', () {
    test(
      'should get data from the local use case',
      () async {
        // arrange
        when(() => mockGetLounge(any()))
            .thenAnswer((_) async => Right(tLounge));
        // act
        loungeBloc.add(GetLoungeEvent());
        await untilCalled(() => mockGetLounge(any()));
        // assert
        verify(
          () => mockGetLounge(GetLoungeParams(
            id: 2,
          )),
        );
      },
    );

    test(
      'should emit [LoungeLoading, LoungeLoaded] when data is gotten successfully',
      () async {
        // arrange
        // setUpMockInputConverterSuccess();
        when(() => mockGetLounge(any()))
            .thenAnswer((_) async => Right(tLounge));
        // assert later
        final expected = [
          LoungeLoading(),
          LoungeLoaded(),
        ];
        expectLater(loungeBloc.stream, emitsInOrder(expected)).then((value) {
          expect(loungeBloc.lounge, equals(tLounge));
        });
        // act
        loungeBloc.add(GetLoungeEvent());
      },
    );

    test(
      'should emit [LoungeLoading, LoungeError] when getting data fails',
      () async {
        // arrange
        final failure = ServerFailure(code: 500, message: "unexpected error");
        when(() => mockGetLounge(any())).thenAnswer(
          (_) async => Left(
            failure,
          ),
        );
        // assert later
        final expected = [
          LoungeLoading(),
          LoungeError(
            message: failure.message,
            code: failure.code,
          ),
        ];
        expectLater(loungeBloc.stream, emitsInOrder(expected));
        // act
        loungeBloc.add(GetLoungeEvent());
      },
    );
  });
}
