import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/app_assets.dart';
import '../utils/size_config.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        width: getWidth(width),
        height: getHeight(height),
        decoration: const BoxDecoration(
            // borderRadius: BorderRadius.circular(radius),
            shape: BoxShape.circle),
        child: CachedNetworkImage(
          fit: BoxFit.contain,
          imageUrl: imageUrl,
          progressIndicatorBuilder: (context, url, progress) => SizedBox(
            height: getHeight(height),
            child: Shimmer.fromColors(
              baseColor: const Color.fromARGB(255, 188, 182, 182),
              highlightColor: const Color.fromARGB(255, 255, 255, 255),
              child: Container(
                width: getWidth(width),
                height: getHeight(height),
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(radius),
                  shape: BoxShape.circle,
                  color: Colors.grey.withOpacity(.9),
                ),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              width: getWidth(width),
              height: getHeight(height),
              decoration: const BoxDecoration(
                // borderRadius: BorderRadius.circular(radius),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                AppAssets.splashImg,
                fit: BoxFit.contain,
                width: getWidth(width),
                height: getHeight(height),
              )),
        ));
  }
}
