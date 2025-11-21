import 'package:tv/domain/usecases/get_tv_watchlist_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../test/helpers/test_helper.mocks.dart';
void main() {
  late GetTvWatchListStatus usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvWatchListStatus(mockTvRepository);
  });

  test('should get watchlist status from repository', () async {
    when(mockTvRepository.isAddedToWatchlist(1)).thenAnswer((_) async => true);

    final result = await usecase.execute(1);

    expect(result, true);
    verify(mockTvRepository.isAddedToWatchlist(1));
    verifyNoMoreInteractions(mockTvRepository);
  });
}
