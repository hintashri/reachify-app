import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:reachify_app/configuration/user_config.dart';
import 'package:reachify_app/modules/home/home_screen.dart';
import 'package:reachify_app/modules/home/init_home_ctrl.dart';
import 'package:reachify_app/routes/app_routes.dart';
import 'package:reachify_app/utils/const/asset_const.dart';
import 'package:reachify_app/utils/const/logger.dart';
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
    return PopScope(
      canPop: false, // Always handle pop manually
      onPopInvokedWithResult: (didPop, result) {
        logger.d('Current tab: ${c.activeTab()}, didPop: $didPop');

        // Check if drawer is open first
        if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
          // Close the drawer instead of exiting app
          Navigator.of(context).pop();
          return;
        }

        if (c.activeTab() == 0) {
          // On home page - allow app to close
          SystemNavigator.pop();
          return;
        } else {
          // On any other page (including search page at index 2) - go back to home
          c.activeTab(0);
          return;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        drawer: CustomDrawer(scaffoldKey: _scaffoldKey),
        body: NotificationListener(
          onNotification: c.handleScrollNotification,
          child: Stack(
            children: [
              // Main content - takes full height
              Positioned.fill(
                child: Obx(
                  () => Padding(
                    padding: EdgeInsets.only(
                      // Dynamically adjust bottom padding based on navbar visibility
                      bottom: c.isNavBarVisible.value
                          ? (context.mediaQueryViewPadding.bottom)
                          : 0,
                    ),
                    child: HomeScreen(),
                  ),
                ),
              ),
              // Floating Bottom Navigation Bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SlideTransition(
                  position: c.offsetAnimation,
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 8,
                      bottom: 4 + context.mediaQueryViewPadding.bottom,
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
                            c.activeTab(0);
                            if (user.userVerified) {
                              Get.toNamed(AppRoutes.wishlist);
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
                            c.activeTab(0);
                            await AppFunc.appPopUp(
                              title: 'Stay Updated on Every Platform',
                              desc: 'don\'t miss any important update.',
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
                            c.activeTab(0);
                            _scaffoldKey.currentState?.openDrawer();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
