import 'package:get/get.dart' hide Response;
import 'package:intl/intl.dart';
import 'package:reachify_app/configuration/init_config.dart';
import 'package:reachify_app/configuration/network_config.dart';
import 'package:reachify_app/configuration/pref_config.dart';
import 'package:reachify_app/models/user_model.dart';
import 'package:reachify_app/routes/app_routes.dart';
import 'package:reachify_app/utils/const/key_const.dart';
import 'package:reachify_app/utils/const/url_const.dart';
import 'package:reachify_app/utils/functions/app_func.dart';

import '../utils/const/logger.dart';

final UserConfig user = UserConfig.instance;

class UserConfig {
  static final UserConfig instance = UserConfig();

  bool get userLogin => appUser().id != 0;

  int get userId => appUser().id;

  bool get userVerified => appUser().businessName.isNotEmpty;

  Rx<UserModel> appUser = UserModel().obs;

  // void detailNavigation({
  //   required int index,
  //   required List<ProductModel> products,
  // }) {
  //   if (user.appUser.userVerified) {
  //     Get.toNamed(
  //       AppRoutes.productDetail,
  //       arguments: {'index': index, 'list': products},
  //     );
  //   } else {
  //     c.openDialogue();
  //   }
  // }

  //CALL THIS ON SUCCESSFUL SIGNUP AND SIGNIN
  Future<void> setUser(UserModel user) async {
    appUser.value = user;
    logger.i(appUser.toJson());
    await prefs.setValue(key: KeyConst.userKey, value: appUser().token);
    return;
  }

  Future<void> logoutUser() async {
    appUser.value = UserModel();
    net.init(token: '');
    await prefs.removeValue(key: KeyConst.userKey);
    Get.offAllNamed(AppRoutes.mobileNoScreen);
  }

  Future<UserModel> getUserFromApi() async {
    try {
      final response = await net.get(url: UrlConst.getUser, params: {});
      if (net.successfulRes(response: response)) {
        // logger.f(response.data);
        logger.d('user get successfully');
        final UserModel user = UserModel.fromJson(json: response.data);
        return user;
      } else {
        AppFunc.showSnackBar(message: response.message);
        return UserModel();
      }
    } catch (e, t) {
      logger.e('$e\n$t');
      return UserModel();
    }
  }

  //GET USER AT INIT
  Future<void> getCurrentUser() async {
    final s = await prefs.getValue(key: KeyConst.userKey);
    logger.d(s);
    if (s is String) {
      await net.init(token: s);
      final UserModel user = await getUserFromApi();
      if (user.id != 0) {
        user.token = s;
        setUser(user);
        await init.getBusinessType();
        Get.offAllNamed(AppRoutes.home);
      } else {
        logoutUser();
      }
    } else {
      logoutUser();
    }
  }

  Future<bool> canSkip() async {
    final int skipCount = prefs.getValue(key: 'skipCount') ?? 0;
    if (skipCount >= 3) return false; // already used 3 days

    return true; // allowed to skip
  }

  Future<void> useSkipToday() async {
    final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    int skipCount = prefs.getValue(key: 'skipCount') ?? 0;
    final String? lastSkippedDate = prefs.getValue(key: 'lastSkippedDate');

    if (lastSkippedDate != today) {
      // new skip day → increment skipCount
      skipCount++;
      await prefs.setValue(key: 'skipCount', value: skipCount);
      await prefs.setValue(key: 'lastSkippedDate', value: today);
    }
  }
}
