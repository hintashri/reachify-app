import 'package:get/get.dart';
import 'package:reachify_app/modules/auth/otp_screen.dart';
import 'package:reachify_app/modules/auth/mobile_no_screen.dart';
import 'package:reachify_app/modules/auth/create_acc_screen.dart';
import 'package:reachify_app/modules/products/category_screen.dart';
import 'package:reachify_app/modules/home/init_home_screen.dart';
import 'package:reachify_app/modules/products/wishlist_screen.dart';
import 'package:reachify_app/modules/splash/splash_screen.dart';
import 'package:reachify_app/routes/app_routes.dart';

class AppPages {
  static const Transition swipeUp = Transition.downToUp;
  static const Transition rightLeft = Transition.rightToLeft;

  static List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
      transition: swipeUp,
    ),
    GetPage(
      name: AppRoutes.mobileNoScreen,
      page: () => MobileNoScreen(),
      transition: swipeUp,
    ),
    GetPage(name: AppRoutes.otp, page: () => OtpScreen(), transition: swipeUp),
    GetPage(
      name: AppRoutes.createAcc,
      page: () => CreateAccScreen(),
      transition: swipeUp,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => InitHomeScreen(),
      transition: swipeUp,
    ),
    GetPage(
      name: AppRoutes.categoryScreen,
      page: () => const CategoryScreen(),
      transition: rightLeft,
    ),
    GetPage(
      name: AppRoutes.wishlist,
      page: () => WishlistScreen(),
      transition: rightLeft,
    ),
  ];
}
