import 'package:dartz/dartz.dart';
import 'package:movies/domain/usecases/remove_watchlist_movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../../test/helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlistMovie usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = RemoveWatchlistMovie(mockMovieRepository);
  });

  test('should remove watchlist movie from repository', () async {
    when(
      mockMovieRepository.removeWatchlist(testMovieDetail),
    ).thenAnswer((_) async => Right('Removed from watchlist'));

    final result = await usecase.execute(testMovieDetail);

    verify(mockMovieRepository.removeWatchlist(testMovieDetail));
    expect(result, Right('Removed from watchlist'));
  });
}
