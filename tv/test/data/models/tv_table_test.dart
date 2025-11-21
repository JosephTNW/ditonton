import 'package:tv/data/models/tv_table.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test/dummy_data/dummy_tv_objects.dart';

void main() {
  test('should return a valid Tv entity from TvTable', () {
    final result = testTvTable.toEntity();

    expect(result, testWatchlistTv);
  });

  group('fromEntity', () {
    test('should return a valid TvTable from TvDetail entity', () {
      final result = TvTable.fromEntity(testTvDetail);

      expect(result, testTvTable);
    });
  });

  group('fromMap', () {
    test('should return a valid TvTable from map', () {
      final result = TvTable.fromMap(testTvMap);

      expect(result, testTvTable);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () {
      final result = testTvTable.toJson();

      expect(result, testTvMap);
    });
  });
}
