import 'dart:convert';

import 'package:tv/data/models/tv_detail_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../movies/test/json_reader.dart';

void main() {
  final tTvDetailResponse = TvDetailResponse(
    adult: false,
    backdropPath: '/path.jpg',
    episodeRunTime: [45, 50],
    firstAirDate: '2023-01-01',
    genres: [],
    homepage: 'https://test.com',
    id: 1,
    inProduction: true,
    languages: ['en'],
    lastAirDate: '2023-12-31',
    name: 'Test TV Show',
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    originalLanguage: 'en',
    originalName: 'Test TV Show',
    overview: 'Test overview',
    popularity: 100.0,
    posterPath: '/poster.jpg',
    status: 'Returning Series',
    tagline: 'Test tagline',
    voteAverage: 8.5,
    voteCount: 1000,
  );

  group('fromJson', () {
    test('should return a valid model from JSON', () {
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('dummy_data/tv_detail.json'),
      );

      final result = TvDetailResponse.fromJson(jsonMap);

      expect(result.id, tTvDetailResponse.id);
      expect(result.name, tTvDetailResponse.name);
      expect(result.overview, tTvDetailResponse.overview);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () {
      final result = tTvDetailResponse.toJson();

      expect(result['id'], 1);
      expect(result['name'], 'Test TV Show');
      expect(result['overview'], 'Test overview');
    });
  });

  group('toEntity', () {
    test('should return a valid TvDetail entity', () {
      final result = tTvDetailResponse.toEntity();

      expect(result.id, tTvDetailResponse.id);
      expect(result.name, tTvDetailResponse.name);
      expect(result.overview, tTvDetailResponse.overview);
    });
  });
}
