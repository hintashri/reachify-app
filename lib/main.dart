import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachify_app/routes/app_pages.dart';
import 'package:reachify_app/routes/app_routes.dart';
import 'package:reachify_app/theme/app_theme.dart';

import 'configuration/init_config.dart';

Future<void> main() async {
  await init.initCall();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reachify App',
      enableLog: true,
      scrollBehavior: const ScrollBehavior().copyWith(
        physics: const BouncingScrollPhysics(),
      ),
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      getPages: AppPages.pages,
      initialRoute: AppRoutes.splash,
    );
  }
}
