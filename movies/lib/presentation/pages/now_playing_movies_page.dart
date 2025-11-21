import 'package:core/utils/state_enum.dart';
import 'package:movies/presentation/bloc/now_playing_movies_bloc.dart';
import 'package:movies/presentation/bloc/now_playing_movies_event.dart';
import 'package:movies/presentation/bloc/now_playing_movies_state.dart';
import 'package:movies/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NowPlayingMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/now-playing';

  const NowPlayingMoviesPage({super.key});

  @override
  _NowPlayingMoviesPageState createState() => _NowPlayingMoviesPageState();
}

class _NowPlayingMoviesPageState extends State<NowPlayingMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NowPlayingMoviesBloc>().add(FetchNowPlayingMoviesEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Now Playing Movies')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<NowPlayingMoviesBloc, NowPlayingMoviesState>(
          builder: (context, state) {
            if (state.state == RequestState.Loading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.movies[index];
                  return MovieCard(movie);
                },
                itemCount: state.movies.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            }
          },
        ),
      ),
    );
  }
}
