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

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reachify App',
      enableLog: true,
      scrollBehavior: const ScrollBehavior().copyWith(
        // physics: const BouncingScrollPhysics(),
      ),
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      getPages: AppPages.pages,
      initialRoute: AppRoutes.splash,
      // home: _Content(),
    );
  }
}

// class _Content extends StatefulWidget {
//   const _Content({Key? key}) : super(key: key);
//
//   @override
//   __ContentState createState() => __ContentState();
// }
//
// class __ContentState extends State<_Content> {
//   final contents = List.generate(9, (index) => index + 1)..shuffle();
//
//   String _convertContent(int number) =>
//       List.generate(number, (_) => '$number').join('');
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: InfiniteScrollTabView(
//           contentLength: contents.length,
//           onTabTap: (index) {
//             debugPrint('tapped $index');
//           },
//           tabBuilder: (index, isSelected) => Text(
//             _convertContent(contents[index]),
//             style: TextStyle(
//               color: isSelected ? Colors.pink : Colors.black54,
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//             ),
//           ),
//           separator: const BorderSide(color: Colors.black12, width: 2.0),
//           onPageChanged: (index) => debugPrint('page changed to $index.'),
//           indicatorColor: Colors.pink,
//           pageBuilder: (context, index, _) {
//             return SizedBox.expand(
//               child: DecoratedBox(
//                 decoration: BoxDecoration(
//                   color: Colors.green.withOpacity(contents[index] / 10),
//                 ),
//                 child: Center(
//                   child: Text(
//                     _convertContent(contents[index]),
//                     style: Theme.of(context).textTheme.headlineLarge!.copyWith(
//                       color: contents[index] / 10 > 0.6
//                           ? Colors.white
//                           : Colors.black87,
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
