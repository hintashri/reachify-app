import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachify_app/configuration/user_config.dart';
import 'package:reachify_app/routes/app_routes.dart';
import 'package:reachify_app/theme/app_colors.dart';
import 'package:reachify_app/utils/const/asset_const.dart';
import 'package:reachify_app/utils/functions/app_func.dart';

class CustomDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomDrawer({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 2,
      backgroundColor: Colors.white,
      shape: const OutlineInputBorder(borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          // Drawer Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 55, 16, 20),
            child: Row(
              children: [
                const SizedBox(width: 16),
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.black26,
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage(AssetConst.appLogo),
                  ),
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
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
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.promoteBrand,
                        arguments: 'Promote Your Brand',
                      );
                    },
                  ),
                  drawerTile(
                    context: context,
                    assetIcon: AssetConst.profile,
                    title: 'Edit Profile',
                    onTap: () {
                      Get.toNamed(AppRoutes.createAcc);
                    },
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
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.promoteBrand,
                        arguments: 'Contact Us',
                      );
                    },
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
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Text(
              'Reachify 2.1',
              style: context.textTheme.labelSmall?.copyWith(
                fontSize: 12,
                color: Colors.grey,
              ),
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
