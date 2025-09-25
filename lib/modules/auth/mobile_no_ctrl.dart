import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:reachify_app/models/country_model.dart';
import 'package:reachify_app/routes/app_routes.dart';
import 'package:reachify_app/utils/const/url_const.dart';
import 'package:reachify_app/utils/functions/app_func.dart';

import '../../configuration/network_config.dart';
import '../../utils/const/logger.dart';

class MobileNoCtrl extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  String? categoryVal;
  Rx<String> countryCode = '91'.obs;
  RxBool initLoading = true.obs;
  RxBool gettingOTP = false.obs;
  List<CountryModel> countryList = <CountryModel>[];

  @override
  void onInit() {
    initCall();
    if (kDebugMode) {
      phoneController.text = '7600722722';
    }
    super.onInit();
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
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
          Get.offAndToNamed(
            AppRoutes.otp,
            arguments: {
              'phone': '+${countryCode()}${phoneController.text.trim()}',
              'countryCode': countryCode(),
              'categoryVal': categoryVal,
            },
          );
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
}
