import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:reachify_app/configuration/init_config.dart';
import 'package:reachify_app/configuration/user_config.dart';
import 'package:reachify_app/models/user_model.dart';
import 'package:reachify_app/routes/app_routes.dart';
import 'package:reachify_app/utils/const/url_const.dart';
import 'package:reachify_app/utils/functions/app_func.dart';

import '../../configuration/network_config.dart';
import '../../utils/const/logger.dart';

class OtpScreenCtrl extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();

  // Data from login screen
  String phoneNumber = '';
  String countryCode = '91';
  String? categoryVal;

  // Loading states
  RxBool sendingOTP = false.obs;
  RxBool resendingOtp = false.obs;

  // Timer related variables
  Timer? _resendTimer;
  RxInt resendCountdown = 0.obs;
  RxBool canResendOtp = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Get arguments from previous screen
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      phoneNumber = args['phone'] ?? '';
      countryCode = args['countryCode'] ?? '91';
      categoryVal = args['categoryVal'];
    }

    if (kDebugMode) {
      otpController.text = '1234';
    }

    // Start timer immediately when OTP screen opens
    _startResendTimer();
  }

  @override
  void onClose() {
    _cancelResendTimer();
    otpController.dispose();
    super.onClose();
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
            'phone': phoneNumber,
            'otp': otpController.text.trim(),
            'selectedCategory': categoryID,
            'country_code': countryCode,
          },
        );
        if (net.successfulRes(response: response)) {
          logger.d(response);
          if (response.data['message'] == 'OTP verified') {
            _cancelResendTimer();
            final String token = response.data['token'];
            await net.init(token: token);
            final UserModel appUser = await user.getUserFromApi();
            appUser.token = token;
            user.setUser(appUser);
            if (user.appUser().businessName.isNotEmpty) {
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
    if (!canResendOtp() || resendingOtp()) return;

    try {
      resendingOtp(true);
      final response = await net.post(
        url: UrlConst.resendOtp,
        body: {'phone': phoneNumber},
      );
      if (net.successfulRes(response: response)) {
        logger.d(response);
        if (response.data['message'] == 'success') {
          await 2.delay();
          AppFunc.showSnackBar(message: 'Resent OTP to your phone number');
          _startResendTimer();
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

  void _startResendTimer() {
    _cancelResendTimer(); // Cancel any existing timer
    canResendOtp(false);
    resendCountdown(60);

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCountdown() > 0) {
        resendCountdown(resendCountdown() - 1);
        logger.d('Timer Updated: ${resendCountdown.value}');
      } else {
        _cancelResendTimer();
        canResendOtp(true);
        logger.d('Timer completed, resend enabled');
      }
    });
  }

  void _cancelResendTimer() {
    _resendTimer?.cancel();
    _resendTimer = null;
    resendCountdown(0);
  }

  String get resendTimerText {
    if (resendCountdown.value > 0) {
      final minutes = resendCountdown.value ~/ 60;
      final seconds = resendCountdown.value % 60;
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '';
  }

  // void goBackToLogin() {
  //   _cancelResendTimer();
  //   Get.offAllNamed(AppRoutes.login);
  // }

  // Helper method to get formatted phone number for display
  String get formattedPhoneNumber {
    if (phoneNumber.isNotEmpty) {
      return phoneNumber;
    }
    return '';
  }

  // Clear OTP field
  void clearOtp() {
    otpController.clear();
  }

  // Validate OTP length
  bool isOtpValid() {
    return otpController.text.trim().length >= 4;
  }
}
