import 'package:dio/dio.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:gamecircle/core/api.dart';
import 'package:gamecircle/core/managers/session_manager.dart';
import 'package:gamecircle/core/utils/string_utils.dart';
import 'package:gamecircle/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:gamecircle/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:gamecircle/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:gamecircle/features/authentication/domain/usecases/get_cached_token.dart';
import 'package:gamecircle/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:gamecircle/features/favorites/data/datasources/favorites_remote_data_source.dart';
import 'package:gamecircle/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:gamecircle/features/favorites/domain/usecases/get_favorite_lounges.dart';
import 'package:gamecircle/features/favorites/domain/usecases/get_more_favorite_lounges.dart';
import 'package:gamecircle/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:gamecircle/features/home/data/datasources/user_remote_data_source.dart';
import 'package:gamecircle/features/home/data/repositories/user_repository_impl.dart';
import 'package:gamecircle/features/home/domain/repositories/user_repository.dart';
import 'package:gamecircle/features/home/domain/usecases/get_current_user_info.dart';
import 'package:gamecircle/features/home/domain/usecases/get_current_user_location.dart';
import 'package:gamecircle/features/home/domain/usecases/get_user_info.dart';
import 'package:gamecircle/features/home/domain/usecases/post_logout_user.dart';
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
import 'package:gamecircle/features/logout/presentation/cubit/logout_cubit.dart';
import 'package:gamecircle/features/lounges/data/datasources/lounges_remote_data_source.dart';
import 'package:gamecircle/features/lounges/data/respositories/lounges_repository_impl.dart';
import 'package:gamecircle/features/lounges/domain/repositories/lounges_repository.dart';
import 'package:gamecircle/features/lounges/domain/usecases/get_lounges.dart';
import 'package:gamecircle/features/lounges/domain/usecases/get_more_lounges.dart';
import 'package:gamecircle/features/lounges/presentation/bloc/lounges_bloc.dart';
import 'package:gamecircle/features/lounges/presentation/cubit/lounges_search_cubit.dart';
import 'package:gamecircle/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:gamecircle/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:gamecircle/features/profile/domain/repositories/profile_repository.dart';
import 'package:gamecircle/features/profile/domain/usecases/post_user_information.dart';
import 'package:gamecircle/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:gamecircle/features/registration/data/datasources/registration_local_data_source.dart';
import 'package:gamecircle/features/registration/data/datasources/registration_remote_data_source.dart';
import 'package:gamecircle/features/registration/data/repositories/registration_repository_impl.dart';
import 'package:gamecircle/features/registration/domain/repository/registration_repository.dart';
import 'package:gamecircle/features/registration/domain/usecases/post_email_registration.dart';
import 'package:gamecircle/features/registration/presentation/bloc/registration_bloc.dart';
import 'package:gamecircle/features/registration/presentation/bloc/registration_form_bloc.dart';
import 'package:gamecircle/features/reviews/data/datasources/reviews_remote_data_source.dart';
import 'package:gamecircle/features/reviews/data/datasources/reviews_remote_data_source_impl.dart';
import 'package:gamecircle/features/reviews/data/repositories/reviews_repository_impl.dart';
import 'package:gamecircle/features/reviews/domain/repositories/reviews_repository.dart';
import 'package:gamecircle/features/reviews/domain/usecases/delete_lounge_review.dart';
import 'package:gamecircle/features/reviews/domain/usecases/get_lounge_reviews.dart';
import 'package:gamecircle/features/reviews/domain/usecases/get_more_lounge_reviews.dart';
import 'package:gamecircle/features/reviews/domain/usecases/get_more_user_reviews.dart';
import 'package:gamecircle/features/reviews/domain/usecases/get_user_reviews.dart';
import 'package:gamecircle/features/reviews/domain/usecases/patch_lounge_review.dart';
import 'package:gamecircle/features/reviews/domain/usecases/post_lounge_review.dart';
import 'package:gamecircle/features/reviews/presentation/blocs/user_reviews_bloc/user_reviews_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/favorites/data/repositories/favorites_repository_impl.dart';
import 'features/home/data/datasources/user_local_data_source.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  _initBlocs();

  // Singleton blocs
  _initSingletonBlocs();

  // Use cases
  _initLoginUseCases();
  _initAuthenticationUseCases();
  _initRegistrationUseCases();
  _initLocaleUseCases();
  _initUsersUseCases();
  _initLoungesUseCases();
  _initProfileUseCases();
  _initFavoritesUseCases();
  _initReviewsUseCases();

  // Repositories
  _initRepositories();
  // Data sources
  _initDataSources();

  // Managers
  _initManagers();
  // External
  await _initExternal();
}

