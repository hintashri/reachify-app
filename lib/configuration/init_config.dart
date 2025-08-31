import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:reachify_app/configuration/network_config.dart';
import 'package:reachify_app/models/category_model.dart';
import 'package:reachify_app/utils/const/logger.dart';
import 'package:reachify_app/utils/const/url_const.dart';
import 'package:reachify_app/utils/functions/app_func.dart';

import 'notification_config.dart';

final InitConfig init = InitConfig.instance;

class InitConfig extends GetxService {
  static final InitConfig instance = InitConfig();
  List<CategoryModel> bTypeList = <CategoryModel>[];
  List<CategoryModel> categoryList = <CategoryModel>[];

  Future<void> initCall() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    NotificationServices.initNotification();
    await _setOrientation();
    await _initGetStorage();
    await _getPackageInfo();
    if (!kIsWeb) {
      await _getDeviceInfo();
    }
    await networkCheck();
  }

  String packageName = 'Not Available';
  String packageVersion = '0.0.0+0';

  String deviceModel = 'Not Available';
  String deviceOs = 'Not Available';

  static Future<void> _setOrientation() async {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  static Future<void> _initGetStorage() async {
    try {
      logger.d('INITING GET STORAGE');
      await GetStorage.init();
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> _getPackageInfo() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      packageName = packageInfo.packageName;
      packageVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
    } on Exception catch (e, t) {
      logger.e('$e\n$t');
    }
  }

  Future<void> _getDeviceInfo() async {
    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      switch (Platform.operatingSystem) {
        case 'android':
          final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          deviceModel = androidInfo.model;
          deviceOs = '${androidInfo.version}';
          break;
        case 'ios':
          final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          deviceModel = iosInfo.utsname.machine;
          deviceOs = '${iosInfo.systemName} (${iosInfo.systemVersion})';
          break;
        default:
          final WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
          deviceModel = webBrowserInfo.userAgent ?? 'Unknown';
          deviceOs = Platform.operatingSystemVersion;
      }
    } on Exception catch (e, t) {
      logger.e('$e\n$t');
    }
  }

  static Future<void> networkCheck() async {
    // logger.i('check network');
    try {
      Connectivity().onConnectivityChanged.listen((
        List<ConnectivityResult> result,
      ) async {
        // logger.wtf(result);
        if (result.first == ConnectivityResult.none) {
          await AppFunc.appPopUp(
            title: 'No Internet',
            desc:
                'Network Connection Lost\nPlease Reconnect\nWait till reconnect...',
            showClose: false,
          );
        } else if (result.first != ConnectivityResult.none) {
          if (Get.context != null) {
            Get.back();
          }
        }
      });
    } on Exception catch (e, t) {
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
        // logger.d(bTypeList.length);
      } else {
        logger.e(response);
      }
    } catch (e, t) {
      logger.e('$e\n$t');
    }
  }

  Future<void> getCategories() async {
    try {
      final response = await net.get(url: UrlConst.getCategories, params: {});
      if (net.successfulRes(response: response)) {
        // final jsonData = jsonDecode(response.data);
        final List<dynamic> data = response.data;
        final List<CategoryModel> elements = data
            .map((json) => CategoryModel.fromJson(json))
            .toList();
        categoryList = elements;
        // logger.d(categoryList.length);
      } else {
        logger.e(response);
      }
    } catch (e, t) {
      logger.e('$e\n$t');
    }
  }
}
