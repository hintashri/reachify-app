import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachify_app/modules/home/init_home_ctrl.dart';
import 'package:reachify_app/modules/home/home_screen.dart';
import 'package:reachify_app/routes/app_routes.dart';
import 'package:reachify_app/utils/const/asset_const.dart';
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
            Expanded(child: HomeScreen()),
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
                    const NavBarButton(assetName: AssetConst.home, index: 0),
                    NavBarButton(
                      assetName: AssetConst.like,
                      index: 1,
                      onTap: () {},
                    ),
                    NavBarButton(
                      assetName: AssetConst.search,
                      index: 2,
                      onTap: () {},
                    ),
                    NavBarButton(
                      assetName: AssetConst.menu,
                      index: 3,
                      onTap: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                    NavBarButton(
                      assetName: AssetConst.user,
                      index: 4,
                      onTap: () {
                        Get.toNamed(AppRoutes.createAcc);
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
