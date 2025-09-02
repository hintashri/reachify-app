import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SVGImage extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final double? height;
  final double? width;
  final Color? color;

  const SVGImage(
    this.path, {
    super.key,
    this.fit = BoxFit.contain,
    this.height,
    this.width,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      height: height,
      width: width,
      fit: BoxFit.contain,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      // package: AppKey.core,

      // semanticsLabel: 'Acme Logo',
    );
  }
}
