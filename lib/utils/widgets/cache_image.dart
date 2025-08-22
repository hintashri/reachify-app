import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class CacheImage extends StatelessWidget {
  final String url;
  final double? height;
  final double? width;
  final BoxFit? fit;

  const CacheImage({
    super.key,
    required this.url,
    this.height,
    this.width,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: CachedNetworkImage(
        imageUrl: url,
        fit: fit ?? BoxFit.cover,
        width: width ?? context.width,
        height: height ?? context.height,
        placeholder: (context, url) => ShimmerWidget(
          width: width ?? context.width,
          height: height ?? context.height,
        ),
      ),
    );
  }
}

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;

  const ShimmerWidget({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      // enabled: false,
      direction: ShimmerDirection.ttb,
      period: const Duration(milliseconds: 1500),
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade300,
      child: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.rectangle,
        ),
      ),
    );
  }
}
