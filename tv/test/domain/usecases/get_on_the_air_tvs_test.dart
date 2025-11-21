import 'package:dartz/dartz.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_on_the_air_tvs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../test/helpers/test_helper.mocks.dart';

void main() {
  late GetOnTheAirTvs usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetOnTheAirTvs(mockTvRepository);
  });

  final tTvs = <Tv>[];

  test('should get list of tvs from the repository', () async {
    when(
      mockTvRepository.getOnTheAirTvs(),
    ).thenAnswer((_) async => Right(tTvs));

    final result = await usecase.execute();

    expect(result, Right(tTvs));
    verify(mockTvRepository.getOnTheAirTvs());
    verifyNoMoreInteractions(mockTvRepository);
  });
}
