import 'package:animate_do/animate_do.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:reachify_app/configuration/init_config.dart';
import 'package:reachify_app/models/country_model.dart';
import 'package:reachify_app/modules/auth/mobile_no_ctrl.dart';
import 'package:reachify_app/theme/app_colors.dart';
import 'package:reachify_app/utils/const/asset_const.dart';
import 'package:reachify_app/utils/const/key_const.dart';
import 'package:reachify_app/utils/const/logger.dart';
import 'package:reachify_app/utils/functions/validation_func.dart';
import 'package:reachify_app/utils/widgets/buttons/auth_elevated_button.dart';
import 'package:reachify_app/utils/widgets/country_code.dart';
import 'package:reachify_app/utils/widgets/custom_dropdown.dart';
import 'package:reachify_app/utils/widgets/loading_view.dart';
import 'package:reachify_app/utils/widgets/svg_image.dart';
import 'package:reachify_app/utils/widgets/web_view_screen.dart';

import '../../utils/widgets/auth_textfield.dart';

class MobileNoScreen extends StatelessWidget {
  MobileNoScreen({super.key});

  final c = Get.put(MobileNoCtrl());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Obx(() {
        if (c.initLoading()) {
          return const LoaderView();
        } else {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            child: Form(
              key: c.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ZoomIn(
                    child: SVGImage(
                      AssetConst.authImage,
                      height: context.height * 0.25,
                    ),
                  ),
                  const SizedBox(height: 40),
                  FadeIn(
                    child: Text(
                      'Verify Your Phone Number',
                      style: context.textTheme.labelLarge?.copyWith(
                        color: AppColors.textDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FadeIn(
                    child: Text(
                      'We will send you one-time password to\nyour mobile number',
                      style: context.textTheme.labelMedium?.copyWith(
                        color: AppColors.textDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 25),
                  FadeInUp(
                    delay: const Duration(milliseconds: 500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Mobile Number',
                          style: context.textTheme.labelSmall?.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CountryCodePicker(
                              countryList: c.countryList,
                              onChanged: (CountryModel value) {
                                c.countryCode(value.phoneCode);
                                logger.d(value.toJson());
                              },
                              initialSelection: '91',
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: AuthTextField(
                                controller: c.phoneController,
                                hintText: 'Enter Your Mobile Number',
                                textInputType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                textInputAction: TextInputAction.next,
                                validator: (value) =>
                                    ValidationFunc.phoneValidation(
                                      phone: value,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Text(
                          'Business Category',
                          style: context.textTheme.labelSmall?.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 5),
                        CustomDropDownButton<String>(
                          list: init.categoryList.map((e) => e.name).toList(),
                          value: c.categoryVal,
                          onChanged: (value) {
                            c.categoryVal = value;
                            logger.d(value);
                          },
                          hintText: 'Select Category',
                          validator: (value) =>
                              ValidationFunc.categoryValidation(
                                category: value,
                                title: 'category',
                              ),
                        ),
                        // const SizedBox(height: 30),
                        // RichText(
                        //   textAlign: TextAlign.center,
                        //   text: TextSpan(
                        //     style: context.textTheme.labelSmall?.copyWith(
                        //       color: AppColors.textLight,
                        //     ),
                        //     children: [
                        //       const TextSpan(
                        //         text: 'By continuing, you agree to our ',
                        //       ),
                        //       TextSpan(
                        //         text: 'Terms of Service',
                        //         style: context.textTheme.labelSmall?.copyWith(
                        //           color: AppColors.lightPrimary,
                        //           fontWeight: FontWeight.w500,
                        //           decoration: TextDecoration.underline,
                        //           decorationColor: AppColors.lightPrimary,
                        //         ),
                        //         recognizer: TapGestureRecognizer()
                        //           ..onTap = () {
                        //             Get.to(
                        //               () => const WebViewScreen(
                        //                 url: KeyConst.termsCondition,
                        //                 title: 'Terms of Service',
                        //               ),
                        //             );
                        //           },
                        //       ),
                        //       TextSpan(
                        //         text: ' and ',
                        //         style: context.textTheme.labelSmall?.copyWith(
                        //           color: AppColors.textLight,
                        //         ),
                        //       ),
                        //       TextSpan(
                        //         text: 'Privacy Policy',
                        //         style: context.textTheme.labelSmall?.copyWith(
                        //           color: AppColors.lightPrimary,
                        //           fontWeight: FontWeight.w500,
                        //           decoration: TextDecoration.underline,
                        //           decorationColor: AppColors.lightPrimary,
                        //         ),
                        //         recognizer: TapGestureRecognizer()
                        //           ..onTap = () {
                        //             Get.to(
                        //               () => const WebViewScreen(
                        //                 url: KeyConst.privacyPolicy,
                        //                 title: 'Privacy Policy',
                        //               ),
                        //             );
                        //           },
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // const SizedBox(height: 15),
                        // Obx(() {
                        //   return AuthElevatedButton(
                        //     isLoading: c.gettingOTP(),
                        //     title: 'Get Code',
                        //     onPressed: () async {
                        //       if (c.formKey.currentState?.validate() ?? false) {
                        //         c.getOtp();
                        //       }
                        //     },
                        //   );
                        // }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 15),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: context.textTheme.labelSmall?.copyWith(
                    color: AppColors.textLight,
                  ),
                  children: [
                    const TextSpan(text: 'By continuing, you agree to our '),
                    TextSpan(
                      text: 'Terms of Service',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: AppColors.lightPrimary,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.lightPrimary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(
                            () => const WebViewScreen(
                              url: KeyConst.termsCondition,
                              title: 'Terms of Service',
                            ),
                          );
                        },
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: AppColors.lightPrimary,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.lightPrimary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(
                            () => const WebViewScreen(
                              url: KeyConst.privacyPolicy,
                              title: 'Privacy Policy',
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Obx(() {
                return AuthElevatedButton(
                  size: Size(context.width, 30),
                  isLoading: c.gettingOTP(),
                  title: 'Get Code',
                  onPressed: () async {
                    if (c.formKey.currentState?.validate() ?? false) {
                      c.getOtp();
                    }
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
