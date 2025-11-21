import 'package:dartz/dartz.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../test/helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedTvs usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTopRatedTvs(mockTvRepository);
  });

  final tTvs = <Tv>[];

  test('should get list of tvs from the repository', () async {
    when(
      mockTvRepository.getTopRatedTvs(),
    ).thenAnswer((_) async => Right(tTvs));

    final result = await usecase.execute();

    expect(result, Right(tTvs));
    verify(mockTvRepository.getTopRatedTvs());
    verifyNoMoreInteractions(mockTvRepository);
  });
}
