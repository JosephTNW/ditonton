import 'package:movies/data/models/movie_model.dart';
import 'package:movies/data/models/movie_table.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/entities/movie_detail.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tMovieTable = MovieTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 120,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovieModel = MovieModel(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tMovie = Movie.watchlist(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  group('MovieTable', () {
    group('fromEntity', () {
      test('should create MovieTable from MovieDetail', () {
        final result = MovieTable.fromEntity(tMovieDetail);

        expect(result.id, 1);
        expect(result.title, 'title');
        expect(result.posterPath, 'posterPath');
        expect(result.overview, 'overview');
      });
    });

    group('fromMap', () {
      test('should create MovieTable from Map', () {
        final map = {
          'id': 1,
          'title': 'title',
          'posterPath': 'posterPath',
          'overview': 'overview',
        };

        final result = MovieTable.fromMap(map);

        expect(result, equals(tMovieTable));
      });
    });

    group('fromDTO', () {
      test('should create MovieTable from MovieModel', () {
        final result = MovieTable.fromDTO(tMovieModel);

        expect(result.id, 1);
        expect(result.title, 'title');
        expect(result.posterPath, 'posterPath');
        expect(result.overview, 'overview');
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        final result = tMovieTable.toJson();

        final expectedJsonMap = {
          'id': 1,
          'title': 'title',
          'posterPath': 'posterPath',
          'overview': 'overview',
        };
        expect(result, equals(expectedJsonMap));
      });
    });

    group('toEntity', () {
      test('should convert to Movie entity', () {
        final result = tMovieTable.toEntity();

        expect(result, equals(tMovie));
        expect(result.id, equals(1));
        expect(result.title, equals('title'));
        expect(result.posterPath, equals('posterPath'));
        expect(result.overview, equals('overview'));
      });
    });

    test('should have correct props', () {
      expect(tMovieTable.props, [1, 'title', 'posterPath', 'overview']);
    });
  });
}
