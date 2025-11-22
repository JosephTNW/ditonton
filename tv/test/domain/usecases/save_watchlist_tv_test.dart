import 'package:dartz/dartz.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/tv/dummy_tv_objects.dart';
import '../../../test/helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlistTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = SaveWatchlistTv(mockTvRepository);
  });

  test('should save tv to the repository', () async {
    when(
      mockTvRepository.saveWatchlist(testTvDetail),
    ).thenAnswer((_) async => Right('Added to Watchlist'));

    final result = await usecase.execute(testTvDetail);

    verify(mockTvRepository.saveWatchlist(testTvDetail));
    expect(result, Right('Added to Watchlist'));
    verifyNoMoreInteractions(mockTvRepository);
  });
}
