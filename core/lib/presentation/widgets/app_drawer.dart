import 'package:core/presentation/pages/about_page.dart';
import 'package:tv/presentation/pages/home_tv_page.dart';
import 'package:movies/presentation/pages/watchlist_movies_page.dart';
import 'package:tv/presentation/pages/watchlist_tvs_page.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final bool isOnMoviePage;

  const AppDrawer({super.key, required this.isOnMoviePage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/circle-g.png'),
              backgroundColor: Colors.grey.shade900,
            ),
            accountName: Text('Ditonton'),
            accountEmail: Text('ditonton@dicoding.com'),
            decoration: BoxDecoration(color: Colors.grey.shade900),
          ),
          ListTile(
            leading: Icon(Icons.tv),
            title: Text('TV Series'),
            onTap: () {
              if (isOnMoviePage) {
                Navigator.pushNamed(context, HomeTvPage.ROUTE_NAME);
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.movie),
            title: Text('Movies'),
            onTap: () {
              if (isOnMoviePage) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, '/home');
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.live_tv),
            title: Text('TV Watchlist'),
            onTap: () {
              Navigator.pushNamed(context, WatchlistTvsPage.ROUTE_NAME);
            },
          ),
          ListTile(
            leading: Icon(Icons.save_alt),
            title: Text('Movie Watchlist'),
            onTap: () {
              Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
            },
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
            },
            leading: Icon(Icons.info_outline),
            title: Text('About'),
          ),
        ],
      ),
    );
  }
}
