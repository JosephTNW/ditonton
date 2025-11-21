import 'package:movies/domain/usecases/get_movie_watchlist_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../test/helpers/test_helper.mocks.dart';

void main() {
  late GetWatchListStatus usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetWatchListStatus(mockMovieRepository);
  });

  test('should get watchlist status from repository', () async {
    when(
      mockMovieRepository.isAddedToWatchlist(1),
    ).thenAnswer((_) async => true);

    final result = await usecase.execute(1);

    expect(result, true);
  });
}
