import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/utils/const_utils.dart';
import 'package:gamecircle/features/home/data/datasources/user_local_data_source.dart';
import 'package:mocktail/mocktail.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late UserLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = UserLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('deleteCachedToken', () {
    test(
      'should call SharedPreferences to delete cached the data',
      () async {
        //arrange
        when(() => mockSharedPreferences.remove(any()))
            .thenAnswer((invocation) => Future.value(true));
        // act
        dataSource.deleteCachedToken();
        // assert
        verify(() => mockSharedPreferences.remove(
              CACHED_TOKEN,
            )).called(1);
      },
    );
  });
}
