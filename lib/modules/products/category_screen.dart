import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachify_app/modules/products/category_ctrl.dart';
import 'package:reachify_app/theme/app_colors.dart';
import 'package:reachify_app/utils/widgets/buttons/app_back_button.dart';
import 'package:reachify_app/utils/widgets/loading_view.dart';
import 'package:reachify_app/utils/widgets/product_card.dart';

import '../../models/category_model.dart';
import '../../utils/widgets/empty_view.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabCtrl;
  PageController? pageController;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    initCall();
  }

  Future<void> initCall() async {
    final int id = Get.arguments;
    await c.getCategories();

    final index = c.categoryList.indexWhere((e) => e.id == id);

    tabCtrl = TabController(
      length: c.categoryList.length,
      vsync: this,
      initialIndex: index,
    );

    pageController = PageController(initialPage: index);

    final CategoryModel firstId = c.categoryList.firstWhere((e) => e.id == id);
    c.getProducts(categoryId: firstId.id);

    setState(() {
      isInitialized = true;
    });

    c.initLoading(false);
  }

  @override
  void dispose() {
    tabCtrl?.dispose();
    pageController?.dispose();
    super.dispose();
  }

  final CategoryCtrl c = Get.put(CategoryCtrl());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (c.initLoading() || !isInitialized) {
          return const LoaderView();
        } else {
          return SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  // Floating App Bar
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    pinned: false,
                    leading: const AppBackButton(),
                    centerTitle: true,
                    title: Text(
                      c.categoryName,
                      style: context.textTheme.labelLarge,
                    ),
                    elevation: 0,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  // Sticky Tab Bar
                  SliverPersistentHeader(
                    floating: true,
                    pinned: true,
                    delegate: _SliverTabBarDelegate(
                      tabBar: TabBar(
                        controller: tabCtrl!,
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
                        labelPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        labelStyle: context.textTheme.labelSmall?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        isScrollable: true,
                        tabAlignment: TabAlignment.center,
                        onTap: (index) {
                          // Handle tap events - animate to page and load data
                          pageController!.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                          c.proLoading(true);
                          final int id = c.categoryList.elementAt(index).id;
                          c.getProducts(categoryId: id);
                        },
                        tabs: c.categoryList
                            .map((e) => Tab(text: e.name))
                            .toList(),
                      ),
                    ),
                  ),
                ];
              },
              body: PageView.builder(
                controller: pageController!,
                itemCount: c.categoryList.length,
                onPageChanged: (index) {
                  tabCtrl!.animateTo(index);
                  c.proLoading(true);
                  final int id = c.categoryList.elementAt(index).id;
                  c.getProducts(categoryId: id);
                },
                itemBuilder: (context, index) {
                  return ProductGrid();
                },
              ),
            ),
          );
        }
      }),
    );
  }
}

// Custom delegate for sticky TabBar
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _SliverTabBarDelegate({required this.tabBar});

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
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
            return ProductCard(index: index, list: c.productList);
          },
        );
      }
    });
  }
}
