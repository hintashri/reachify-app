import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:reachify_app/configuration/notification_config.dart';
import 'package:reachify_app/configuration/user_config.dart';
import 'package:reachify_app/routes/app_routes.dart';
import 'package:reachify_app/theme/app_colors.dart';
import 'package:reachify_app/utils/const/asset_const.dart';
import 'package:reachify_app/utils/const/enums.dart';
import 'package:reachify_app/utils/const/key_const.dart';
import 'package:reachify_app/utils/functions/app_func.dart';
import 'package:reachify_app/utils/functions/register_dialog.dart';
import 'package:reachify_app/utils/functions/url_luncher.dart';
import 'package:reachify_app/utils/widgets/web_view_screen.dart';

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
                    'Hi, ${user.appUser().businessName.isNotEmpty ? user.appUser().businessName : user.appUser().name}',
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
                      Get.back();
                      Get.to(
                        () => const WebViewScreen(
                          url: KeyConst.promoteYourBrand,
                          title: 'Promote Your Brand',
                        ),
                      );

                      // Get.toNamed(
                      //   AppRoutes.promoteBrand,
                      //   arguments: 'Promote Your Brand',
                      // );
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
                    onTap: () async {
                      if (user.userVerified) {
                        await AppFunc.appPopUp(
                          title: 'Stay Updated on Every Platform',
                          desc: 'don’t miss any important update.',
                          buttonName: 'Close',
                          child: const SocialMediaWidget(),
                          buttonTap: Get.back,
                        );
                      } else {
                        registerDialogue();
                      }
                    },
                  ),
                  drawerTile(
                    context: context,
                    assetIcon: AssetConst.notification,
                    title: 'Notification Settings',
                    onTap: () {
                      if (user.userVerified) {
                      } else {
                        registerDialogue();
                      }
                    },
                  ),
                  drawerTile(
                    context: context,
                    assetIcon: AssetConst.aboutUs,
                    title: 'About Us',
                    onTap: () {
                      urlLaunch(LaunchType.website, value: KeyConst.aboutUs);
                    },
                  ),
                  drawerTile(
                    context: context,
                    assetIcon: AssetConst.contactUs,
                    title: 'Contact Us',
                    onTap: () {
                      Get.back();
                      Get.to(
                        () => const WebViewScreen(
                          url: KeyConst.contactUs,
                          title: 'Contact Us',
                        ),
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

          FutureBuilder(
            future: NotificationServices.getToken(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return Row(
                  children: [
                    Expanded(child: SelectableText('${snapshot.data}')),
                    IconButton(
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: snapshot.data ?? ''),
                        );
                      },
                      icon: const Icon(Icons.copy),
                    ),
                  ],
                );
              } else {
                return const SizedBox();
              }
            },
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

class SocialMediaWidget extends StatelessWidget {
  const SocialMediaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 25),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShareIcon(
              image: AssetConst.whatsappIc,
              name: 'WhatsApp Community',
              url: KeyConst.whatsappCommunity,
            ),
            ShareIcon(
              image: AssetConst.whatsappIc,
              name: 'WhatsApp Channel',
              url: KeyConst.whatsappChannel,
            ),
            ShareIcon(
              image: AssetConst.instaIc,
              name: 'Instagram',
              url: KeyConst.instagram,
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShareIcon(
              image: AssetConst.facebookIc,
              name: 'Facebook',
              url: KeyConst.facebook,
            ),
            ShareIcon(
              image: AssetConst.pinterestIc,
              name: 'Pinterest',
              url: KeyConst.pinterest,
            ),
            ShareIcon(
              image: AssetConst.linkedinIc,
              name: 'linkedin',
              url: KeyConst.linkedin,
            ),
          ],
        ),
        // SizedBox(height: 10),
      ],
    );
  }
}

class ShareIcon extends StatelessWidget {
  final String image;
  final String name;
  final String url;

  const ShareIcon({
    super.key,
    required this.image,
    required this.name,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: GestureDetector(
          onTap: () => urlLaunch(LaunchType.website, value: url),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(image, height: 40, width: 40),
              const SizedBox(height: 10),
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
