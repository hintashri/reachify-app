import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:reachify_app/theme/app_colors.dart';

class AuthElevatedButton extends StatelessWidget {
  final bool isLoading;
  final String? title;
  final double radius;
  final Color? color;
  final VoidCallback? onPressed;
  final double verticalPadding;
  final Size? size;

  const AuthElevatedButton({
    super.key,
    this.onPressed,
    this.title,
    this.color,
    this.size,
    this.isLoading = false,
    this.radius = 10,
    this.verticalPadding = 14,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: color ?? AppColors.primary,
        backgroundColor: color ?? AppColors.primary,
        shadowColor: color ?? AppColors.primary,
        disabledBackgroundColor: color ?? AppColors.iconColor,
        disabledForegroundColor: color ?? AppColors.iconColor,
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        minimumSize: size,
        elevation: 0,
      ),
      child: isLoading
          ? const SpinKitThreeBounce(color: Colors.white, size: 22)
          : Text(
              title ?? '',
              style: context.textTheme.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}
