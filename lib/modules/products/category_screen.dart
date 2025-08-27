import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachify_app/modules/products/category_ctrl.dart';
import 'package:reachify_app/theme/app_colors.dart';
import 'package:reachify_app/utils/const/logger.dart';
import 'package:reachify_app/utils/const/url_const.dart';
import 'package:reachify_app/utils/widgets/buttons/app_back_button.dart';
import 'package:reachify_app/utils/widgets/cache_image.dart';
import 'package:reachify_app/utils/widgets/loading_view.dart';
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
