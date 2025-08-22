import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachify_app/theme/app_colors.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool onProfile;

  const AppBackButton({super.key, this.onPressed, this.onProfile = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: onProfile
          ? EdgeInsets.zero
          : const EdgeInsets.fromLTRB(12, 6, 0, 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap:
            onPressed ??
            () {
              FocusScope.of(context).unfocus();
              Get.back();
            },
        child: const Center(
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textLight,
            size: 23,
          ),
        ),
      ),
    );
  }
}
