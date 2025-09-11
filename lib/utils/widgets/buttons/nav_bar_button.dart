import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachify_app/modules/home/init_home_ctrl.dart';
import 'package:reachify_app/modules/products/wishlist_ctrl.dart';
import 'package:reachify_app/utils/widgets/svg_image.dart';

class NavBarButton extends StatelessWidget {
  final InitHomeCtrl c = Get.find<InitHomeCtrl>();
  final WishlistCtrl wishlistCtrl = Get.find<WishlistCtrl>();

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
    return Obx(() {
      final bool isActive = index == c.activeTab();
      final bool isFavorite = index == 1;
      return Material(
        borderRadius: BorderRadius.circular(50),
        color: isActive
            ? const Color.fromRGBO(133, 133, 133, 0.12)
            : Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: onTap,
          child: Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              // color: isActive ? const Color.fromRGBO(133, 133, 133, 0.12) : null,
            ),
            child: Obx(() {
              final Widget icon = SVGImage(assetName, height: 24, width: 24);

              if (wishlistCtrl.productList.isNotEmpty && isFavorite) {
                return Center(
                  child: badges.Badge(
                    position: badges.BadgePosition.topEnd(top: -13, end: -10),
                    badgeStyle: const badges.BadgeStyle(badgeColor: Colors.red),
                    badgeContent: Text(
                      '${wishlistCtrl.productList.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    child: icon,
                  ),
                );
              } else {
                return Center(child: icon); // no FittedBox needed
              }
            }),
          ),
        ),
      );
    });
  }
}
