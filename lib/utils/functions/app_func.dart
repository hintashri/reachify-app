import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachify_app/configuration/user_config.dart';
import 'package:reachify_app/theme/app_colors.dart';
import 'package:reachify_app/utils/widgets/buttons/auth_elevated_button.dart';
import 'package:reachify_app/utils/widgets/svg_image.dart';

class AppFunc {
  static Future<dynamic> showSnackBar({required String message}) async {
    return ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
    );
  }

  static Future<dynamic> appPopUp({
    bool barrierDismissible = false,
    Color? dialogColor,
    bool showClose = true,
    String? assetName,
    String? buttonName,
    VoidCallback? buttonTap,
    Widget? child,
    required String title,
    required String desc,
  }) {
    return showDialog(
      context: Get.context!,
      barrierDismissible: barrierDismissible,
      builder: (context) => PopScope(
        canPop: barrierDismissible,
        child: CustomBackdropFilter(
          child: SimpleDialog(
            backgroundColor: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            elevation: 0,
            alignment: Alignment.center,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: dialogColor ?? Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (child != null) ...[const SizedBox(height: 12)],
                    if (showClose && child == null) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
                        child: IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(
                            Icons.close_rounded,
                            color: AppColors.iconColor,
                          ),
                        ),
                      ),
                    ],
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        20,
                        showClose ? 10 : 15,
                        20,
                        25,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (assetName != null) ...[
                            SVGImage(assetName, height: 150),
                            const SizedBox(height: 30),
                          ],
                          Text(
                            title,
                            style: context.textTheme.labelLarge?.copyWith(
                              color: AppColors.textDark,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            desc,
                            style: context.textTheme.labelSmall?.copyWith(
                              color: AppColors.textLight,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (child != null) ...[child],

                          if (buttonName != null) ...[
                            const SizedBox(height: 30),
                            AuthElevatedButton(
                              title: buttonName,
                              onPressed: buttonTap,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<dynamic> deletePopUp({
    bool barrierDismissible = true,
    Color? dialogColor,
    VoidCallback? onTap,
    bool isLogout = false,
  }) {
    return showDialog(
      context: Get.context!,
      barrierDismissible: barrierDismissible,
      builder: (context) => PopScope(
        canPop: barrierDismissible,
        child: CustomBackdropFilter(
          child: FadeInUp(
            child: AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    isLogout ? 'Logout' : 'Delete account?',
                    style: context.textTheme.labelLarge?.copyWith(
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    isLogout
                        ? 'Are you sure! you want to logout from this account?'
                        : 'Are you sure! you want to delete this account?',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),

              actions: [
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5),
                          onTap: () {
                            Get.back();
                          },
                          child: Text(
                            'Cancel',
                            style: context.textTheme.labelLarge?.copyWith(
                              color: AppColors.textLight,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5),
                          onTap: () {
                            if (isLogout) {
                              user.logoutUser();
                            } else {
                              user.deleteUser();
                            }
                          },
                          child: Text(
                            isLogout ? 'Logout' : 'Delete',
                            style: context.textTheme.labelLarge?.copyWith(
                              color: AppColors.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomBackdropFilter extends StatelessWidget {
  final Widget? child;
  final double? sigmaX;
  final double? sigmaY;

  const CustomBackdropFilter({
    super.key,
    required this.child,
    this.sigmaX,
    this.sigmaY,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: sigmaX ?? 5, sigmaY: sigmaY ?? 5),
      child: child,
    );
  }
}
