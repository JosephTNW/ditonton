import 'package:dartz/dartz.dart';
import 'package:movies/domain/usecases/get_movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/movies/dummy_objects.dart';
import '../../../test/helpers/test_helper.mocks.dart';

void main() {
  late GetMovieDetail usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetMovieDetail(mockMovieRepository);
  });

  final tId = 1;

  test('should get movie detail from the repository', () async {
    when(
      mockMovieRepository.getMovieDetail(tId),
    ).thenAnswer((_) async => Right(testMovieDetail));

    final result = await usecase.execute(tId);

    expect(result, Right(testMovieDetail));
  });
}
