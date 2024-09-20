import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants.dart';

class Avatar extends StatelessWidget {
  final double radius;
  final String imageUrl;
  final VoidCallback? onPressed;
  const Avatar(
      {super.key,
      required this.radius,
      required this.imageUrl,
      this.onPressed});
  const Avatar.small({super.key, required this.imageUrl, this.onPressed})
      : radius = 16.0;
  const Avatar.medium({super.key, required this.imageUrl, this.onPressed})
      : radius = 22.0;
  const Avatar.large({super.key, required this.imageUrl, this.onPressed})
      : radius = 44.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CircleAvatar(
        radius: radius,
        backgroundImage: CachedNetworkImageProvider(imageUrl),
        // backgroundImage: const CachedNetworkImageProvider(
        //     'https://pixabay.com/photos/knit-cap-person-outdoors-sunlight-7600730/'),
        backgroundColor: kCardColor,
      ),
    );
  }
}
