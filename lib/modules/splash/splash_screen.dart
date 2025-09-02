import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:reachify_app/configuration/init_config.dart';
import 'package:reachify_app/configuration/user_config.dart';
import 'package:reachify_app/theme/app_colors.dart';
import 'package:reachify_app/utils/const/asset_const.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashCtrl c = Get.put(SplashCtrl());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZoomIn(
            child: Image.asset(
              AssetConst.appLogo,
              height: context.height * 0.4,
            ),
          ),
          const SizedBox(height: 60),
          FadeInUp(
            child: Text(
              'Welcome to Reachify',
              style: context.textTheme.headlineSmall?.copyWith(
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class SplashCtrl extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    initCall();
    super.onInit();
  }

  Future<void> initCall() async {
    await init.getCategories();
    await user.getCurrentUser();
  }
}
