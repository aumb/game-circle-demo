import 'package:dio/dio.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:gamecircle/core/api.dart';
import 'package:gamecircle/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:gamecircle/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:gamecircle/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:gamecircle/features/authentication/domain/usecases/get_cached_token.dart';
import 'package:gamecircle/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:gamecircle/features/home/data/datasources/user_remote_data_source.dart';
import 'package:gamecircle/features/home/data/repositories/user_repository_impl.dart';
import 'package:gamecircle/features/home/domain/repositories/user_repository.dart';
import 'package:gamecircle/features/home/domain/usecases/get_current_user_info.dart';
import 'package:gamecircle/features/home/domain/usecases/get_user_info.dart';
import 'package:gamecircle/features/home/presentation/bloc/home_bloc.dart';
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

  sl.registerFactory(
    () => HomeBloc(getCurrentUserInfo: sl()),
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

  //User
  sl.registerLazySingleton(() => GetCurrentUserInfo(sl()));
  sl.registerLazySingleton(() => GetUserInfo(sl()));

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
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: sl(),
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

  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(client: sl()),
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
    )..interceptors.addAll([
        LogInterceptor(),
        InterceptorsWrapper(onError: (e) {
          final RequestOptions options = e.response!.request;
          if (e.response?.statusCode == 401) {
            sl<Dio>().lock();
            sl<Dio>().interceptors.responseLock.lock();
            sl<Dio>().interceptors.errorLock.lock();

            return Dio()
                .post(
              "http://192.168.10.12/api/refresh_token",
              data: FormData.fromMap({
                "token":
                    "def502002bb8b5a246e7171acc02b26116a2f0d7e1ce8dad2a26202ddc2c2cf40b28195b3202c8833f8b08f4f95d172bd4e60a3e239c712c79300f301cfed4c8a9e536d25836e513ec1d1c31879eaf584d4984db42f91d7d70ca1bb26a5d156c66482db4c1f8a917586c37ac39fcf5cb17637ee3279667981d7143a14ed90d5ad2ba1f3b15392260af7ba1f95186e0e98faeae90389f1a33ed0ef3a79290b33791c77dd950ae0adc8e6e3ff55789c33b767612f81c3c75c81af26a4c4d6d79626e4e50bca0c3d8684bdd9888e88fc5d5f7c60801dc3c68686676d6f4a4af94eee2a5ea75aa9e623e4199dcb12bc24a8854fb4180e497bd1985bf7a37bce81a501e5c0cb5d0ed449950917b4dea4026377fbbd6dbe61b3af909781024768c0de7baf04e14e109d2b8a5f0df375e7795ac5c71f4c14beaf59129c84418b73a382a8151e93515c05cdde3f210fa4a41878ba4e2ec75fe1d1f06d16e1c0227cba7c83947d0c5e8"
              }),
            )
                .whenComplete(() {
              sl<Dio>().unlock();
              sl<Dio>().interceptors.responseLock.unlock();
              sl<Dio>().interceptors.errorLock.unlock();
            }).then((value) {
              return sl<Dio>().fetch(options);
            });
          }
          return e;
        }),
      ]),
  );
}
