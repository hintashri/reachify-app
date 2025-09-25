import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachify_app/theme/app_colors.dart';
import 'package:reachify_app/utils/widgets/buttons/auth_elevated_button.dart';
import 'package:reachify_app/utils/widgets/loading_view.dart';

import 'notification_ctrl.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final c = Get.put(NotificationCtrl());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
            child: InkWell(
              onTap: Get.back,
              borderRadius: BorderRadius.circular(10),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.close_rounded, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (c.initLoading()) {
          return const LoaderView();
        } else {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: FadeInUp(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    // 'Promote Your Brand',
                    'Notification Preferences',
                    style: context.textTheme.labelLarge?.copyWith(
                      color: AppColors.textDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Choose what updates you want to receive.',
                    style: context.textTheme.labelMedium?.copyWith(
                      color: AppColors.textDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  CommonSwitchTile(
                    title: 'All Hardware Updates',
                    value: true.obs,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CommonSwitchTile(
                    title: 'Architectural Hardware',
                    value: true.obs,
                  ),
                  CommonSwitchTile(
                    title: 'Bath Fittings & Sanitaryware',
                    value: true.obs,
                  ),
                  CommonSwitchTile(
                    title: 'Modular Kitchen & Wardrobe Acc.',
                    value: true.obs,
                  ),
                  CommonSwitchTile(title: 'Tiles & Ceramics', value: true.obs),
                  CommonSwitchTile(
                    title: 'Plywood & Laminates',
                    value: true.obs,
                  ),
                  CommonSwitchTile(
                    title: 'Aluminium & Glass Fittings',
                    value: true.obs,
                  ),
                  CommonSwitchTile(
                    title: 'Paints, Adhesives & Chemicals',
                    value: true.obs,
                  ),
                  CommonSwitchTile(
                    title: 'Interior Decor & Building Materials',
                    value: true.obs,
                  ),
                  CommonSwitchTile(
                    title: 'Plumbing Pipes & Fittings',
                    value: true.obs,
                  ),
                ],
              ),
            ),
          );
        }
      }),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(() {
                return AuthElevatedButton(
                  size: Size(context.width, 30),
                  isLoading: c.isButtonLoading(),
                  title: 'Save',
                  onPressed: () async {
                    c.isButtonLoading(true);
                    await 5.delay();
                    c.isButtonLoading(false);

                    // if (c.formKey.currentState?.validate() ?? false) {
                    //   c.getOtp();
                    // }
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class CommonSwitchTile extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final RxBool value;
  final Function(bool)? onChanged;

  const CommonSwitchTile({
    super.key,
    required this.title,
    required this.value,
    this.onChanged,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListTile(
        contentPadding: const EdgeInsets.only(left: 16, right: 20),
        title: Text(
          title,
          style:
              style ??
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: Transform.scale(
          scale: 0.9,
          child: Container(
            width: 36,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: value.value
                  ? [
                      // Shadow when switch is enabled
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 3,
                        offset: const Offset(0, 1.5),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [
                      // Lighter shadow when switch is disabled
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: CupertinoSwitch(
              value: value.value,
              inactiveTrackColor: const Color.fromRGBO(120, 120, 128, 0.16),
              activeTrackColor: const Color.fromRGBO(52, 199, 89, 1),
              onChanged: (val) {
                value.value = val;
                if (onChanged != null) onChanged!(val);
              },
            ),
          ),
        ),
      ),
    );
  }
}
