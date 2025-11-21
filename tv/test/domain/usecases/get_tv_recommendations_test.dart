import 'package:dartz/dartz.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../test/helpers/test_helper.mocks.dart';

void main() {
  late GetTvRecommendations usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvRecommendations(mockTvRepository);
  });

  final tId = 1;
  final tTvs = <Tv>[];

  test('should get list of tv recommendations from the repository', () async {
    when(
      mockTvRepository.getTvRecommendations(tId),
    ).thenAnswer((_) async => Right(tTvs));

    final result = await usecase.execute(tId);

    expect(result, Right(tTvs));
    verify(mockTvRepository.getTvRecommendations(tId));
    verifyNoMoreInteractions(mockTvRepository);
  });
}
