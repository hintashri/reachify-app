import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:reachify_app/theme/app_colors.dart';

class LoaderView extends StatelessWidget {
  const LoaderView({super.key, this.size = 60});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitCircle(
        size: size,
        itemBuilder: (context, index) {
          return Container(
            height: 30,
            width: 30,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: AppColors.primary,
            ),
          );
        },
      ),
    );
  }
}
