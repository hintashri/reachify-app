import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:reachify_app/modules/auth/mobile_no_ctrl.dart';
import 'package:reachify_app/theme/app_colors.dart';
import 'package:reachify_app/utils/const/asset_const.dart';
import 'package:reachify_app/utils/widgets/buttons/auth_elevated_button.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key});

  final c = Get.find<MobileNoCtrl>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ZoomIn(
              child: Image.asset(
                AssetConst.authImage,
                height: context.height * 0.25,
              ),
            ),
            const SizedBox(height: 40),
            FadeIn(
              child: Text(
                'OTP Verification',
                style: context.textTheme.labelLarge?.copyWith(
                  color: AppColors.textDark,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            FadeIn(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: context.textTheme.labelMedium?.copyWith(
                    color: AppColors.textDark,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Enter the code from the sms we sent to\n',
                    ),
                    TextSpan(
                      text:
                          '+${c.countryCode} ${c.phoneController.text.trim()}',
                      style: context.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: context.height * 0.1),
            FadeInUp(
              delay: const Duration(milliseconds: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PinCodeTextField(
                    appContext: context,
                    length: 4,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    animationDuration: const Duration(milliseconds: 300),
                    controller: c.otpController,
                    keyboardType: TextInputType.number,
                    backgroundColor: Colors.transparent,
                    cursorColor: AppColors.primary,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10),
                      fieldHeight: 50,
                      fieldWidth: 50,
                      activeColor: AppColors.primary,
                      disabledColor: Theme.of(context).disabledColor,
                      errorBorderColor: Theme.of(context).colorScheme.error,
                      inactiveColor: Theme.of(context).disabledColor,
                      selectedColor: AppColors.primary,
                      borderWidth: 1,
                      activeBorderWidth: 1,
                      disabledBorderWidth: 1,
                      errorBorderWidth: 1,
                      inactiveBorderWidth: 1,
                      selectedBorderWidth: 1,
                    ),
                    onCompleted: (v) {
                      debugPrint('Completed');
                    },
                    onChanged: (value) {
                      debugPrint(value);
                    },
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: context.textTheme.labelSmall?.copyWith(
                        color: AppColors.textLight,
                      ),
                      children: [
                        const TextSpan(text: 'Didn’t you receive the OTP?'),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(5),
                            onTap: c.resendingOtp()
                                ? null
                                : () async {
                                    await c.resendOtp();
                                  },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 8,
                              ),
                              child: Obx(() {
                                if (c.resendingOtp()) {
                                  return const CupertinoActivityIndicator();
                                } else {
                                  return Text(
                                    'Resend OTP',
                                    style: context.textTheme.labelSmall
                                        ?.copyWith(
                                          color: AppColors.lightPrimary,
                                          fontWeight: FontWeight.w500,
                                          decoration: TextDecoration.underline,
                                          decorationColor:
                                              AppColors.lightPrimary,
                                        ),
                                  );
                                }
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: context.height * 0.15),
                  Obx(() {
                    return AuthElevatedButton(
                      isLoading: c.sendingOTP(),
                      title: 'Submit OTP',
                      onPressed: () async {
                        c.sendOtp();
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
