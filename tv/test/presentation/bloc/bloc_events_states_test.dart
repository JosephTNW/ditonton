import 'package:flutter_test/flutter_test.dart';
import 'package:tv/presentation/bloc/on_the_air_tvs_event.dart';
import 'package:tv/presentation/bloc/on_the_air_tvs_state.dart';
import 'package:tv/presentation/bloc/popular_tvs_event.dart';
import 'package:tv/presentation/bloc/popular_tvs_state.dart';
import 'package:tv/presentation/bloc/top_rated_tvs_event.dart';
import 'package:tv/presentation/bloc/top_rated_tvs_state.dart';
import 'package:tv/presentation/bloc/watchlist_tvs_event.dart';
import 'package:tv/presentation/bloc/watchlist_tvs_state.dart';
import 'package:tv/presentation/bloc/tv_search_event.dart';
import 'package:tv/presentation/bloc/tv_search_state.dart';
import 'package:tv/presentation/bloc/tv_list_event.dart';
import 'package:tv/presentation/bloc/tv_detail_event.dart';

import '../../dummy_data/dummy_tv_objects.dart';

void main() {
  group('OnTheAirTvs Events', () {
    test('FetchOnTheAirTvsEvent props should be empty', () {
      expect(FetchOnTheAirTvsEvent().props, []);
    });
  });

  group('OnTheAirTvs State', () {
    test('copyWith should update state correctly', () {
      const state = OnTheAirTvsState();
      final newState = state.copyWith(tvs: testTvList);
      expect(newState.tvs, testTvList);
    });
  });

  group('PopularTvs Events', () {
    test('FetchPopularTvsEvent props should be empty', () {
      expect(FetchPopularTvsEvent().props, []);
    });
  });

  group('PopularTvs State', () {
    test('copyWith should update state correctly', () {
      const state = PopularTvsState();
      final newState = state.copyWith(tvs: testTvList);
      expect(newState.tvs, testTvList);
    });
  });

  group('TopRatedTvs Events', () {
    test('FetchTopRatedTvsEvent props should be empty', () {
      expect(FetchTopRatedTvsEvent().props, []);
    });
  });

  group('TopRatedTvs State', () {
    test('copyWith should update state correctly', () {
      const state = TopRatedTvsState();
      final newState = state.copyWith(tvs: testTvList);
      expect(newState.tvs, testTvList);
    });
  });

  group('WatchlistTvs Events', () {
    test('FetchWatchlistTvsEvent props should be empty', () {
      expect(FetchWatchlistTvsEvent().props, []);
    });
  });

  group('WatchlistTvs State', () {
    test('copyWith should update state correctly', () {
      const state = WatchlistTvsState();
      final newState = state.copyWith(tvs: testTvList);
      expect(newState.tvs, testTvList);
    });
  });

  group('TvSearch Events', () {
    test('OnTvQueryChanged props should contain query', () {
      const event = OnTvQueryChanged('query');
      expect(event.props, ['query']);
    });
  });

  group('TvSearch State', () {
    test('copyWith should update state correctly', () {
      const state = TvSearchState();
      final newState = state.copyWith(searchResult: testTvList);
      expect(newState.searchResult, testTvList);
    });
  });

  group('TvList Events', () {
    test('FetchOnTheAirTvs props should be empty', () {
      expect(FetchOnTheAirTvs().props, []);
    });

    test('FetchPopularTvs props should be empty', () {
      expect(FetchPopularTvs().props, []);
    });

    test('FetchTopRatedTvs props should be empty', () {
      expect(FetchTopRatedTvs().props, []);
    });
  });

  group('TvDetail Event', () {
    test('FetchTvDetail props should contain id', () {
      const event = FetchTvDetail(1);
      expect(event.props, [1]);
    });
  });
}
