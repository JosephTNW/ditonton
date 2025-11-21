import 'package:core/utils/state_enum.dart';
import 'package:core/utils/utils.dart';
import 'package:movies/presentation/bloc/watchlist_movies_bloc.dart';
import 'package:movies/presentation/bloc/watchlist_movies_event.dart';
import 'package:movies/presentation/bloc/watchlist_movies_state.dart';
import 'package:movies/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  const WatchlistMoviesPage({super.key});

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<WatchlistMoviesBloc>().add(FetchWatchlistMoviesEvent());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistMoviesBloc>().add(FetchWatchlistMoviesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Watchlist')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistMoviesBloc, WatchlistMoviesState>(
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

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
