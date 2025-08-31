import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachify_app/modules/home/home_ctrl.dart';
import 'package:reachify_app/utils/const/url_const.dart';
import 'package:reachify_app/utils/widgets/cache_image.dart';

import '../../routes/app_routes.dart';

class SearchListScreen extends StatelessWidget {
  final HomeCtrl c = Get.find<HomeCtrl>();

  SearchListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Item')),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                'Found ${c.searchList.length} results for "${c.searchParam.value}"',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: c.searchList.length,
                itemBuilder: (context, index) {
                  final model = c.searchList[index];
                  return InkWell(
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.productDetail,
                        arguments: {'index': index, 'list': c.searchList},
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: ClipRRect(
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(12),
                      child: CacheImage(
                        url:
                            '${UrlConst.baseUrl}/storage/app/public/product/${model.images.first}',
                        height: 120,
                        width: 120,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
