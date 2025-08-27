import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachify_app/modules/products/category_ctrl.dart';
import 'package:reachify_app/theme/app_colors.dart';
import 'package:reachify_app/utils/const/logger.dart';
import 'package:reachify_app/utils/const/url_const.dart';
import 'package:reachify_app/utils/widgets/buttons/app_back_button.dart';
import 'package:reachify_app/utils/widgets/cache_image.dart';
import 'package:reachify_app/utils/widgets/loading_view.dart';

import '../../configuration/init_config.dart';
import '../../configuration/user_config.dart';
import '../../utils/widgets/empty_view.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabCtrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initCall();
  }

  Future<void> initCall() async {
    await c.getCategories();
    c.initLoading(false);
    tabCtrl = TabController(length: c.categoryList.length, vsync: this);
    final int firstId = c.categoryList.first.id;
    c.getProducts(categoryId: firstId);
    tabCtrl.addListener(() {
      logger.d('Called IT Finally');
      final int id = c.categoryList.elementAt(tabCtrl.index).id;
      c.getProducts(categoryId: id);
    });
  }

  @override
  void dispose() {
    tabCtrl.dispose();
    super.dispose();
  }

  final CategoryCtrl c = Get.put(CategoryCtrl());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        centerTitle: true,
        title: Text(c.categoryName, style: context.textTheme.labelLarge),
      ),
      body: Obx(() {
        if (c.initLoading()) {
          return const LoaderView();
        } else {
          return DefaultTabController(
            length: c.categoryList.length,
            child: Column(
              children: [
                TabBar(
                  controller: tabCtrl,
                  physics: const BouncingScrollPhysics(),
                  dividerHeight: 0,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 0.0,
                  splashBorderRadius: BorderRadius.circular(5),
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black54,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 15),
                  labelStyle: context.textTheme.labelSmall?.copyWith(
                    fontSize: 12,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  isScrollable: true,
                  tabAlignment: TabAlignment.center,
                  tabs: c.categoryList.map((e) => Tab(text: e.name)).toList(),
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabCtrl,
                    children: c.categoryList.map((e) => ProductGrid()).toList(),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}

class ProductGrid extends StatelessWidget {
  ProductGrid({super.key});

  final CategoryCtrl c = Get.find<CategoryCtrl>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (c.proLoading()) {
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
            final item = c.productList[index];
            return ProductCard(imageUrl: item.images.first);
          },
        );
      }
    });
  }
}

class ProductCard extends StatelessWidget {
  final String imageUrl;

  const ProductCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CacheImage(
          url: '${UrlConst.baseUrl}/storage/app/public/product/$imageUrl',
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }
}

class ProductDetailCard extends StatelessWidget {
  final String imageUrl;
  final String shopName;
  final String city;
  final String ownerName;

  const ProductDetailCard({
    super.key,
    required this.imageUrl,
    required this.shopName,
    required this.city,
    required this.ownerName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Banner image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.network(
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Shop title
                Text(
                  '$shopName - $city',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                /// Owner name
                Text(
                  ownerName,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),

                const SizedBox(height: 12),

                /// Action buttons row
                Row(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      label: const Text('WhatsApp'),
                      icon: const Icon(Icons.message, size: 16),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.phone, color: Colors.black54),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.share, color: Colors.black54),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Category')),
      body: ListView(
        children: const [
          ProductDetailCard(
            imageUrl: 'https://via.placeholder.com/400x200.png',
            shopName: 'Balaji Hardware',
            city: 'Rajkot',
            ownerName: 'Mr. Chiragbhai Patel',
          ),
          ProductDetailCard(
            imageUrl: 'https://via.placeholder.com/400x200.png',
            shopName: 'Rajan Polyplast',
            city: 'Rajkot',
            ownerName: 'Mr. Chiragbhai Patel',
          ),
        ],
      ),
    );
  }
}
