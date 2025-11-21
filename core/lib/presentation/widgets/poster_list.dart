import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/utils/constants.dart';
import 'package:flutter/material.dart';

class PosterList extends StatelessWidget {
  final List<dynamic> items;
  final String routeName;

  const PosterList({super.key, required this.items, required this.routeName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, routeName, arguments: item.id);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${item.posterPath}',
                  placeholder:
                      (context, url) =>
                          Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: items.length,
      ),
    );
  }
}
