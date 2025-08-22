import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachify_app/configuration/user_config.dart';
import 'package:reachify_app/modules/home/init_home_ctrl.dart';
import 'package:reachify_app/modules/home/home_screen.dart';
import 'package:reachify_app/theme/app_colors.dart';
import 'package:reachify_app/utils/const/asset_const.dart';
import 'package:reachify_app/utils/functions/app_func.dart';
import 'package:reachify_app/utils/widgets/buttons/nav_bar_button.dart';

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
        child: Stack(
          children: [
            HomeScreen(),
            Positioned(
              bottom: 0,
              width: context.width,
              child: SlideTransition(
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
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomDrawer({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // Drawer Header
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: Row(
              children: [
                const SizedBox(width: 16),
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(AssetConst.appLogo),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Hi, ${user.appUser.businessName.isNotEmpty ? user.appUser.businessName : user.appUser.name}',
                    style: context.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Drawer Items
          Expanded(
            child: Column(
              children: [
                drawerTile(
                  context: context,
                  assetIcon: AssetConst.home,
                  title: 'Home',
                  onTap: () {
                    scaffoldKey.currentState?.closeDrawer();
                  },
                ),
                drawerTile(
                  context: context,
                  assetIcon: AssetConst.promote,
                  title: 'Promote Your Brand',
                  onTap: () {},
                ),
                drawerTile(
                  context: context,
                  assetIcon: AssetConst.profile,
                  title: 'Edit Profile',
                  onTap: () {},
                ),
                drawerTile(
                  context: context,
                  assetIcon: AssetConst.menu,
                  title: 'Social Media',
                  onTap: () {},
                ),
                drawerTile(
                  context: context,
                  assetIcon: AssetConst.notification,
                  title: 'Notification Settings',
                  onTap: () {},
                ),
                drawerTile(
                  context: context,
                  assetIcon: AssetConst.aboutUs,
                  title: 'About Us',
                  onTap: () {},
                ),
                drawerTile(
                  context: context,
                  assetIcon: AssetConst.contactUs,
                  title: 'Contact Us',
                  onTap: () {},
                ),
                drawerTile(
                  context: context,
                  assetIcon: AssetConst.dltAcc,
                  title: 'Delete Account',
                  onTap: () async {
                    await AppFunc.deletePopUp(
                      onTap: () {
                        Get.back();
                      },
                    );
                  },
                ),
                drawerTile(
                  context: context,
                  assetIcon: AssetConst.logout,
                  title: 'Log Out',
                  onTap: () async {
                    await AppFunc.deletePopUp(isLogout: true);
                  },
                ),
              ],
            ),
          ),

          // Footer
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Reachify 2.1',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget drawerTile({
    required BuildContext context,
    required String assetIcon,
    required String title,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Image.asset(assetIcon, height: 22, color: Colors.black87),
      title: Text(
        title,
        style: context.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
        color: AppColors.textDark,
      ),
      onTap: onTap,
    );
  }
}
