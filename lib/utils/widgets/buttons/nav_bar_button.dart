import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachify_app/modules/home/init_home_ctrl.dart';

class NavBarButton extends StatelessWidget {
  final InitHomeCtrl c = Get.find<InitHomeCtrl>();

  final String assetName;
  final int index;
  final VoidCallback? onTap;

  NavBarButton({
    super.key,
    required this.assetName,
    this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Obx(() {
        return Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: c.activeTab() == index
                ? const Color.fromRGBO(133, 133, 133, 0.12)
                : null,
          ),
          child: Image.asset(assetName, height: 24),
        );
      }),
    );
  }
}
