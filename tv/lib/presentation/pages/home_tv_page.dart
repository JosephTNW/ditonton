import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/utils/constants.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:core/presentation/pages/about_page.dart';
import 'package:core/presentation/widgets/app_drawer.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';
import 'package:tv/presentation/pages/on_the_air_tvs_page.dart';
import 'package:tv/presentation/pages/popular_tvs_page.dart';
import 'package:tv/presentation/pages/search_tv_page.dart';
import 'package:tv/presentation/pages/top_rated_tvs_page.dart';
import 'package:tv/presentation/pages/watchlist_tvs_page.dart';
import 'package:tv/presentation/bloc/tv_list_bloc.dart';
import 'package:tv/presentation/bloc/tv_list_event.dart';
import 'package:tv/presentation/bloc/tv_list_state.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/home-tv';

  const HomeTvPage({super.key});

  @override
  _HomeTvPageState createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvListBloc>().add(FetchOnTheAirTvs());
      context.read<TvListBloc>().add(FetchPopularTvs());
      context.read<TvListBloc>().add(FetchTopRatedTvs());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(isOnMoviePage: false),
      appBar: AppBar(
        title: Text('Ditonton - TV Series'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchTvPage.ROUTE_NAME);
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
                title: 'On The Air',
                onTap:
                    () => Navigator.pushNamed(
                      context,
                      OnTheAirTvsPage.ROUTE_NAME,
                    ),
              ),
              BlocBuilder<TvListBloc, TvListState>(
                builder: (context, state) {
                  if (state.onTheAirState == RequestState.Loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state.onTheAirState == RequestState.Loaded) {
                    return TvList(state.onTheAirTvs);
                  } else {
                    return Text('Failed');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap:
                    () =>
                        Navigator.pushNamed(context, PopularTvsPage.ROUTE_NAME),
              ),
              BlocBuilder<TvListBloc, TvListState>(
                builder: (context, state) {
                  if (state.popularTvsState == RequestState.Loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state.popularTvsState == RequestState.Loaded) {
                    return TvList(state.popularTvs);
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
                      TopRatedTvsPage.ROUTE_NAME,
                    ),
              ),
              BlocBuilder<TvListBloc, TvListState>(
                builder: (context, state) {
                  if (state.topRatedTvsState == RequestState.Loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state.topRatedTvsState == RequestState.Loaded) {
                    return TvList(state.topRatedTvs);
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

class TvList extends StatelessWidget {
  final List<Tv> tvs;

  const TvList(this.tvs, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvs[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvDetailPage.ROUTE_NAME,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder:
                      (context, url) =>
                          Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvs.length,
      ),
    );
  }
}
