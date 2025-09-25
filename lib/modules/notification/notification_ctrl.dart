import 'package:get/get.dart' hide Response, MultipartFile;
import 'package:reachify_app/configuration/network_config.dart';
import 'package:reachify_app/routes/app_routes.dart';
import 'package:reachify_app/utils/const/url_const.dart';
import 'package:reachify_app/utils/functions/app_func.dart';

import '../../utils/const/logger.dart';

class NotificationCtrl extends GetxController {
  RxBool isButtonLoading = false.obs;
  RxBool initLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    initCall();
  }

  Future<void> initCall() async {
    // await init.getBusinessType();
  }

  Future<void> submit() async {
    try {
      isButtonLoading(true);

      final response = await net.post(
        url: UrlConst.updateUser,
        body: {},
        isRaw: false,
      );
      if (net.successfulRes(response: response)) {
        logger.d(response);
        Get.offAllNamed(AppRoutes.home);
      } else {
        AppFunc.showSnackBar(message: response);
        logger.e(response);
      }
      isButtonLoading(false);
    } catch (e, t) {
      logger.e('$e\n$t');
      isButtonLoading(false);
    }
  }
}
