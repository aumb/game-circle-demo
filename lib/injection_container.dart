import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:gamecircle/core/api.dart';
import 'package:gamecircle/core/managers/dynamic_links_manager.dart';
import 'package:gamecircle/core/managers/navgiation_manager.dart';
import 'package:gamecircle/core/managers/notifications_manager.dart';
import 'package:gamecircle/core/managers/session_manager.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/core/utils/safe_print.dart';
import 'package:gamecircle/core/utils/string_utils.dart';
import 'package:gamecircle/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:gamecircle/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:gamecircle/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:gamecircle/features/authentication/domain/usecases/get_cached_token.dart';
import 'package:gamecircle/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:gamecircle/features/dynamic_links/presentation/bloc/dynamic_links_bloc.dart';
import 'package:gamecircle/features/favorites/data/datasources/favorites_remote_data_source.dart';
import 'package:gamecircle/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:gamecircle/features/favorites/domain/usecases/get_favorite_lounges.dart';
import 'package:gamecircle/features/favorites/domain/usecases/get_more_favorite_lounges.dart';
import 'package:gamecircle/features/favorites/domain/usecases/toggle_lounge_favorite_status.dart';
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
import 'package:gamecircle/features/lounge/data/datasources/lounge_remote_data_source.dart';
import 'package:gamecircle/features/lounge/data/repositories/lounge_repository_impl.dart';
import 'package:gamecircle/features/lounge/domain/respositories/lounge_repository.dart';
import 'package:gamecircle/features/lounge/domain/usecases/get_lounge.dart';
import 'package:gamecircle/features/lounge/presentation/cubit/games_search_cubit.dart';
import 'package:gamecircle/features/lounges/data/datasources/lounges_remote_data_source.dart';
import 'package:gamecircle/features/lounges/data/respositories/lounges_repository_impl.dart';
import 'package:gamecircle/features/lounges/domain/entities/game.dart';
import 'package:gamecircle/features/lounges/domain/repositories/lounges_repository.dart';
import 'package:gamecircle/features/lounges/domain/usecases/get_lounges.dart';
import 'package:gamecircle/features/lounges/domain/usecases/get_more_lounges.dart';
import 'package:gamecircle/features/lounges/presentation/bloc/lounges_bloc.dart';
import 'package:gamecircle/features/lounges/presentation/cubit/lounges_search_cubit.dart';
import 'package:gamecircle/features/notifications/presentation/bloc/notifications_bloc.dart';
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
import 'package:gamecircle/features/reviews/domain/entities/review.dart';
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
import 'features/lounge/presentation/bloc/lounge_bloc.dart';
import 'features/lounges/domain/entities/lounge.dart';
import 'features/reviews/presentation/blocs/add_edit_review_bloc/add_edit_review_bloc.dart';
import 'features/reviews/presentation/blocs/lounge_reviews_bloc/lounge_reviews_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  _initBlocs();

  // Managers
  _initManagers();

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
  _initLoungeUseCases();

  // Repositories
  _initRepositories();
  // Data sources
  _initDataSources();
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

  sl.registerLazySingleton(
    () => DynamicLinksBloc(
      navigationManager: sl(),
      authenticationBloc: sl(),
      dynamicLinksManager: sl(),
      sessionManager: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => NotificationsBloc(
      notificationsManager: sl(),
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

  sl.registerFactoryParam<AddEditReviewBloc, Review?, void>((
    Review? review,
    _,
  ) =>
      AddEditReviewBloc(
        review: review,
        patchLoungeReview: sl(),
        postLoungeReview: sl(),
        deleteLoungeReview: sl(),
      ));

  sl.registerFactoryParam<LoungeBloc, Lounge?, void>((
    Lounge? lounge,
    _,
  ) =>
      LoungeBloc(
        lounge: lounge!,
        getLounge: sl(),
        toggleLoungeFavoriteStatus: sl(),
      ));

  sl.registerFactoryParam<GamesSearchCubit, List<Game?>?, void>((
    List<Game?>? games,
    _,
  ) =>
      GamesSearchCubit(
        games: games,
      ));

  sl.registerFactoryParam<LoungeReviewsBloc, Lounge?, void>((
    Lounge? lounge,
    _,
  ) =>
      LoungeReviewsBloc(
        lounge: lounge!,
        getLoungeReviews: sl(),
        getMoreLoungeReviews: sl(),
      ));
}

//Usecases

void _initLoungeUseCases() {
  sl.registerLazySingleton(() => GetLounge(sl()));
}

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
  sl.registerLazySingleton(() => ToggleLoungeFavoriteStatus(sl()));
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
  sl.registerLazySingleton<LoungeRepository>(
    () => LoungeRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );
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
  sl.registerLazySingleton(() => DynamicLinksManager());
  sl.registerLazySingleton(() => NavigationManager());
  sl.registerLazySingleton(() => NotificationsManager());
}

void _initDataSources() {
  sl.registerLazySingleton<LoungeRemoteDataSource>(
    () => LoungeRemoteDataSourceImpl(
      client: sl(),
    ),
  );

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
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  _initDio();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  safePrint("Notification ${message.messageId} recieved succesfully");
  // sl<NotificationsBloc>().add(HandleNotificationEvent(remoteMessage: message));
}

void _initDio() {
  sl.registerLazySingleton(
    () => Dio(
      BaseOptions(baseUrl: API.base),
    )..interceptors.addAll([
        LogInterceptor(request: true),
        InterceptorsWrapper(
            onError: (e, handler) => _handleInterceptorError(e, handler)),
      ]),
  );
}

_ensureParsable(Response<dynamic>? response) {
  dynamic responseData = response?.data;

  Map<String, dynamic> _mockError = {
    "error": "unexpected_error",
    "code": 500,
  };

  if (responseData is Map) {
    if (responseData.keys.contains("error") &&
        responseData.keys.contains("code")) {
      return response;
    } else {
      response?.data = _mockError;
      return response;
    }
  } else {
    response?.data = _mockError;
    return response;
  }
}

void _handleInterceptorError(
    DioError e, ErrorInterceptorHandler handler) async {
  final RequestOptions options =
      e.response?.requestOptions ?? RequestOptions(path: "failed");
  if (e.response?.statusCode == 401 &&
      StringUtils().isNotEmpty(options.headers['Authorization'])) {
    sl<Dio>().lock();
    sl<Dio>().interceptors.responseLock.lock();
    sl<Dio>().interceptors.errorLock.lock();

    return handler.resolve(await _handleUnauthorizedError(options));
  } else {
    final dioError = DioError(
      requestOptions: options,
      response: _ensureParsable(e.response),
      type: e.type,
      error: e.error,
    );
    return handler.reject(dioError);
  }
}

Future<Response<dynamic>> _handleUnauthorizedError(
    RequestOptions options) async {
  final client = Dio();
  final localToken = await sl<AuthenticationLocalDataSource>().getCachedToken();

  return client
      .post(
    API.refreshToken,
    data: FormData.fromMap({
      "token": localToken?.refreshToken,
    }),
  )
      .catchError((e) async {
    final postLogoutUser = sl<PostLogoutUser>();
    final response = await postLogoutUser(NoParams());
    response.fold(
      (l) {
        final userLocalDataSource = sl<UserLocalDataSource>();
        userLocalDataSource.deleteCachedToken();
      },
      (r) => null,
    );

    sl<NavigationManager>().popTillFirst();
    sl<AuthenticationBloc>().add(GetCachedTokenEvent());
  }).whenComplete(() {
    sl<Dio>().unlock();
    sl<Dio>().interceptors.responseLock.unlock();
    sl<Dio>().interceptors.errorLock.unlock();
  }).then(
    (value) {
      return sl<Dio>().fetch(options);
    },
  );
}
