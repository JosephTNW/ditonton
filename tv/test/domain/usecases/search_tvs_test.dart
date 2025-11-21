import 'package:dartz/dartz.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/search_tvs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../test/helpers/test_helper.mocks.dart';

void main() {
  late SearchTvs usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = SearchTvs(mockTvRepository);
  });

  final tTvs = <Tv>[];
  final tQuery = 'Breaking Bad';

  test('should get list of tvs from the repository', () async {
    when(
      mockTvRepository.searchTvs(tQuery),
    ).thenAnswer((_) async => Right(tTvs));

    final result = await usecase.execute(tQuery);

    expect(result, Right(tTvs));
    verify(mockTvRepository.searchTvs(tQuery));
    verifyNoMoreInteractions(mockTvRepository);
  });
}
