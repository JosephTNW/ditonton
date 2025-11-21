import 'package:core/utils/state_enum.dart';
import 'package:tv/presentation/bloc/top_rated_tvs_bloc.dart';
import 'package:tv/presentation/bloc/top_rated_tvs_event.dart';
import 'package:tv/presentation/bloc/top_rated_tvs_state.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTvsPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv';

  const TopRatedTvsPage({super.key});

  @override
  _TopRatedTvsPageState createState() => _TopRatedTvsPageState();
}

class _TopRatedTvsPageState extends State<TopRatedTvsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TopRatedTvsBloc>().add(FetchTopRatedTvsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top Rated TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvsBloc, TopRatedTvsState>(
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
