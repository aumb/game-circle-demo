import 'dart:convert';
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/models/pagination_model.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/lounges/data/models/lounge_model.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';
import 'package:gamecircle/features/lounges/domain/usecases/get_lounges.dart';
import 'package:gamecircle/features/lounges/domain/usecases/get_more_lounges.dart';
import 'package:gamecircle/features/lounges/presentation/bloc/lounges_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';

class MockGetLounges extends Mock implements GetLounges {}

class MockGetMoreLounges extends Mock implements GetMoreLounges {}

void main() {
  late LoungesBloc loungesBloc;
  late MockGetLounges mockGetLounges;
  late MockGetMoreLounges mockGetMoreLounges;

  setUp(() {
    registerFallbackValue<NoParams>(NoParams());
    registerFallbackValue<GetLoungesParams>(GetLoungesParams(
      longitude: 33,
      latitude: 34,
      sortBy: 'distance',
      query: null,
    ));
    mockGetLounges = MockGetLounges();
    mockGetMoreLounges = MockGetMoreLounges();
    loungesBloc = LoungesBloc(
      getLounges: mockGetLounges,
      getMoreLounges: mockGetMoreLounges,
    );
  });

  group('getLounges', () {
    final tPagination = PaginationModel.fromJson(
      json.decode(
        fixture('lounges.json'),
      ),
    );
    final tLounges = LoungeModel.fromJsonList(tPagination.items);

    test(
      'should get data from the local use case',
      () async {
        // arrange
        // setUpMockInputConverterSuccess();
        when(() => mockGetLounges(any()))
            .thenAnswer((_) async => Right(tLounges));
        // act
        loungesBloc.add(GetLoungesEvent());
        await untilCalled(() => mockGetLounges(any()));
        // assert
        verify(
          () => mockGetLounges(GetLoungesParams(
            longitude: 33,
            latitude: 34,
            sortBy: 'distance',
            query: null,
          )),
        );
      },
    );

    test(
      'should emit [LoungesLoading, LoungesLoaded] when data is gotten successfully',
      () async {
        // arrange
        // setUpMockInputConverterSuccess();
        when(() => mockGetLounges(any()))
            .thenAnswer((_) async => Right(tLounges));
        // assert later
        final expected = [
          // LoungesLoading(),
          LoungesLoaded(),
        ];
        expectLater(loungesBloc, emitsInOrder(expected)).then((value) {
          expect(loungesBloc.lounges, equals(tLounges));
        });
        // act
        loungesBloc.add(GetLoungesEvent());
      },
    );

    test(
      'should emit [LoungesLoading, LoungesError] when getting data fails',
      () async {
        // arrange
        final failure = ServerFailure(code: 500, message: "unexpected error");
        when(() => mockGetLounges(any())).thenAnswer(
          (_) async => Left(
            failure,
          ),
        );
        // assert later
        final expected = [
          // LoungesLoading(),
          LoungesError(
            message: failure.message,
          ),
        ];
        expectLater(loungesBloc, emitsInOrder(expected));
        // act
        loungesBloc.add(GetLoungesEvent());
      },
    );
  });

  group('getMoreLounges', () {
    final tPagination = PaginationModel.fromJson(
      json.decode(
        fixture('lounges.json'),
      ),
    );
    final tLounges = LoungeModel.fromJsonList(tPagination.items);

    test(
      'should get data from the use case',
      () async {
        // arrange
        when(() => mockGetMoreLounges(any()))
            .thenAnswer((_) async => Right(tLounges));
        // act
        loungesBloc.add(GetMoreLoungesEvent());
        await untilCalled(() => mockGetMoreLounges(any()));
        // assert
        verify(
          () => mockGetMoreLounges(GetLoungesParams(
            longitude: 33,
            latitude: 34,
            sortBy: 'distance',
            query: null,
          )),
        );
      },
    );

    test(
      'should emit [LoungesLoadingMore, LoungesLoadedMore] when data is gotten successfully',
      () async {
        final List<Lounge?> lounges = loungesBloc.lounges;
        // arrange
        // setUpMockInputConverterSuccess();
        when(() => mockGetMoreLounges(any()))
            .thenAnswer((_) async => Right(tLounges));
        // assert later
        final expected = [
          LoungesLoadingMore(),
          LoungesLoadedMore(),
        ];
        expectLater(loungesBloc, emitsInOrder(expected)).then((value) {
          lounges.addAll(tLounges);
          expect(loungesBloc.lounges, equals(lounges));
        });
        // act
        loungesBloc.add(GetMoreLoungesEvent());
      },
    );

    test(
      'should emit [LoungesLoading, LoungesErrorMore] when getting data fails',
      () async {
        // arrange
        final failure = ServerFailure(code: 500, message: "unexpected error");
        when(() => mockGetMoreLounges(any())).thenAnswer(
          (_) async => Left(
            failure,
          ),
        );
        // assert later
        final expected = [
          LoungesLoadingMore(),
          LoungesErrorMore(
            message: failure.message,
          ),
        ];
        expectLater(loungesBloc, emitsInOrder(expected));
        // act
        loungesBloc.add(GetMoreLoungesEvent());
      },
    );

    test(
      'should stop loading more when an empty lounges list is returned',
      () async {
        // arrange
        // setUpMockInputConverterSuccess();
        when(() => mockGetMoreLounges(any()))
            .thenAnswer((_) async => Right([]));
        // assert later
        final expected = [
          LoungesLoadingMore(),
          LoungesLoadedMore(),
        ];
        expectLater(loungesBloc, emitsInOrder(expected)).then((value) {
          expect(loungesBloc.canGetMoreLounges, equals(false));
        });
        // act
        loungesBloc.add(GetMoreLoungesEvent());
      },
    );
  });
}
