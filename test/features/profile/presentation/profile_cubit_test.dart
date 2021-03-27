import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/entities/user.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/managers/session_manager.dart';
import 'package:gamecircle/features/profile/domain/usecases/post_user_information.dart';
import 'package:gamecircle/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockPostUserInformation extends Mock implements PostUserInformation {}

class MockSessionManager extends Mock implements SessionManager {}

void main() {
  late ProfileCubit profileCubit;
  //ignore: close_sinks
  late MockPostUserInformation mockPostUserInformation;
  late MockSessionManager mockSessionManager;

  setUp(() {
    registerFallbackValue<PostUserInformationParams>(
        PostUserInformationParams());
    mockPostUserInformation = MockPostUserInformation();
    mockSessionManager = MockSessionManager();
    profileCubit = ProfileCubit(
      sessionManager: mockSessionManager,
      postUserInformation: mockPostUserInformation,
    );
  });

  group('postLogoutUser', () {
    final tUser = User(name: 'Test');

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        when(() => mockPostUserInformation(any()))
            .thenAnswer((_) async => Right(tUser));
        // act
        profileCubit.submitProfile();
        await untilCalled(() => mockPostUserInformation(any()));
        // assert
        verify(
          () => mockPostUserInformation(PostUserInformationParams()),
        );
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        when(() => mockPostUserInformation(any()))
            .thenAnswer((_) async => Right(tUser));
        // assert
        final expected = [
          ProfileLoading(),
          ProfileLoaded(),
        ];
        expectLater(profileCubit, emitsInOrder(expected));
        // act
        profileCubit.submitProfile();
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        final failure = ServerFailure(code: 500, message: "unexpected_error");
        when(() => mockPostUserInformation(any())).thenAnswer(
          (_) async => Left(
            failure,
          ),
        );
        // assert later
        final expected = [
          // Empty(),
          ProfileLoading(),
          ProfileError(
            message: failure.message,
          ),
        ];
        expectLater(profileCubit, emitsInOrder(expected));
        // act
        profileCubit.submitProfile();
      },
    );
  });
}
