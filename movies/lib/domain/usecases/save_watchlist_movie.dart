import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:movies/domain/entities/movie_detail.dart';
import 'package:movies/domain/repositories/movie_repository.dart';

class SaveWatchlistMovie {
  final MovieRepository repository;

  SaveWatchlistMovie(this.repository);

  Future<Either<Failure, String>> execute(MovieDetail movie) {
    return repository.saveWatchlist(movie);
  }
}
