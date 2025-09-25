import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachify_app/configuration/init_config.dart';
import 'package:reachify_app/configuration/user_config.dart';
import 'package:reachify_app/modules/auth/create_acc_ctrl.dart';
import 'package:reachify_app/theme/app_colors.dart';
import 'package:reachify_app/utils/const/asset_const.dart';
import 'package:reachify_app/utils/const/logger.dart';
import 'package:reachify_app/utils/const/url_const.dart';
import 'package:reachify_app/utils/functions/app_file_picker.dart';
import 'package:reachify_app/utils/functions/validation_func.dart';
import 'package:reachify_app/utils/widgets/buttons/app_back_button.dart';
import 'package:reachify_app/utils/widgets/buttons/auth_elevated_button.dart';
import 'package:reachify_app/utils/widgets/cache_image.dart';
import 'package:reachify_app/utils/widgets/custom_dropdown.dart';
import 'package:reachify_app/utils/widgets/loading_view.dart';
import 'package:reachify_app/utils/widgets/svg_image.dart';

import '../../utils/widgets/auth_textfield.dart';

class CreateAccScreen extends StatelessWidget {
  CreateAccScreen({super.key});

  final c = Get.put(CreateAccCtrl());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: c.fromAuth() ? null : const AppBackButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
            child: Obx(() {
              if (c.canSkip.isTrue && user.appUser().businessName.isEmpty) {
                return InkWell(
                  onTap: c.initLoading()
                      ? null
                      : () {
                          c.useSkipToday();
                        },
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Text(
                      'SKIP',
                      style: context.textTheme.labelMedium?.copyWith(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              } else {
                return IconButton(
                  onPressed: Get.back,
                  icon: const Icon(Icons.close),
                );
              }
            }),
          ),
        ],
      ),
      body: Obx(() {
        if (c.initLoading.isTrue) {
          return const LoaderView();
        } else {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: FadeInUp(
              child: Form(
                key: c.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      user.appUser().businessName.isNotEmpty
                          ? 'Update Profile'
                          : 'Create an account',
                      style: context.textTheme.labelLarge?.copyWith(
                        color: AppColors.textDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Get FREE Updates of your Business',
                      style: context.textTheme.labelMedium?.copyWith(
                        color: AppColors.textDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    AuthTextField(
                      controller: c.nameController,
                      hintText: 'Enter Your Full Name',
                      textInputType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (value) => ValidationFunc.nameValidation(
                        name: value,
                        title: 'your full name',
                      ),
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      controller: c.bNameController,
                      hintText: 'Enter Your Business Name',
                      textInputType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (value) => ValidationFunc.nameValidation(
                        name: value,
                        title: 'your business name',
                      ),
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      controller: c.emailController,
                      hintText: 'Enter Your Email Address',
                      textInputType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      validator: (value) =>
                          ValidationFunc.emailValidation(email: value),
                    ),
                    const SizedBox(height: 20),
                    CustomDropDownButton<String>(
                      list: init.bTypeList.map((e) => e.name).toList(),
                      value: c.typeVal,
                      onChanged: (value) {
                        c.typeVal = value;
                        logger.d(value);
                      },
                      hintText: 'Business Type',
                      validator: (value) => ValidationFunc.categoryValidation(
                        category: value,
                        title: 'business type',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(() {
                      return OptimizedDropDownMenu<String>(
                        list: c.cityList
                            .map((e) => '${e.name}, ${e.stateName}')
                            .toList(),
                        value: c.cityVal.value,
                        onChanged: (value) {
                          c.cityVal.value = value;
                          logger.d(value);
                        },
                        hintText: 'Select Your City',
                        validator: (value) => ValidationFunc.categoryValidation(
                          category: value,
                          title: 'your city',
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                    Text(
                      'Visiting Card / GST Certificate',
                      style: context.textTheme.labelMedium?.copyWith(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        AppFilePicker.showFilePickerBottomSheet(
                          context: context,
                          onFilePicked: (value) {
                            logger.d(value);
                            c.filePath(value);
                          },
                        );
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox(
                        height: context.height * 0.19,
                        child: DottedBorder(
                          options: const RoundedRectDottedBorderOptions(
                            dashPattern: [6, 6],
                            strokeWidth: 1,
                            radius: Radius.circular(6),

                            color: AppColors.textLight,
                            // padding: EdgeInsets.symmetric(vertical: 32),
                          ),
                          child: Center(
                            child: Obx(() {
                              if (user.appUser().businessName.isNotEmpty &&
                                  user.appUser().image.isNotEmpty) {
                                return CacheImage(
                                  url:
                                      '${UrlConst.baseUrl}/storage/app/public/profile/${user.appUser().image}',
                                );
                              }
                              if (c.filePath().isNotEmpty) {
                                final ext = c.filePath().toLowerCase();
                                final isPdf = ext.endsWith('.pdf');
                                if (isPdf) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 30,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            '📂',
                                            style:
                                                context.textTheme.headlineLarge,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            c
                                                .filePath()
                                                .split('/file_picker/')
                                                .last,
                                            style: context.textTheme.labelSmall
                                                ?.copyWith(
                                                  color: AppColors.lightPrimary,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    clipBehavior: Clip.antiAlias,
                                    child: Image.file(
                                      File(c.filePath()),
                                      fit: BoxFit.cover,
                                      width: context.width,
                                    ),
                                  );
                                }
                              } else {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 32,
                                    ),
                                    child: Column(
                                      children: [
                                        const SVGImage(
                                          AssetConst.upload,
                                          height: 44,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Click to Upload',
                                          style: context.textTheme.labelSmall
                                              ?.copyWith(
                                                color: AppColors.lightPrimary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            }),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Obx(() {
                    //   return AuthElevatedButton(
                    //     isLoading: c.isButtonLoading(),
                    //     title: user.appUser().businessName.isNotEmpty
                    //         ? 'Update'
                    //         : 'Sign Up',
                    //     onPressed: () async {
                    //       if (c.formKey.currentState?.validate() ?? false) {
                    //         c.signup();
                    //       }
                    //     },
                    //   );
                    // }),
                  ],
                ),
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
              Obx(() {
                return AuthElevatedButton(
                  size: Size(context.width, 30),
                  isLoading: c.isButtonLoading(),
                  title: user.appUser().businessName.isNotEmpty
                      ? 'Update'
                      : 'Sign Up',
                  onPressed: () async {
                    if (c.formKey.currentState?.validate() ?? false) {
                      c.signup();
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
