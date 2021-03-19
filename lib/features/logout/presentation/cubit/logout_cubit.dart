import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:gamecircle/features/home/domain/usecases/post_logout_user.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final PostLogoutUser postLogoutUser;
  final AuthenticationBloc authenticationBloc;

  LogoutCubit({
    required this.postLogoutUser,
    required this.authenticationBloc,
  }) : super(LogoutInitial());

  void logout() async {
    emit(LogoutLoading());
    final user = await postLogoutUser(NoParams());

    emit(user.fold(
      (failure) {
        return _handleFailureEvent(failure);
      },
      (user) {
        authenticationBloc.add(GetCachedTokenEvent());
        return LogoutLoaded();
      },
    ));
  }

  LogoutError _handleFailureEvent(Failure failure) {
    LogoutError error;
    if (failure is ServerFailure) {
      error = LogoutError(message: failure.message);
    } else {
      error = LogoutError(message: "unexpected_error");
    }

    return error;
  }
}
