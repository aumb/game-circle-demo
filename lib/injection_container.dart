import 'package:dio/dio.dart';
import 'package:gamecircle/core/api.dart';
import 'package:gamecircle/features/login/data/datasources/login_local_data_source.dart';
import 'package:gamecircle/features/login/data/datasources/login_remote_data_source.dart';
import 'package:gamecircle/features/login/data/repositories/login_repository_impl.dart';
import 'package:gamecircle/features/login/domain/repositories/login_repository.dart';
import 'package:gamecircle/features/login/domain/usecases/post_email_login.dart';
import 'package:gamecircle/features/login/domain/usecases/post_google_login.dart';
import 'package:gamecircle/features/login/domain/usecases/post_social_login.dart';
import 'package:gamecircle/features/login/presentation/bloc/login_bloc.dart';
import 'package:gamecircle/features/login/presentation/bloc/login_form_bloc.dart';
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
    ),
  );

  sl.registerFactory(
    () => LoginFormBloc(),
  );

  // Use cases
  sl.registerLazySingleton(() => PostEmailLogin(sl()));
  sl.registerLazySingleton(() => PostSocialLogin(sl()));
  sl.registerLazySingleton(() => PostGoogleLogin(sl()));

  // Repository
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRespositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(client: sl(), googleSignIn: sl()),
  );

  sl.registerLazySingleton<LoginLocalDataSource>(
    () => LoginLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
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
