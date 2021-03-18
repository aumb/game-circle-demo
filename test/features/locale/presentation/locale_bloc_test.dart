import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/locale/domain/usecases/get_cached_locale.dart';
import 'package:gamecircle/features/locale/presentation/bloc/locale_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCachedLocale extends Mock implements GetCachedLocale {}

void main() {
  late LocaleBloc localeBloc;
  late MockGetCachedLocale mockGetCachedLocale;

  setUp(() {
    registerFallbackValue<NoParams>(NoParams());
    mockGetCachedLocale = MockGetCachedLocale();
    localeBloc = LocaleBloc(
      getCachedLocale: mockGetCachedLocale,
    );
  });

  group('getCachedLocale', () {
    final tLocale = Locale('en');

    test(
      'should get data from the local use case',
      () async {
        // arrange
        when(() => mockGetCachedLocale(any()))
            .thenAnswer((_) async => Right(tLocale));
        // act
        localeBloc.add(GetCachedLocaleEvent());
        await untilCalled(() => mockGetCachedLocale(any()));
        // assert
        verify(
          () => mockGetCachedLocale(
            NoParams(),
          ),
        );
      },
    );

    test(
      'should emit [LocaleState] when data is gotten successfully',
      () async {
        // arrange
        // setUpMockInputConverterSuccess();
        when(() => mockGetCachedLocale(any()))
            .thenAnswer((_) async => Right(tLocale));
        // assert later
        final expected = [
          LoadingLocale(),
          LocaleState(
            locale: tLocale,
          ),
        ];
        expectLater(localeBloc, emitsInOrder(expected));
        // act
        localeBloc.add(GetCachedLocaleEvent());
      },
    );

    test(
      'should emit [LocaleError] when getting data fails',
      () async {
        // arrange
        final failure = ServerFailure(code: 500, message: "unexpected_error");
        when(() => mockGetCachedLocale(any())).thenAnswer(
          (_) async => Left(
            failure,
          ),
        );
        // assert later
        final expected = [
          LoadingLocale(),
          LocaleError(
            message: failure.message,
          ),
        ];
        expectLater(localeBloc, emitsInOrder(expected));
        // act
        localeBloc.add(GetCachedLocaleEvent());
      },
    );
  });
}