//Blocs
void _initBlocs() {
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
    () => HomeBloc(
      getCurrentUserInfo: sl(),
      getCurrentUserLocation: sl(),
      sessionManager: sl(),
    ),
  );

  sl.registerFactory(
    () => LogoutCubit(
      postLogoutUser: sl(),
      authenticationBloc: sl(),
    ),
  );

  sl.registerFactory(
    () => LoungesSearchCubit(
      getLounges: sl(),
      getMoreLounges: sl(),
    ),
  );

  sl.registerFactory(
    () => LoungesBloc(
      getLounges: sl(),
      getMoreLounges: sl(),
      sessionManager: sl(),
    ),
  );
}

void _initSingletonBlocs() {
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

  sl.registerFactory(
    () => ProfileCubit(
      sessionManager: sl(),
      postUserInformation: sl(),
    ),
  );

  sl.registerFactory(
    () => FavoritesBloc(
      getFavoriteLounges: sl(),
      getMoreFavoriteLounges: sl(),
    ),
  );

  sl.registerFactory(
    () => UserReviewsBloc(
      getMoreUserReviews: sl(),
      getUserReviews: sl(),
    ),
  );
}

//Usecases

void _initReviewsUseCases() {
  sl.registerLazySingleton(() => GetUserReviews(sl()));
  sl.registerLazySingleton(() => GetMoreUserReviews(sl()));
  sl.registerLazySingleton(() => GetLoungeReviews(sl()));
  sl.registerLazySingleton(() => GetMoreLoungeReviews(sl()));
  sl.registerLazySingleton(() => PostLoungeReview(sl()));
  sl.registerLazySingleton(() => PatchLoungeReview(sl()));
  sl.registerLazySingleton(() => DeleteLoungeReview(sl()));
}

void _initFavoritesUseCases() {
  sl.registerLazySingleton(() => GetFavoriteLounges(sl()));
  sl.registerLazySingleton(() => GetMoreFavoriteLounges(sl()));
}

void _initProfileUseCases() {
  sl.registerLazySingleton(() => PostUserInformation(sl()));
}

void _initLoginUseCases() {
  sl.registerLazySingleton(() => PostEmailLogin(sl()));
  sl.registerLazySingleton(() => PostSocialLogin(sl()));
  sl.registerLazySingleton(() => PostGoogleLogin(sl()));
  sl.registerLazySingleton(() => PostFacebookLogin(sl()));
}

void _initAuthenticationUseCases() {
  sl.registerLazySingleton(() => GetCachedToken(sl()));
}

void _initRegistrationUseCases() {
  sl.registerLazySingleton(() => PostEmailRegistration(sl()));
}

void _initLocaleUseCases() {
  sl.registerLazySingleton(() => GetCachedLocale(sl()));
}

void _initUsersUseCases() {
  sl.registerLazySingleton(() => GetCurrentUserInfo(sl()));
  sl.registerLazySingleton(() => GetUserInfo(sl()));
  sl.registerLazySingleton(() => PostLogoutUser(sl()));
  sl.registerLazySingleton(() => GetCurrentUserLocation(sl()));
}

void _initLoungesUseCases() {
  sl.registerLazySingleton(() => GetLounges(sl()));
  sl.registerLazySingleton(() => GetMoreLounges(sl()));
}

void _initRepositories() {
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
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<LoungesRepository>(
    () => LoungesRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<ReviewsRepository>(
    () => ReviewsRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );
}

void _initManagers() {
  sl.registerLazySingleton(() => SessionManager());
}

void _initDataSources() {
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

  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<LoungesRemoteDataSource>(
    () => LoungesRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<FavoritesRemoteDataSource>(
    () => FavoritesRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<ReviewsRemoteDataSource>(
    () => ReviewsRemoteDataSourceImpl(client: sl()),
  );
}

Future<void> _initExternal() async {
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

  _initDio();
}

void _initDio() {
  sl.registerLazySingleton(
    () => Dio(
      BaseOptions(baseUrl: API.base),
    )..interceptors.addAll([
        LogInterceptor(request: true),
        InterceptorsWrapper(onError: (e, handler) async {
          final client = Dio();
          final RequestOptions options = e.response!.requestOptions;
          if (e.response?.statusCode == 401 &&
              StringUtils().isNotEmpty(options.headers['Authorization'])) {
            sl<Dio>().lock();
            sl<Dio>().interceptors.responseLock.lock();
            sl<Dio>().interceptors.errorLock.lock();

            return handler.resolve(
              await client
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
              }).then(
                (value) {
                  return sl<Dio>().fetch(options);
                },
              ),
            );
          }
          return handler.reject(e);
        }),
      ]),
  );
}
