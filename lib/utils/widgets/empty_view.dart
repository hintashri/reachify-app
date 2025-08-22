import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachify_app/theme/app_colors.dart';

class EmptyView extends StatelessWidget {
  final String? title;
  final String? desc;

  const EmptyView({super.key, this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title ?? 'Oops!',
          style: context.textTheme.labelLarge?.copyWith(
            color: AppColors.textDark,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          desc ?? 'No data available at a moment :(',
          style: context.textTheme.labelSmall?.copyWith(
            color: AppColors.textLight,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
