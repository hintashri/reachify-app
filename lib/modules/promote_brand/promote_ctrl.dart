import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, MultipartFile;
import 'package:reachify_app/configuration/init_config.dart';
import 'package:reachify_app/configuration/network_config.dart';
import 'package:reachify_app/models/city_model.dart';
import 'package:reachify_app/routes/app_routes.dart';
import 'package:reachify_app/utils/const/url_const.dart';
import 'package:reachify_app/utils/functions/app_func.dart';

import '../../utils/const/logger.dart';

class PromoteCtrl extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController bNameController = TextEditingController();
  String? typeVal;
  String? cityVal;
  RxBool isButtonLoading = false.obs;
  RxBool initLoading = true.obs;
  List<CityModel> cityList = <CityModel>[];
  RxString title = ''.obs;

  @override
  void onInit() {
    super.onInit();
    setData();
    initCall();
  }

  void setData() {
    final data = Get.arguments;
    if (data is String && data.isNotEmpty) {
      title(data);
    }
  }

  Future<void> initCall() async {
    if (init.bTypeList.isEmpty) {
      await init.getBusinessType();
    }
    await getCity();
  }

  Future<void> getCity() async {
    try {
      final response = await net.post(
        url: UrlConst.getCity,
        params: {'country': 'India'},
      );
      if (net.successfulRes(response: response)) {
        final jsonData = jsonDecode(response.data);
        final List<dynamic> data = jsonData['result'];
        final List<CityModel> elements = data
            .map((json) => CityModel.fromJson(json))
            .toList();
        cityList = elements;
        cityList.sort((a, b) => a.name.compareTo(b.name));
        // logger.d(cityList.length);
      } else {
        logger.e(response);
      }
      initLoading(false);
    } catch (e, t) {
      logger.e('$e\n$t');
      initLoading(false);
    }
  }

  Future<void> submit() async {
    try {
      isButtonLoading(true);
      final List<String> allVal = cityVal?.split(', ') ?? [];
      final String str1 = allVal.first;
      final String country = cityList
          .where((e) => e.name == str1)
          .first
          .countryName;
      final String state = cityList
          .where((e) => e.name == str1)
          .first
          .stateName;
      final response = await net.post(
        url: UrlConst.updateUser,
        body: {
          'country': country,
          'state': state,
          'city': cityVal ?? '',
          'business_category': typeVal ?? '',
          'business_name': bNameController.text.trim(),
        },
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
