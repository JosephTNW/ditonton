import 'package:core/utils/state_enum.dart';
import 'package:tv/presentation/bloc/popular_tvs_bloc.dart';
import 'package:tv/presentation/bloc/popular_tvs_event.dart';
import 'package:tv/presentation/bloc/popular_tvs_state.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTvsPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv';

  const PopularTvsPage({super.key});

  @override
  _PopularTvsPageState createState() => _PopularTvsPageState();
}

class _PopularTvsPageState extends State<PopularTvsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PopularTvsBloc>().add(FetchPopularTvsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Popular TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTvsBloc, PopularTvsState>(
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
