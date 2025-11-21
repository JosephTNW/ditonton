import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/utils/constants.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:core/presentation/widgets/app_drawer.dart';
import 'package:movies/presentation/pages/movie_detail_page.dart';
import 'package:movies/presentation/pages/now_playing_movies_page.dart';
import 'package:movies/presentation/pages/popular_movies_page.dart';
import 'package:movies/presentation/pages/search_page.dart';
import 'package:movies/presentation/pages/top_rated_movies_page.dart';
import 'package:movies/presentation/bloc/movie_list_bloc.dart';
import 'package:movies/presentation/bloc/movie_list_event.dart';
import 'package:movies/presentation/bloc/movie_list_state.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeMoviePage extends StatefulWidget {
  const HomeMoviePage({super.key});

  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieListBloc>().add(FetchNowPlayingMovies());
      context.read<MovieListBloc>().add(FetchPopularMovies());
      context.read<MovieListBloc>().add(FetchTopRatedMovies());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(isOnMoviePage: true),
      appBar: AppBar(
        title: Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPage.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubHeading(
                title: 'Now Playing',
                onTap:
                    () => Navigator.pushNamed(
                      context,
                      NowPlayingMoviesPage.ROUTE_NAME,
                    ),
              ),
              BlocBuilder<MovieListBloc, MovieListState>(
                builder: (context, state) {
                  if (state.nowPlayingState == RequestState.Loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state.nowPlayingState == RequestState.Loaded) {
                    return MovieList(state.nowPlayingMovies);
                  } else {
                    return Text('Failed');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap:
                    () => Navigator.pushNamed(
                      context,
                      PopularMoviesPage.ROUTE_NAME,
                    ),
              ),
              BlocBuilder<MovieListBloc, MovieListState>(
                builder: (context, state) {
                  if (state.popularMoviesState == RequestState.Loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state.popularMoviesState == RequestState.Loaded) {
                    return MovieList(state.popularMovies);
                  } else {
                    return Text('Failed');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap:
                    () => Navigator.pushNamed(
                      context,
                      TopRatedMoviesPage.ROUTE_NAME,
                    ),
              ),
              BlocBuilder<MovieListBloc, MovieListState>(
                builder: (context, state) {
                  if (state.topRatedMoviesState == RequestState.Loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state.topRatedMoviesState == RequestState.Loaded) {
                    return MovieList(state.topRatedMovies);
                  } else {
                    return Text('Failed');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: kHeading6),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList(this.movies, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder:
                      (context, url) =>
                          Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
