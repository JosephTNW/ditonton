import 'package:core/utils/state_enum.dart';
import 'package:core/utils/utils.dart';
import 'package:tv/presentation/bloc/watchlist_tvs_bloc.dart';
import 'package:tv/presentation/bloc/watchlist_tvs_event.dart';
import 'package:tv/presentation/bloc/watchlist_tvs_state.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistTvsPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-tv';

  const WatchlistTvsPage({super.key});

  @override
  _WatchlistTvsPageState createState() => _WatchlistTvsPageState();
}

class _WatchlistTvsPageState extends State<WatchlistTvsPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<WatchlistTvsBloc>().add(FetchWatchlistTvsEvent());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistTvsBloc>().add(FetchWatchlistTvsEvent());
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TV Series Watchlist')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistTvsBloc, WatchlistTvsState>(
          builder: (context, state) {
            if (state.state == RequestState.Loading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.tvs[index];
                  return TvCard(tv);
                },
                itemCount: state.tvs.length,
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
