import 'package:animate_do/animate_do.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
    return Obx(() {
      if (c.isLoading.value) {
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

      if (!c.hasInternet.value) {
        // ✅ Show No Internet UI with retry button
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 80, color: Colors.grey),
              const SizedBox(height: 20),
              Text(
                "No Internet Connection",
                style: context.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                "Please check your network and try again.",
                style: context.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: c.retry,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Retry"),
                ),
              ),
            ],
          ),
        );
      }

      // ✅ You could navigate to next screen here or show empty container
      return const SizedBox.shrink();
    });
  }
}

class SplashCtrl extends GetxController {
  var isLoading = true.obs;
  var hasInternet = true.obs;

  @override
  void onInit() {
    super.onInit();
    initCall();
  }

  Future<void> initCall() async {
    isLoading.value = true;

    final results = await Connectivity().checkConnectivity();

    // results is a List<ConnectivityResult>
    final hasConnection = results.any(
      (result) => result != ConnectivityResult.none,
    );

    if (!hasConnection) {
      hasInternet.value = false;
      isLoading.value = false;
      return;
    }

    hasInternet.value = true;
    try {
      await init.getCategories();
      await user.getCurrentUser();
      // Navigate to next screen if needed
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void retry() {
    initCall();
  }
}
