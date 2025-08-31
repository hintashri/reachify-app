import 'package:get/get.dart';
import 'package:reachify_app/configuration/user_config.dart';
import 'package:reachify_app/routes/app_routes.dart';
import 'package:reachify_app/utils/const/asset_const.dart';
import 'package:reachify_app/utils/functions/app_func.dart';

Future<void> registerDialogue() async {
  if (user.appUser().businessName.isEmpty) {
    await AppFunc.appPopUp(
      title: 'Verify Profile',
      desc: 'Submit Valid Visiting Card or GST to Verify Your Profile.',
      assetName: AssetConst.person,
      buttonName: 'Edit Profile',
      buttonTap: () {
        Get.back();
        Get.toNamed(AppRoutes.createAcc);
      },
    );
  } else if (user.appUser().isVerify != 1) {
    await AppFunc.appPopUp(
      title: 'Your Profile Verified Soon',
      desc: 'Please Wait For Some Time, We Notified You Soon...',
      assetName: AssetConst.pending,
      buttonName: 'Ok',
      buttonTap: () {
        Get.back();
      },
    );
  }
  // AppFunc.appPopUp(
  //   title: 'Your Profile is Now Verified',
  //   desc: "Thanks for verifying. You're ready to explore everything.",
  //   assetName: AssetConst.verified,
  //   buttonName: 'Explore App',
  //   buttonTap: () {
  //     Get.back();
  //   },
  // );
}
