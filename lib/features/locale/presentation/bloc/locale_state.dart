part of 'locale_bloc.dart';

class LocaleState extends Equatable {
  final Locale? locale;

  const LocaleState({this.locale});

  LocaleState copyWith({
    Locale? locale,
  }) {
    return LocaleState(
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [];
}

class LocaleInitial extends LocaleState {}

class LoadingLocale extends LocaleState {}

class LoadedLocale extends LocaleState {
  final Locale? locale;

  LoadedLocale({required this.locale});

  @override
  List<Object?> get props => [locale];
}

class LocaleError extends LocaleState {
  final String? message;

  LocaleError({required this.message});

  @override
  List<Object?> get props => [message];
}
