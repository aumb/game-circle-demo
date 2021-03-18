import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/locale/domain/usecases/get_cached_locale.dart';

part 'locale_event.dart';
part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  final GetCachedLocale getCachedLocale;

  LocaleBloc({
    required this.getCachedLocale,
  }) : super(LocaleInitial());

  @override
  Stream<LocaleState> mapEventToState(
    LocaleEvent event,
  ) async* {
    if (event is GetCachedLocaleEvent) {
      final failureOrLocale = await getCachedLocale(NoParams());
      yield LoadingLocale();
      yield* _handleLocaleState(failureOrLocale);
    }
  }

  Stream<LocaleState> _handleLocaleState(
    Either<Failure, Locale?> failureOrToken,
  ) async* {
    yield failureOrToken.fold((failure) {
      return _handleFailureEvent(failure);
    }, (locale) {
      return state.copyWith(locale: locale);
    });
  }

  LocaleError _handleFailureEvent(Failure failure) {
    LocaleError error;
    if (failure is ServerFailure) {
      error = LocaleError(message: failure.message);
    } else {
      error = LocaleError(message: "unexpected_error");
    }

    return error;
  }
}
