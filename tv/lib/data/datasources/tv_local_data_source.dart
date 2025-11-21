import 'package:core/utils/exception.dart';
import 'package:core/data/datasources/db/database_helper.dart';
import 'package:tv/data/models/tv_table.dart';

abstract class TvLocalDataSource {
  Future<String> insertWatchlist(TvTable movie);
  Future<String> removeWatchlist(TvTable movie);
  Future<TvTable?> getTvById(int id);
  Future<List<TvTable>> getWatchlistTvs();
  Future<void> cacheOnTheAirTvs(List<TvTable> movies);
  Future<List<TvTable>> getCachedOnTheAirTvs();
}

class TvLocalDataSourceImpl implements TvLocalDataSource {
  final DatabaseHelper databaseHelper;

  TvLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlist(TvTable tv) async {
    try {
      await databaseHelper.insertTvToWatchlist(tv);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(TvTable tv) async {
    try {
      await databaseHelper.removeTvFromWatchlist(tv);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TvTable?> getTvById(int id) async {
    final result = await databaseHelper.getTvById(id);
    if (result != null) {
      return TvTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TvTable>> getWatchlistTvs() async {
    final result = await databaseHelper.getWatchlistTvs();
    return result.map((data) => TvTable.fromMap(data)).toList();
  }

  @override
  Future<void> cacheOnTheAirTvs(List<TvTable> tvs) async {
    await databaseHelper.clearTvCache('on the air');
    await databaseHelper.insertTvCacheTransaction(tvs, 'on the air');
  }

  @override
  Future<List<TvTable>> getCachedOnTheAirTvs() async {
    final result = await databaseHelper.getCacheTvs('on the air');
    return result.map((data) => TvTable.fromMap(data)).toList();
  }
}
