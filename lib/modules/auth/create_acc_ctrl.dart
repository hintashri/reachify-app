import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, MultipartFile;
import 'package:reachify_app/configuration/init_config.dart';
import 'package:reachify_app/configuration/network_config.dart';
import 'package:reachify_app/configuration/user_config.dart';
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
  var cityVal = Rxn<String>();
  Rx<String> filePath = ''.obs;

  // RxnString? cityVal;

  RxBool canSkip = false.obs;
  RxBool isButtonLoading = false.obs;
  RxBool initLoading = false.obs;
  RxBool fromAuth = false.obs;
  List<CityModel> cityList = <CityModel>[];

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      fromAuth(Get.arguments[0]);
    }
    initCall();
  }

  // Future<void> manageSkip() async {
  //   try {
  //     final s =
  //         await prefs.getValue(key: KeyConst.skipKey) ?? <String, dynamic>{};
  //     final int counts = s[KeyConst.skipCount] ?? 0;
  //     final String d = s[KeyConst.skipDate] ?? '';
  //     if (counts != 0 && d.isNotEmpty) {
  //       logger.d('counts==$counts\ndate==$d');
  //       final DateTime date = DateTime.parse(d);
  //       final DateTime today = DateTime.now();
  //       if (today.isSameDay(date)) {
  //         await prefs.setValue(
  //           key: KeyConst.skipKey,
  //           value: {
  //             KeyConst.skipCount: counts,
  //             KeyConst.skipDate: DateTime.now().toIso8601String(),
  //           },
  //         );
  //       } else {
  //         await prefs.setValue(
  //           key: KeyConst.skipKey,
  //           value: {
  //             KeyConst.skipCount: counts + 1,
  //             KeyConst.skipDate: DateTime.now().toIso8601String(),
  //           },
  //         );
  //       }
  //     } else {
  //       await prefs.setValue(
  //         key: KeyConst.skipKey,
  //         value: {
  //           KeyConst.skipCount: 1,
  //           KeyConst.skipDate: DateTime.now().toIso8601String(),
  //         },
  //       );
  //     }
  //     if (counts < 4) {
  //       Get.offAllNamed(AppRoutes.home);
  //     } else {
  //       //show dialogue
  //     }
  //   } catch (e, t) {
  //     logger.e('$e\n$t');
  //   }
  // }

  Future<void> canSkips() async {
    try {
      final s =
          await prefs.getValue(key: KeyConst.skipKey) ?? <String, dynamic>{};
      final int counts = s[KeyConst.skipCount] ?? 0;

      // You had counts < 4 check earlier, so let's keep that
      counts < 4 ? canSkip(true) : canSkip(false);
    } catch (e, t) {
      logger.e('$e\n$t');
      canSkip(false);
    }
  }

  Future<void> useSkipToday() async {
    try {
      final s =
          await prefs.getValue(key: KeyConst.skipKey) ?? <String, dynamic>{};
      final int counts = s[KeyConst.skipCount] ?? 0;
      final String d = s[KeyConst.skipDate] ?? '';
      final DateTime today = DateTime.now();

      if (counts != 0 && d.isNotEmpty) {
        final DateTime lastDate = DateTime.parse(d);

        if (!today.isSameDay(lastDate)) {
          // New day -> increment skip count
          await prefs.setValue(
            key: KeyConst.skipKey,
            value: {
              KeyConst.skipCount: counts + 1,
              KeyConst.skipDate: today.toIso8601String(),
            },
          );
        } else {
          // Same day -> just update date to refresh timestamp
          await prefs.setValue(
            key: KeyConst.skipKey,
            value: {
              KeyConst.skipCount: counts,
              KeyConst.skipDate: today.toIso8601String(),
            },
          );
        }
      } else {
        // First ever skip
        await prefs.setValue(
          key: KeyConst.skipKey,
          value: {
            KeyConst.skipCount: 1,
            KeyConst.skipDate: today.toIso8601String(),
          },
        );
      }
    } catch (e, t) {
      logger.e('$e\n$t');
    }
  }

  Future<void> initCall() async {
    initLoading(true);
    await Future.wait([
      canSkips(),
      if (init.bTypeList.isEmpty) init.getBusinessType(),
      getCity(),
    ]);
    setData();
    initLoading(false);
  }

  void setData() {
    if (user.appUser().businessName.isNotEmpty) {
      logger.d(user.appUser.toJson());
      nameController.text = user.appUser().name;
      bNameController.text = user.appUser().businessName;
      emailController.text = user.appUser().email;
      typeVal = init.bTypeList
          .firstWhereOrNull((e) => e.id == user.appUser().businessCategory)
          ?.name;
      cityVal.value = cityList
          .firstWhereOrNull((e) => e.name == user.appUser().city)
          ?.name;
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
        // logger.d(cityList.length);
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
        final List<String> allVal = cityVal.split(', ') ?? [];
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
            if (user.appUser().businessName.isNotEmpty) 'id': user.appUser().id,
            'name': nameController.text.trim(),
            'email': emailController.text.trim(),
            'country': country,
            'state': state,
            'city': cityVal,
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
