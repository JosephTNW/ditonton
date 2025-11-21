import 'package:tv/data/models/tv_table.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';

final testTv = Tv(
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

final testTvList = [testTv];

final testTvDetail = TvDetail(
  adult: false,
  backdropPath: '/path.jpg',
  genres: [Genre(id: 18, name: 'Drama')],
  id: 1,
  originalName: 'Test TV Show',
  overview: 'Test overview',
  posterPath: '/poster.jpg',
  firstAirDate: '2023-01-01',
  episodeRunTime: [45, 50],
  name: 'Test TV Show',
  voteAverage: 8.5,
  voteCount: 1000,
  numberOfEpisodes: 10,
  numberOfSeasons: 1,
);

final testWatchlistTv = Tv.watchlist(
  id: 1,
  name: 'Test TV Show',
  posterPath: '/poster.jpg',
  overview: 'Test overview',
);

final testTvTable = TvTable(
  id: 1,
  name: 'Test TV Show',
  posterPath: '/poster.jpg',
  overview: 'Test overview',
);

final testTvMap = {
  'id': 1,
  'overview': 'Test overview',
  'posterPath': '/poster.jpg',
  'name': 'Test TV Show',
};

final testTvCache = TvTable(
  id: 1,
  overview: 'Test overview',
  posterPath: '/poster.jpg',
  name: 'Test TV Show',
);
