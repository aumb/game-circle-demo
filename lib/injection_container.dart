import 'package:dio/dio.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:gamecircle/core/api.dart';
import 'package:gamecircle/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:gamecircle/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:gamecircle/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:gamecircle/features/authentication/domain/usecases/get_cached_token.dart';
import 'package:gamecircle/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:gamecircle/features/locale/data/datasources/locale_local_data_source.dart';
import 'package:gamecircle/features/locale/data/repositories/locale_repository_impl.dart';
import 'package:gamecircle/features/locale/domain/repositories/locale_repository.dart';
import 'package:gamecircle/features/locale/domain/usecases/get_cached_locale.dart';
import 'package:gamecircle/features/locale/presentation/bloc/locale_bloc.dart';
import 'package:gamecircle/features/login/data/datasources/login_local_data_source.dart';
import 'package:gamecircle/features/login/data/datasources/login_remote_data_source.dart';
import 'package:gamecircle/features/login/data/repositories/login_repository_impl.dart';
import 'package:gamecircle/features/login/domain/repositories/login_repository.dart';
import 'package:gamecircle/features/login/domain/usecases/post_email_login.dart';
import 'package:gamecircle/features/login/domain/usecases/post_facebook_login.dart';
import 'package:gamecircle/features/login/domain/usecases/post_google_login.dart';
import 'package:gamecircle/features/login/domain/usecases/post_social_login.dart';
import 'package:gamecircle/features/login/presentation/bloc/login_bloc.dart';
import 'package:gamecircle/features/login/presentation/bloc/login_form_bloc.dart';
import 'package:gamecircle/features/registration/data/datasources/registration_local_data_source.dart';
import 'package:gamecircle/features/registration/data/datasources/registration_remote_data_source.dart';
import 'package:gamecircle/features/registration/data/repositories/registration_repository_impl.dart';
import 'package:gamecircle/features/registration/domain/repository/registration_repository.dart';
import 'package:gamecircle/features/registration/domain/usecases/post_email_registration.dart';
import 'package:gamecircle/features/registration/presentation/bloc/registration_bloc.dart';
import 'package:gamecircle/features/registration/presentation/bloc/registration_form_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(
    () => LoginBloc(
      postEmailLogin: sl(),
      postSocialLogin: sl(),
      postGoogleLogin: sl(),
      postFacebookLogin: sl(),
      authenticationBloc: sl(),
    ),
  );

  sl.registerFactory(
    () => LoginFormBloc(),
  );

  sl.registerFactory(
    () =>
        RegistrationBloc(authenticationBloc: sl(), postEmailRegistration: sl()),
  );

  sl.registerFactory(
    () => RegistrationFormBloc(),
  );

  sl.registerLazySingleton(
    () => AuthenticationBloc(
      getCachedToken: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => LocaleBloc(
      getCachedLocale: sl(),
    ),
  );

  // Use cases

  //Login
  sl.registerLazySingleton(() => PostEmailLogin(sl()));
  sl.registerLazySingleton(() => PostSocialLogin(sl()));
  sl.registerLazySingleton(() => PostGoogleLogin(sl()));
  sl.registerLazySingleton(() => PostFacebookLogin(sl()));

  //Authentication
  sl.registerLazySingleton(() => GetCachedToken(sl()));

  //Registration
  sl.registerLazySingleton(() => PostEmailRegistration(sl()));

  //Locale
  sl.registerLazySingleton(() => GetCachedLocale(sl()));

  // Repositories
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRespositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<RegistrationRepository>(
    () => RegistrationRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<LocaleRepository>(
    () => LocaleRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(
        client: sl(), googleSignIn: sl(), facebookSignIn: sl()),
  );

  sl.registerLazySingleton<LoginLocalDataSource>(
    () => LoginLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<AuthenticationLocalDataSource>(
    () => AuthenticationLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<RegistrationLocalDataSource>(
    () => RegistrationLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<RegistrationRemoteDataSource>(
    () => RegistrationRemoteDataSourceImpl(
      client: sl(),
    ),
  );

  sl.registerLazySingleton<LocaleLocalDataSource>(
    () => LocaleLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => FacebookAuth.instance);
  sl.registerLazySingleton(
    () => GoogleSignIn(
      scopes: [
        'email',
      ],
    ),
  );

  sl.registerLazySingleton(
    () => Dio(
      BaseOptions(baseUrl: API.base),
    )..interceptors.add(
        LogInterceptor(),
      ),
  );
}
