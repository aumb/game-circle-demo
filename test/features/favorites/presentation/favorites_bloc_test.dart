import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/models/pagination_model.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/favorites/domain/usecases/get_favorite_lounges.dart';
import 'package:gamecircle/features/favorites/domain/usecases/get_more_favorite_lounges.dart';
import 'package:gamecircle/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:gamecircle/features/lounges/data/models/lounge_model.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';

import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';

class MockGetFavoriteLounges extends Mock implements GetFavoriteLounges {}

class MockGetMoreFavoriteLounges extends Mock
    implements GetMoreFavoriteLounges {}

void main() {
  late FavoritesBloc favoritesBloc;
  late GetFavoriteLounges mockGetFavoriteLounges;
  late GetMoreFavoriteLounges mockGetMoreFavoriteLounges;

  setUp(() {
    registerFallbackValue<NoParams>(NoParams());
    mockGetFavoriteLounges = MockGetFavoriteLounges();
    mockGetMoreFavoriteLounges = MockGetMoreFavoriteLounges();
    favoritesBloc = FavoritesBloc(
      getFavoriteLounges: mockGetFavoriteLounges,
      getMoreFavoriteLounges: mockGetMoreFavoriteLounges,
    );
  });

  group('getFavoriteLounges', () {
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
        when(() => mockGetFavoriteLounges(any()))
            .thenAnswer((_) async => Right(tLounges));
        // act
        favoritesBloc.add(GetFavoriteLoungesEvent());
        await untilCalled(() => mockGetFavoriteLounges(any()));
        // assert
        verify(
          () => mockGetFavoriteLounges(NoParams()),
        );
      },
    );

    test(
      'should emit [FavoritesLoading, FavoritesLoaded] when data is gotten successfully',
      () async {
        // arrange
        // setUpMockInputConverterSuccess();
        when(() => mockGetFavoriteLounges(any()))
            .thenAnswer((_) async => Right(tLounges));
        // assert later
        final expected = [
          FavoritesLoading(),
          FavoritesLoaded(),
        ];
        expectLater(favoritesBloc.stream, emitsInOrder(expected)).then((value) {
          expect(favoritesBloc.lounges, equals(tLounges));
        });
        // act
        favoritesBloc.add(GetFavoriteLoungesEvent());
      },
    );

    test(
      'should emit [FavoritesLoading, FavoritesError] when getting data fails',
      () async {
        // arrange
        final failure = ServerFailure(code: 500, message: "unexpected error");
        when(() => mockGetFavoriteLounges(any())).thenAnswer(
          (_) async => Left(
            failure,
          ),
        );
        // assert later
        final expected = [
          FavoritesLoading(),
          FavoritesError(
            message: failure.message,
          ),
        ];
        expectLater(favoritesBloc.stream, emitsInOrder(expected));
        // act
        favoritesBloc.add(GetFavoriteLoungesEvent());
      },
    );
  });

  group('getMoreFavoriteLounges', () {
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
        when(() => mockGetMoreFavoriteLounges(any()))
            .thenAnswer((_) async => Right(tLounges));
        // act
        favoritesBloc.add(GetMoreFavoriteLoungesEvent());
        await untilCalled(() => mockGetMoreFavoriteLounges(any()));
        // assert
        verify(
          () => mockGetMoreFavoriteLounges(NoParams()),
        );
      },
    );

    test(
      'should emit [FavoritesLoadingMore, FavoritesLoadedMore] when data is gotten successfully',
      () async {
        final List<Lounge?> lounges = favoritesBloc.lounges;
        // arrange
        // setUpMockInputConverterSuccess();
        when(() => mockGetMoreFavoriteLounges(any()))
            .thenAnswer((_) async => Right(tLounges));
        // assert later
        final expected = [
          FavoritesLoadingMore(),
          FavoritesLoadedMore(),
        ];
        expectLater(favoritesBloc.stream, emitsInOrder(expected)).then((value) {
          lounges.addAll(tLounges);
          expect(favoritesBloc.lounges, equals(lounges));
        });
        // act
        favoritesBloc.add(GetMoreFavoriteLoungesEvent());
      },
    );

    test(
      'should emit [FavoritesLoadingMore, FavoritesErrorMore] when getting data fails',
      () async {
        // arrange
        final failure = ServerFailure(code: 500, message: "unexpected error");
        when(() => mockGetMoreFavoriteLounges(any())).thenAnswer(
          (_) async => Left(
            failure,
          ),
        );
        // assert later
        final expected = [
          FavoritesLoadingMore(),
          FavoritesErrorMore(
            message: failure.message,
          ),
        ];
        expectLater(favoritesBloc.stream, emitsInOrder(expected));
        // act
        favoritesBloc.add(GetMoreFavoriteLoungesEvent());
      },
    );

    test(
      'should stop loading more when an empty lounges list is returned',
      () async {
        // arrange
        // setUpMockInputConverterSuccess();
        when(() => mockGetMoreFavoriteLounges(any()))
            .thenAnswer((_) async => Right([]));
        // assert later
        final expected = [
          FavoritesLoadingMore(),
          FavoritesLoadedMore(),
        ];
        expectLater(favoritesBloc.stream, emitsInOrder(expected)).then((value) {
          expect(favoritesBloc.canGetMoreLounges, equals(false));
        });
        // act
        favoritesBloc.add(GetMoreFavoriteLoungesEvent());
      },
    );
  });
}
