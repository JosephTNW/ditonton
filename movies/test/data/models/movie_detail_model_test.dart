import 'dart:convert';

import 'package:movies/data/models/movie_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  group('MovieDetailModel', () {
    group('fromJson', () {
      test('should return a valid model from JSON', () async {
        final jsonString = readJson('dummy_data/movie_detail.json');
        final Map<String, dynamic> jsonMap = json.decode(jsonString);

        final result = MovieDetailResponse.fromJson(jsonMap);

        expect(result.id, 1);
        expect(result.title, 'Title');
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () async {
        final jsonString = readJson('dummy_data/movie_detail.json');
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        final movieDetail = MovieDetailResponse.fromJson(jsonMap);

        final result = movieDetail.toJson();

        expect(result['id'], 1);
        expect(result['title'], 'Title');
        expect(result['adult'], false);
        expect(result['budget'], 100);
      });
    });

    group('toEntity', () {
      test('should convert to MovieDetail entity', () async {
        final jsonString = readJson('dummy_data/movie_detail.json');
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        final movieDetailModel = MovieDetailResponse.fromJson(jsonMap);

        final result = movieDetailModel.toEntity();

        expect(result.id, 1);
        expect(result.title, 'Title');
        expect(result.runtime, 120);
        expect(result.genres.length, greaterThan(0));
      });
    });
  });
}
