import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachify_app/modules/products/wishlist_ctrl.dart';
import 'package:reachify_app/utils/widgets/buttons/app_back_button.dart';
import 'package:reachify_app/utils/widgets/empty_view.dart';
import 'package:reachify_app/utils/widgets/product_card.dart';

import '../../utils/widgets/loading_view.dart';

class WishlistScreen extends StatelessWidget {
  WishlistScreen({super.key});

  final WishlistCtrl c = Get.find<WishlistCtrl>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const AppBackButton(),
        title: Text('Wishlist', style: context.textTheme.labelLarge),
      ),
      body: Obx(() {
        if (c.initLoading()) {
          return const LoaderView();
        } else {
          if (c.productList.isEmpty) {
            return const EmptyView();
          }
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 items in a row
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: c.productList.length,
            itemBuilder: (context, index) {
              return ProductCard(index: index, list: c.productList);
            },
          );
        }
      }),
    );
  }
}
