import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachify_app/configuration/user_config.dart';
import 'package:reachify_app/modules/home/home_screen.dart';
import 'package:reachify_app/modules/home/init_home_ctrl.dart';
import 'package:reachify_app/modules/products/wishlist_screen.dart';
import 'package:reachify_app/routes/app_routes.dart';
import 'package:reachify_app/utils/const/asset_const.dart';
import 'package:reachify_app/utils/functions/app_func.dart';
import 'package:reachify_app/utils/functions/register_dialog.dart';
import 'package:reachify_app/utils/widgets/buttons/nav_bar_button.dart';
import 'package:reachify_app/utils/widgets/custom_drawer.dart';

class InitHomeScreen extends StatelessWidget {
  InitHomeScreen({super.key});

  final c = Get.put(InitHomeCtrl());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         AppFunc.deletePopUp(isLogout: true);
      //       },
      //       icon: const Icon(Icons.logout),
      //     ),
      //   ],
      // ),
      drawer: CustomDrawer(scaffoldKey: _scaffoldKey),
      body: NotificationListener(
        onNotification: c.handleScrollNotification,
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (c.activeTab() == 1) {
                  return WishlistScreen();
                } else {
                  return HomeScreen();
                }
              }),
            ),
            SlideTransition(
              position: c.offsetAnimation,
              child: Container(
                // height: 80,
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10 + context.mediaQueryViewPadding.bottom,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    NavBarButton(
                      assetName: AssetConst.home,
                      index: 0,
                      onTap: () {
                        c.activeTab(0);
                      },
                    ),
                    NavBarButton(
                      assetName: AssetConst.like,
                      index: 1,
                      onTap: () {
                        if (user.userVerified) {
                          Get.toNamed(AppRoutes.wishlist);
                          // c.activeTab(1);
                        } else {
                          registerDialogue();
                        }
                      },
                    ),
                    NavBarButton(
                      assetName: AssetConst.search,
                      index: 2,
                      onTap: () {
                        if (user.userVerified) {
                          c.activeTab(2);
                        } else {
                          registerDialogue();
                        }
                      },
                    ),
                    NavBarButton(
                      assetName: AssetConst.menu,
                      index: 3,
                      onTap: () async {
                        await AppFunc.appPopUp(
                          title: 'Stay Updated on Every Platform',
                          desc: 'don’t miss any important update.',
                          buttonName: 'Close',
                          child: const SocialMediaWidget(),
                          buttonTap: Get.back,
                        );
                      },
                    ),
                    NavBarButton(
                      assetName: AssetConst.user,
                      index: 4,
                      onTap: () {
                        _scaffoldKey.currentState?.openDrawer();
                        // Get.toNamed(AppRoutes.createAcc);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
