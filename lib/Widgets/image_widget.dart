import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movix/Utilities/Constant/api_constants.dart';
import 'package:movix/Utilities/Constant/images.dart';

class ImageView extends StatelessWidget {
  final String networkImageUrl;
  final String imageUrlForEmptyNetworkImage;

  const ImageView(
      {Key key, this.networkImageUrl, this.imageUrlForEmptyNetworkImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: networkImageUrl.isEmpty
          ? Image.asset(
              imageUrlForEmptyNetworkImage,
              fit: BoxFit.cover,
            )
          : CachedNetworkImage(
              imageUrl: TMDB_BASE_IMAGE_URL + 'original/' + networkImageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return Image.asset(
                  Images.loadingGif,
                  fit: BoxFit.cover,
                );
              },
            ),
    );
  }
}
