import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, MultipartFile;
import 'package:reachify_app/configuration/network_config.dart';
import 'package:reachify_app/models/category_model.dart';
import 'package:reachify_app/models/city_model.dart';
import 'package:reachify_app/routes/app_routes.dart';
import 'package:reachify_app/utils/const/url_const.dart';
import 'package:reachify_app/utils/extensions/date_extension.dart';
import 'package:reachify_app/utils/functions/app_func.dart';
import '../../configuration/pref_config.dart';
import '../../utils/const/key_const.dart';
import '../../utils/const/logger.dart';

class CreateAccCtrl extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? typeVal;
  String? cityVal;
  RxBool isButtonLoading = false.obs;
  RxBool initLoading = true.obs;
  RxBool fromAuth = false.obs;
  List<CityModel> cityList = <CityModel>[];
  List<CategoryModel> bTypeList = <CategoryModel>[];
  Rx<String> filePath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      fromAuth(Get.arguments[0]);
    }
    initCall();
  }

  Future<void> manageSkip() async {
    try {
      final s =
          await prefs.getValue(key: KeyConst.skipKey) ?? <String, dynamic>{};
      final int counts = s[KeyConst.skipCount] ?? 0;
      final String d = s[KeyConst.skipDate] ?? '';
      if (counts != 0 && d.isNotEmpty) {
        logger.d('counts==$counts\ndate==$d');
        final DateTime date = DateTime.parse(d);
        final DateTime today = DateTime.now();
        if (today.isSameDay(date)) {
          await prefs.setValue(
            key: KeyConst.skipKey,
            value: {
              KeyConst.skipCount: counts,
              KeyConst.skipDate: DateTime.now().toIso8601String(),
            },
          );
        } else {
          await prefs.setValue(
            key: KeyConst.skipKey,
            value: {
              KeyConst.skipCount: counts + 1,
              KeyConst.skipDate: DateTime.now().toIso8601String(),
            },
          );
        }
      } else {
        await prefs.setValue(
          key: KeyConst.skipKey,
          value: {
            KeyConst.skipCount: 1,
            KeyConst.skipDate: DateTime.now().toIso8601String(),
          },
        );
      }
      if (counts < 4) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        //show dialogue
      }
    } catch (e, t) {
      logger.e('$e\n$t');
    }
  }

  Future<void> initCall() async {
    await getCity();
    await getBusinessType();
    if (cityList.isNotEmpty && bTypeList.isNotEmpty) {
      initLoading(false);
    }
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
        logger.d(cityList.length);
      } else {
        logger.e(response);
      }
    } catch (e, t) {
      logger.e('$e\n$t');
    }
  }

  Future<void> getBusinessType() async {
    try {
      final response = await net.get(url: UrlConst.getBusinessType, params: {});
      if (net.successfulRes(response: response)) {
        // final jsonData = jsonDecode(response.data);
        final List<dynamic> data = response.data;
        final List<CategoryModel> elements = data
            .map((json) => CategoryModel.fromJson(json))
            .toList();
        bTypeList = elements;
        logger.d(bTypeList.length);
      } else {
        logger.e(response);
      }
    } catch (e, t) {
      logger.e('$e\n$t');
    }
  }

  Future<void> signup() async {
    try {
      if (filePath().isNotEmpty) {
        isButtonLoading(true);
        final String country = cityList
            .where((e) => e.name == cityVal)
            .first
            .countryName;
        final String state = cityList
            .where((e) => e.name == cityVal)
            .first
            .stateName;
        final response = await net.post(
          url: UrlConst.updateUser,
          body: {
            'name': nameController.text.trim(),
            'email': emailController.text.trim(),
            'country': country,
            'state': state,
            'city': cityVal ?? '',
            'business_category': typeVal ?? '',
            'business_name': bNameController.text.trim(),
            'image': await MultipartFile.fromFile(
              filePath(),
              filename: 'doc_img_${DateTime.now().microsecondsSinceEpoch}.png',
            ),
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
      } else {
        AppFunc.showSnackBar(message: 'Please your business document');
      }
    } catch (e, t) {
      logger.e('$e\n$t');
      isButtonLoading(false);
    }
  }
}
