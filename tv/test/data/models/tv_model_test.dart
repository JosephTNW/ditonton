import 'package:tv/data/models/tv_model.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvModel = TvModel(
    adult: false,
    backdropPath: '/path.jpg',
    genreIds: [18, 80],
    id: 1,
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Test TV Show',
    overview: 'Test overview',
    popularity: 100.0,
    posterPath: '/poster.jpg',
    firstAirDate: '2023-01-01',
    name: 'Test TV Show',
    voteAverage: 8.5,
    voteCount: 1000,
  );

  final tTv = Tv(
    adult: false,
    backdropPath: '/path.jpg',
    genreIds: [18, 80],
    id: 1,
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Test TV Show',
    overview: 'Test overview',
    popularity: 100.0,
    posterPath: '/poster.jpg',
    firstAirDate: '2023-01-01',
    name: 'Test TV Show',
    voteAverage: 8.5,
    voteCount: 1000,
  );

  test('should be a subclass of Tv entity', () async {
    final result = tTvModel.toEntity();
    expect(result, tTv);
  });

  group('fromJson', () {
    test('should return a valid model from JSON', () {
      final Map<String, dynamic> jsonMap = {
        "adult": false,
        "backdrop_path": "/path.jpg",
        "genre_ids": [18, 80],
        "id": 1,
        "origin_country": ["US"],
        "original_language": "en",
        "original_name": "Test TV Show",
        "overview": "Test overview",
        "popularity": 100.0,
        "poster_path": "/poster.jpg",
        "first_air_date": "2023-01-01",
        "name": "Test TV Show",
        "vote_average": 8.5,
        "vote_count": 1000,
      };

      final result = TvModel.fromJson(jsonMap);

      expect(result, tTvModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () {
      final expectedJsonMap = {
        "adult": false,
        "backdrop_path": "/path.jpg",
        "genre_ids": [18, 80],
        "id": 1,
        "origin_country": ["US"],
        "original_language": "en",
        "original_name": "Test TV Show",
        "overview": "Test overview",
        "popularity": 100.0,
        "poster_path": "/poster.jpg",
        "first_air_date": "2023-01-01",
        "name": "Test TV Show",
        "vote_average": 8.5,
        "vote_count": 1000,
      };

      final result = tTvModel.toJson();

      expect(result, expectedJsonMap);
    });
  });
}
