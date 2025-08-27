import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachify_app/configuration/init_config.dart';
import 'package:reachify_app/modules/promote_brand/promote_ctrl.dart';
import 'package:reachify_app/theme/app_colors.dart';
import 'package:reachify_app/utils/const/logger.dart';
import 'package:reachify_app/utils/functions/validation_func.dart';
import 'package:reachify_app/utils/widgets/buttons/auth_elevated_button.dart';
import 'package:reachify_app/utils/widgets/custom_dropdown.dart';
import 'package:reachify_app/utils/widgets/loading_view.dart';
import '../../utils/widgets/auth_textfield.dart';

class PromoteBrand extends StatelessWidget {
  PromoteBrand({super.key});

  final c = Get.put(PromoteCtrl());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
            child: Obx(() {
              return InkWell(
                onTap: Get.back,
                borderRadius: BorderRadius.circular(10),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.close_rounded, color: Colors.black),
                ),
              );
            }),
          ),
        ],
      ),
      body: Obx(() {
        if (c.initLoading()) {
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
                      'Promote Your Brand',
                      style: context.textTheme.labelLarge?.copyWith(
                        color: AppColors.textDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Get more visibility and direct inquiries.',
                      style: context.textTheme.labelMedium?.copyWith(
                        color: AppColors.textDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
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
                    CustomDropDownButton<String>(
                      list: c.cityList
                          .map((e) => '${e.name}, ${e.stateName}')
                          .toList(),
                      value: c.cityVal,
                      onChanged: (value) {
                        c.cityVal = value;
                        logger.d(value);
                      },
                      hintText: 'Select Your City',
                      validator: (value) => ValidationFunc.categoryValidation(
                        category: value,
                        title: 'your city',
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
                      controller: c.bNameController,
                      hintText: 'Enter Your Business Name',
                      textInputType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (value) => ValidationFunc.nameValidation(
                        name: value,
                        title: 'your business name',
                      ),
                    ),
                    const SizedBox(height: 40),
                    Obx(() {
                      return AuthElevatedButton(
                        isLoading: c.isButtonLoading(),
                        title: 'Submit',
                        onPressed: () async {
                          if (c.formKey.currentState?.validate() ?? false) {
                            c.submit();
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
      }),
    );
  }
}
