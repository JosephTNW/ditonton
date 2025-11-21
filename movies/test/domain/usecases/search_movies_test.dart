import 'package:dartz/dartz.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/usecases/search_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../test/helpers/test_helper.mocks.dart';

void main() {
  late SearchMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = SearchMovies(mockMovieRepository);
  });

  final tMovies = <Movie>[];
  final tQuery = 'Spiderman';

  test('should get list of movies from the repository', () async {
    when(
      mockMovieRepository.searchMovies(tQuery),
    ).thenAnswer((_) async => Right(tMovies));

    final result = await usecase.execute(tQuery);

    expect(result, Right(tMovies));
  });
}
