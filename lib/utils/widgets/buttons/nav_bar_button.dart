import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachify_app/modules/home/init_home_ctrl.dart';
import 'package:reachify_app/modules/products/wishlist_ctrl.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Obx(() {
        final bool isActive = c.activeTab() == index;
        final bool isFavorite = index == 1;
        return Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? const Color.fromRGBO(133, 133, 133, 0.12) : null,
          ),
          child: Obx(() {
            if (wishlistCtrl.productList.isNotEmpty && isFavorite) {
              return Center(
                child: badges.Badge(
                  position: badges.BadgePosition.topEnd(top: -13, end: -10),
                  badgeStyle: const badges.BadgeStyle(badgeColor: Colors.red),
                  badgeContent: Text(
                    '${wishlistCtrl.productList.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  child: Image.asset(assetName, height: 24),
                ),
              );
            } else {
              return Image.asset(assetName, height: 24);
            }
          }),
        );
      }),
    );
  }
}
