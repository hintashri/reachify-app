import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachify_app/configuration/user_config.dart';
import 'package:reachify_app/models/product_model.dart';
import 'package:reachify_app/modules/home/home_ctrl.dart';
import 'package:reachify_app/routes/app_routes.dart';
import 'package:reachify_app/theme/app_colors.dart';
import 'package:reachify_app/theme/app_theme.dart';
import 'package:reachify_app/utils/const/url_const.dart';
import 'package:reachify_app/utils/functions/register_dialog.dart';
import 'package:reachify_app/utils/widgets/auth_textfield.dart';
import 'package:reachify_app/utils/widgets/cache_image.dart';
import 'package:reachify_app/utils/widgets/empty_view.dart';
import 'package:reachify_app/utils/widgets/loading_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatelessWidget {
  final HomeCtrl c = Get.put(HomeCtrl());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (c.gettingBanner()) {
        return const LoaderView();
      } else {
        return SingleChildScrollView(
          child: Column(
            children: [
              Obx(() {
                return SafeArea(
                  bottom: false,
                  child: Visibility(
                    visible: c.initHomeCtrl.activeTab() == 2,
                    child: SlideTransition(
                      position: c.searchOffset,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AuthTextField(
                          controller: c.searchCTRL,
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Search products',
                          textInputType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (p0) {
                            c.searchParam(p0);
                            c.search();
                          },
                          suffixIcon: IconButton(
                            onPressed: c.search,
                            icon: c.isSearching.isTrue
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 0.7,
                                    ),
                                  )
                                : const Icon(Icons.send),
                          ),
                          onChange: (newValue) {
                            c.searchParam(newValue);
                          },
                        ),
                      ),
                    ),
                  ),
                );
              }),
              Obx(() {
                if (c.isLoading.isFalse) {
                  if (c.bannerList.isNotEmpty || c.homeList.isNotEmpty) {
                    return Column(
                      children: [
                        Obx(() {
                          if (c.bannerList.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: CarouselSlider.builder(
                                carouselController: c.controller,
                                itemCount: c.bannerList.length,
                                itemBuilder: (context, index, realIndex) {
                                  return CacheImage(
                                    url:
                                        '${UrlConst.baseUrl}/storage/app/public/banner/${c.bannerList[index].photo}',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  );
                                },
                                options: CarouselOptions(
                                  height: 200,
                                  autoPlay: true,
                                  viewportFraction: 1,
                                  enlargeCenterPage: false,
                                  onPageChanged: (index, reason) =>
                                      c.activeIndex(index),
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),
                        Obx(() {
                          if (c.bannerList.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: AnimatedSmoothIndicator(
                                activeIndex: c.activeIndex(),
                                count: c.bannerList.length,
                                effect: const WormEffect(
                                  dotHeight: 8,
                                  dotWidth: 8,
                                  spacing: 6,
                                  dotColor: Color(0xFFe0e0e0),
                                  // inactive
                                  activeDotColor: AppColors.primary,
                                ),
                                onDotClicked: (index) =>
                                    c.controller.animateToPage(index),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),
                        // const SizedBox(height: 10),
                        Obx(() {
                          if (c.homeList.isNotEmpty) {
                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              itemCount: c.homeList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final model = c.homeList[index];
                                if (model.products.isNotEmpty) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomTitleRow(
                                        title: model.name,
                                        onPress: () {
                                          if (user.userVerified) {
                                            Get.toNamed(
                                              AppRoutes.categoryScreen,
                                              arguments: model.id,
                                            );
                                          } else {
                                            registerDialogue();
                                          }
                                        },
                                      ),
                                      CustomListView(
                                        products: model.products.length <= 10
                                            ? model.products
                                            : model.products.take(10).toList(),
                                      ),
                                    ],
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            );
                          } else {
                            return const Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: EmptyView(),
                            );
                          }
                        }),
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                } else {
                  return SizedBox(
                    height: context.height * 0.6,
                    child: const LoaderView(),
                  );
                }
              }),
            ],
          ),
        );
      }
    });
  }
}

class CustomListView extends StatelessWidget {
  final List<ProductModel> products;
  final HomeCtrl c = Get.find<HomeCtrl>();

  CustomListView({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        separatorBuilder: (context, index) {
          return const SizedBox(width: 12);
        },
        itemBuilder: (context, index) {
          final model = products[index];
          return InkWell(
            onTap: () {
              if (user.userVerified) {
                Get.toNamed(
                  AppRoutes.productDetail,
                  arguments: {'index': index, 'list': products},
                );
              } else {
                registerDialogue();
              }
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(12),
              ),
              margin: EdgeInsets.zero,
              elevation: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CacheImage(
                  url:
                      '${UrlConst.baseUrl}/storage/app/public/product/${model.images.first}',
                  imageBuilder: (p0, p1) {
                    return Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        image: DecorationImage(image: p1, fit: BoxFit.cover),
                      ),
                    );
                  },
                  height: 120,
                  width: 120,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomTitleRow extends StatelessWidget {
  final String title;
  final void Function()? onPress;

  const CustomTitleRow({super.key, required this.title, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textDark,
              ),
            ),
          ),
          TextButton(
            onPressed: onPress,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: ShaderMask(
              shaderCallback: (bounds) => AppTheme.gradient.createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
              child: Text(
                'See All',
                style: context.textTheme.bodySmall?.copyWith(
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.solid,
                  decorationColor: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
