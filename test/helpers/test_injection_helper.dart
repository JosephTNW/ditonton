import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:core/core.dart';
import 'package:movies/movies.dart';
import 'package:tv/tv.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

final locator = GetIt.instance;

/// Initialize dependencies for testing without SSL pinning
/// This uses a mock HTTP client instead of the SSL-pinned client
Future<void> initTestDependencies() async {
  // Movie BLoCs
  locator.registerFactory(
    () => MovieListBloc(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailBloc(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(() => MovieSearchBloc(searchMovies: locator()));
  locator.registerFactory(() => PopularMoviesBloc(getPopularMovies: locator()));
  locator.registerFactory(
    () => TopRatedMoviesBloc(getTopRatedMovies: locator()),
  );
  locator.registerFactory(
    () => WatchlistMoviesBloc(getWatchlistMovies: locator()),
  );
  locator.registerFactory(
    () => NowPlayingMoviesBloc(getNowPlayingMovies: locator()),
  );

  // TV BLoCs
  locator.registerFactory(
    () => TvListBloc(
      getOnTheAirTvs: locator(),
      getPopularTvs: locator(),
      getTopRatedTvs: locator(),
    ),
  );
  locator.registerFactory(
    () => TvDetailBloc(
      getTvDetail: locator(),
      getTvRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(() => TvSearchBloc(searchTvs: locator()));
  locator.registerFactory(() => OnTheAirTvsBloc(getOnTheAirTvs: locator()));
  locator.registerFactory(() => PopularTvsBloc(getPopularTvs: locator()));
  locator.registerFactory(() => TopRatedTvsBloc(getTopRatedTvs: locator()));
  locator.registerFactory(() => WatchlistTvsBloc(getWatchlistTvs: locator()));

  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlistMovie(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistMovie(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  locator.registerLazySingleton(() => GetOnTheAirTvs(locator()));
  locator.registerLazySingleton(() => GetPopularTvs(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvs(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTvs(locator()));
  locator.registerLazySingleton(() => GetTvWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTv(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTv(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvs(locator()));

  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
      networkInfo: locator(),
    ),
  );
  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
      networkInfo: locator(),
    ),
  );

  locator.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(databaseHelper: locator()),
  );
  locator.registerLazySingleton<TvRemoteDataSource>(
    () => TvRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<TvLocalDataSource>(
    () => TvLocalDataSourceImpl(databaseHelper: locator()),
  );

  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator()));

  // Use a mock HTTP client for tests instead of SSL-pinned client
  // This avoids the need to load certificate assets in the test environment
  locator.registerLazySingleton<http.Client>(
    () => MockClient((request) async {
      // Return a default response for tests
      return http.Response('{}', 200);
    }),
  );

  locator.registerLazySingleton(() => DataConnectionChecker());
}
