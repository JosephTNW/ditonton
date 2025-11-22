import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:core/utils/network_info.dart';
import 'package:core/data/datasources/db/database_helper.dart';
import 'package:movies/data/datasources/movie_local_data_source.dart';
import 'package:movies/data/datasources/movie_remote_data_source.dart';
import 'package:tv/data/datasources/tv_local_data_source.dart';
import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:movies/data/repositories/movie_repository_impl.dart';
import 'package:tv/data/repositories/tv_repository_impl.dart';
import 'package:movies/domain/repositories/movie_repository.dart';
import 'package:tv/domain/repositories/tv_repository.dart';
import 'package:movies/domain/usecases/get_movie_detail.dart';
import 'package:movies/domain/usecases/get_movie_recommendations.dart';
import 'package:movies/domain/usecases/get_movie_watchlist_status.dart';
import 'package:movies/domain/usecases/get_now_playing_movies.dart';
import 'package:movies/domain/usecases/get_popular_movies.dart';
import 'package:movies/domain/usecases/get_top_rated_movies.dart';
import 'package:movies/domain/usecases/get_watchlist_movies.dart';
import 'package:movies/domain/usecases/remove_watchlist_movie.dart';
import 'package:movies/domain/usecases/save_watchlist_movie.dart';
import 'package:movies/domain/usecases/search_movies.dart';
import 'package:tv/domain/usecases/get_on_the_air_tvs.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/domain/usecases/get_tv_watchlist_status.dart';
import 'package:tv/domain/usecases/get_watchlist_tvs.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';
import 'package:tv/domain/usecases/search_tvs.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'helpers/test_injection_helper.dart';
import 'helpers/test_helper.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Dependency Injection', () {
    setUp(() async {
      di.locator.reset();

      di.locator.registerSingletonAsync<http.Client>(
              () async => MockHttpClient(),
            );
            await di.locator.isReady<http.Client>();

      await di.init();
    });

    tearDown(() async {
      await di.locator.reset();
    });

    test('should initialize all dependencies', () {
      expect(di.locator.isRegistered<GetNowPlayingMovies>(), true);
      expect(di.locator.isRegistered<GetPopularMovies>(), true);
      expect(di.locator.isRegistered<GetTopRatedMovies>(), true);
      expect(di.locator.isRegistered<GetMovieDetail>(), true);
      expect(di.locator.isRegistered<GetMovieRecommendations>(), true);
      expect(di.locator.isRegistered<SearchMovies>(), true);
      expect(di.locator.isRegistered<GetWatchListStatus>(), true);
      expect(di.locator.isRegistered<SaveWatchlistMovie>(), true);
      expect(di.locator.isRegistered<RemoveWatchlistMovie>(), true);
      expect(di.locator.isRegistered<GetWatchlistMovies>(), true);

      expect(di.locator.isRegistered<GetOnTheAirTvs>(), true);
      expect(di.locator.isRegistered<GetPopularTvs>(), true);
      expect(di.locator.isRegistered<GetTopRatedTvs>(), true);
      expect(di.locator.isRegistered<GetTvDetail>(), true);
      expect(di.locator.isRegistered<GetTvRecommendations>(), true);
      expect(di.locator.isRegistered<SearchTvs>(), true);
      expect(di.locator.isRegistered<GetTvWatchListStatus>(), true);
      expect(di.locator.isRegistered<SaveWatchlistTv>(), true);
      expect(di.locator.isRegistered<RemoveWatchlistTv>(), true);
      expect(di.locator.isRegistered<GetWatchlistTvs>(), true);

      expect(di.locator.isRegistered<MovieRepository>(), true);
      expect(di.locator.isRegistered<TvRepository>(), true);

      expect(di.locator.isRegistered<MovieRemoteDataSource>(), true);
      expect(di.locator.isRegistered<MovieLocalDataSource>(), true);
      expect(di.locator.isRegistered<TvRemoteDataSource>(), true);
      expect(di.locator.isRegistered<TvLocalDataSource>(), true);

      expect(di.locator.isRegistered<DatabaseHelper>(), true);
      expect(di.locator.isRegistered<NetworkInfo>(), true);

      expect(di.locator.isRegistered<http.Client>(), true);
      expect(di.locator.isRegistered<DataConnectionChecker>(), true);
    });

    group('Movie Use Cases', () {
      test('should resolve GetNowPlayingMovies', () {
        final useCase = di.locator<GetNowPlayingMovies>();
        expect(useCase, isA<GetNowPlayingMovies>());
      });

      test('should resolve GetPopularMovies', () {
        final useCase = di.locator<GetPopularMovies>();
        expect(useCase, isA<GetPopularMovies>());
      });

      test('should resolve GetTopRatedMovies', () {
        final useCase = di.locator<GetTopRatedMovies>();
        expect(useCase, isA<GetTopRatedMovies>());
      });

      test('should resolve GetMovieDetail', () {
        final useCase = di.locator<GetMovieDetail>();
        expect(useCase, isA<GetMovieDetail>());
      });

      test('should resolve GetMovieRecommendations', () {
        final useCase = di.locator<GetMovieRecommendations>();
        expect(useCase, isA<GetMovieRecommendations>());
      });

      test('should resolve SearchMovies', () {
        final useCase = di.locator<SearchMovies>();
        expect(useCase, isA<SearchMovies>());
      });

      test('should resolve GetWatchListStatus', () {
        final useCase = di.locator<GetWatchListStatus>();
        expect(useCase, isA<GetWatchListStatus>());
      });

      test('should resolve SaveWatchlistMovie', () {
        final useCase = di.locator<SaveWatchlistMovie>();
        expect(useCase, isA<SaveWatchlistMovie>());
      });

      test('should resolve RemoveWatchlistMovie', () {
        final useCase = di.locator<RemoveWatchlistMovie>();
        expect(useCase, isA<RemoveWatchlistMovie>());
      });

      test('should resolve GetWatchlistMovies', () {
        final useCase = di.locator<GetWatchlistMovies>();
        expect(useCase, isA<GetWatchlistMovies>());
      });
    });

    group('TV Use Cases', () {
      test('should resolve GetOnTheAirTvs', () {
        final useCase = di.locator<GetOnTheAirTvs>();
        expect(useCase, isA<GetOnTheAirTvs>());
      });

      test('should resolve GetPopularTvs', () {
        final useCase = di.locator<GetPopularTvs>();
        expect(useCase, isA<GetPopularTvs>());
      });

      test('should resolve GetTopRatedTvs', () {
        final useCase = di.locator<GetTopRatedTvs>();
        expect(useCase, isA<GetTopRatedTvs>());
      });

      test('should resolve GetTvDetail', () {
        final useCase = di.locator<GetTvDetail>();
        expect(useCase, isA<GetTvDetail>());
      });

      test('should resolve GetTvRecommendations', () {
        final useCase = di.locator<GetTvRecommendations>();
        expect(useCase, isA<GetTvRecommendations>());
      });

      test('should resolve SearchTvs', () {
        final useCase = di.locator<SearchTvs>();
        expect(useCase, isA<SearchTvs>());
      });

      test('should resolve GetTvWatchListStatus', () {
        final useCase = di.locator<GetTvWatchListStatus>();
        expect(useCase, isA<GetTvWatchListStatus>());
      });

      test('should resolve SaveWatchlistTv', () {
        final useCase = di.locator<SaveWatchlistTv>();
        expect(useCase, isA<SaveWatchlistTv>());
      });

      test('should resolve RemoveWatchlistTv', () {
        final useCase = di.locator<RemoveWatchlistTv>();
        expect(useCase, isA<RemoveWatchlistTv>());
      });

      test('should resolve GetWatchlistTvs', () {
        final useCase = di.locator<GetWatchlistTvs>();
        expect(useCase, isA<GetWatchlistTvs>());
      });
    });

    group('Repositories', () {
      test('should resolve MovieRepository', () {
        final repository = di.locator<MovieRepository>();
        expect(repository, isA<MovieRepositoryImpl>());
      });

      test('should resolve TvRepository', () {
        final repository = di.locator<TvRepository>();
        expect(repository, isA<TvRepositoryImpl>());
      });
    });

    group('Data Sources', () {
      test('should resolve MovieRemoteDataSource', () {
        final dataSource = di.locator<MovieRemoteDataSource>();
        expect(dataSource, isA<MovieRemoteDataSourceImpl>());
      });

      test('should resolve MovieLocalDataSource', () {
        final dataSource = di.locator<MovieLocalDataSource>();
        expect(dataSource, isA<MovieLocalDataSourceImpl>());
      });

      test('should resolve TvRemoteDataSource', () {
        final dataSource = di.locator<TvRemoteDataSource>();
        expect(dataSource, isA<TvRemoteDataSourceImpl>());
      });

      test('should resolve TvLocalDataSource', () {
        final dataSource = di.locator<TvLocalDataSource>();
        expect(dataSource, isA<TvLocalDataSourceImpl>());
      });
    });

    group('Helpers and External', () {
      test('should resolve DatabaseHelper', () {
        final helper = di.locator<DatabaseHelper>();
        expect(helper, isA<DatabaseHelper>());
      });

      test('should resolve NetworkInfo', () {
        final networkInfo = di.locator<NetworkInfo>();
        expect(networkInfo, isA<NetworkInfoImpl>());
      });

      test('should resolve http.Client', () {
        final client = di.locator<http.Client>();
        expect(client, isA<http.Client>());
      });

      test('should resolve DataConnectionChecker', () {
        final checker = di.locator<DataConnectionChecker>();
        expect(checker, isA<DataConnectionChecker>());
      });
    });

    group('Singleton Behavior', () {
      test('should return same instance for lazy singletons', () {
        final useCase1 = di.locator<GetNowPlayingMovies>();
        final useCase2 = di.locator<GetNowPlayingMovies>();
        expect(identical(useCase1, useCase2), true);
      });

      test('should return same repository instance', () {
        final repo1 = di.locator<MovieRepository>();
        final repo2 = di.locator<MovieRepository>();
        expect(identical(repo1, repo2), true);
      });
    });
  });
}
