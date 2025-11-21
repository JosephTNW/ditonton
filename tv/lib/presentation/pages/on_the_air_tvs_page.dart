import 'package:core/utils/state_enum.dart';
import 'package:tv/presentation/bloc/on_the_air_tvs_bloc.dart';
import 'package:tv/presentation/bloc/on_the_air_tvs_event.dart';
import 'package:tv/presentation/bloc/on_the_air_tvs_state.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnTheAirTvsPage extends StatefulWidget {
  static const ROUTE_NAME = '/on-the-air-tv';

  const OnTheAirTvsPage({super.key});

  @override
  _OnTheAirTvsPageState createState() => _OnTheAirTvsPageState();
}

class _OnTheAirTvsPageState extends State<OnTheAirTvsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<OnTheAirTvsBloc>().add(FetchOnTheAirTvsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('On The Air TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<OnTheAirTvsBloc, OnTheAirTvsState>(
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
