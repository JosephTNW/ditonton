import 'dart:convert';

import 'package:tv/data/models/tv_model.dart';
import 'package:tv/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../movies/test/json_reader.dart';

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

  final tTvResponseModel = TvResponse(tvList: [tTvModel]);

  group('fromJson', () {
    test('should return a valid model from JSON', () {
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('dummy_data/tv/on_the_air.json'),
      );

      final result = TvResponse.fromJson(jsonMap);

      expect(result, tTvResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () {
      final result = tTvResponseModel.toJson();

      final expectedJsonMap = {
        "results": [
          {
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
          },
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
