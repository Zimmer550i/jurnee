import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/screens/home/location_map.dart';

class PostLocation extends StatelessWidget {
  final PostModel post;
  const PostLocation({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: post.title),
      body: LocationMap(
        initialPost: post,
        startPosition: LatLng(
          post.location.coordinates[1],
          post.location.coordinates[0],
        ),
      ),
    );
  }
}
