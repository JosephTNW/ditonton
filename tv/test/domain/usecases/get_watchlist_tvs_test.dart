import 'package:dartz/dartz.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_watchlist_tvs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../test/helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistTvs usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetWatchlistTvs(mockTvRepository);
  });

  test('should get list of tvs from the repository', () async {
    final tTvs = <Tv>[];
    when(
      mockTvRepository.getWatchlistTvs(),
    ).thenAnswer((_) async => Right(tTvs));

    final result = await usecase.execute();

    expect(result, Right(tTvs));
    verify(mockTvRepository.getWatchlistTvs());
    verifyNoMoreInteractions(mockTvRepository);
  });
}
