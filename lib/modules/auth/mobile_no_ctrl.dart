import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:reachify_app/configuration/init_config.dart';
import 'package:reachify_app/configuration/user_config.dart';
import 'package:reachify_app/models/country_model.dart';
import 'package:reachify_app/models/user_model.dart';
import 'package:reachify_app/routes/app_routes.dart';
import 'package:reachify_app/utils/const/url_const.dart';
import 'package:reachify_app/utils/functions/app_func.dart';
import '../../configuration/network_config.dart';
import '../../utils/const/logger.dart';

class MobileNoCtrl extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  String? categoryVal;
  Rx<String> countryCode = '91'.obs;
  RxBool initLoading = true.obs;
  RxBool gettingOTP = false.obs;
  RxBool sendingOTP = false.obs;
  RxBool resendingOtp = false.obs;
  List<CountryModel> countryList = <CountryModel>[];

  @override
  void onInit() {
    initCall();
    if (kDebugMode) {
      phoneController.text = '7600722722';
      otpController.text = '1234';
    }
    super.onInit();
  }

  Future<void> initCall() async {
    await getCountries();
  }

  Future<void> getCountries() async {
    try {
      final response = await net.post(
        url: UrlConst.getCountries,
        params: {'type': 'getCountries'},
      );
      if (net.successfulRes(response: response)) {
        final jsonData = jsonDecode(response.data);
        final List<dynamic> data = jsonData['result'];
        final List<CountryModel> elements = data
            .map((json) => CountryModel.fromJson(json))
            .toList();
        countryList = elements;
        // logger.d(countryList.length);
      } else {
        logger.e(response);
      }
      initLoading(false);
    } catch (e, t) {
      logger.e('$e\n$t');
      initLoading(false);
    }
  }

  Future<void> getOtp() async {
    try {
      gettingOTP(true);
      final response = await net.post(
        url: UrlConst.checkPhone,
        body: {'phone': '+${countryCode()}${phoneController.text.trim()}'},
      );
      if (net.successfulRes(response: response)) {
        logger.d(response);
        if (response.data['message'] == 'Sent Sucessfully' ||
            response.data['message'] == 'success') {
          await 2.delay();
          Get.offAndToNamed(AppRoutes.otp);
        }
      } else {
        AppFunc.showSnackBar(message: response);
        logger.e(response);
      }
      gettingOTP(false);
    } catch (e, t) {
      logger.e('$e\n$t');
      gettingOTP(false);
    }
  }

  Future<void> sendOtp() async {
    try {
      if (otpController.text.trim().isNotEmpty) {
        sendingOTP(true);
        final int categoryID = init.categoryList
            .where((e) => e.name == categoryVal)
            .first
            .id;
        final response = await net.post(
          url: UrlConst.verifyPhone,
          body: {
            'phone': '+${countryCode()}${phoneController.text.trim()}',
            'otp': otpController.text.trim(),
            'selectedCategory': categoryID,
            'country_code': countryCode(),
          },
        );
        if (net.successfulRes(response: response)) {
          logger.d(response);
          if (response.data['message'] == 'OTP verified') {
            final String token = response.data['token'];
            await net.init(token: token);
            final UserModel appUser = await user.getUserFromApi();
            appUser.token = token;
            user.setUser(appUser);
            if (user.appUser.businessName.isNotEmpty) {
              Get.offAllNamed(AppRoutes.home);
            } else {
              Get.offAllNamed(AppRoutes.createAcc, arguments: [true]);
            }
          }
        } else {
          AppFunc.showSnackBar(message: response);
          logger.e(response);
        }
        sendingOTP(false);
      } else {
        AppFunc.showSnackBar(message: 'Please add otp');
      }
    } catch (e, t) {
      logger.e('$e\n$t');
      sendingOTP(false);
    }
  }

  Future<void> resendOtp() async {
    try {
      resendingOtp(true);
      final response = await net.post(
        url: UrlConst.resendOtp,
        body: {'phone': '+${countryCode()}${phoneController.text.trim()}'},
      );
      if (net.successfulRes(response: response)) {
        logger.d(response);
        if (response.data['message'] == 'success') {
          await 2.delay();
          AppFunc.showSnackBar(message: 'Resent OPT to your phone number');
        }
      } else {
        AppFunc.showSnackBar(message: response);
        logger.e(response);
      }
      resendingOtp(false);
    } catch (e, t) {
      logger.e('$e\n$t');
      resendingOtp(false);
    }
  }
}
