import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:reachify_app/configuration/network_config.dart';
import 'package:reachify_app/models/product_model.dart';
import 'package:reachify_app/modules/home/home_ctrl.dart';
import 'package:reachify_app/modules/products/wishlist_ctrl.dart';
import 'package:reachify_app/theme/app_colors.dart';
import 'package:reachify_app/utils/const/asset_const.dart';
import 'package:reachify_app/utils/const/enums.dart';
import 'package:reachify_app/utils/const/url_const.dart';
import 'package:reachify_app/utils/functions/app_func.dart';
import 'package:reachify_app/utils/functions/url_luncher.dart';
import 'package:reachify_app/utils/widgets/buttons/app_back_button.dart';
import 'package:reachify_app/utils/widgets/cache_image.dart';
import 'package:reachify_app/utils/widgets/svg_image.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../utils/const/logger.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int index = 0;
  RxList<ProductModel> list = <ProductModel>[].obs;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  bool _isAppBarVisible = true;
  double _lastScrollPosition = 0.0;
  bool _isInitialScroll = true;

  @override
  void initState() {
    super.initState();
    getData();
    // Listen to scroll position changes
  }

  Future<void> getData() async {
    index = Get.arguments['index'];
    list.value = Get.arguments['list'];
    logger.d(Get.arguments);
    itemPositionsListener.itemPositions.addListener(_onScrollChanged);
    final catId = Get.arguments['category'];
    if (catId != null && catId is int && catId != 0) {
      await getProducts(categoryId: catId);
    }
  }

  Future<void> getProducts({
    required int categoryId,
    bool showLoader = true,
  }) async {
    try {
      final response = await net.post(
        url: UrlConst.getProducts,
        params: {'id': categoryId},
      );
      if (net.successfulRes(response: response)) {
        final List<dynamic> data = response.data;
        final List<ProductModel> elements = data
            .map((json) => ProductModel.fromJson(json))
            .toList();
        final existingIds = list.map((e) => e.id).toSet();

        final newItems = elements.where((e) => !existingIds.contains(e.id));
        logger.d('New List Count :${newItems.length}');
        list.addAll(newItems);
        list.refresh();
      } else {
        logger.e(response);
      }
    } catch (e, t) {
      logger.e('$e\n$t');
    }
  }

  void _onScrollChanged() {
    if (itemPositionsListener.itemPositions.value.isNotEmpty) {
      // Skip initial scroll to target index
      if (_isInitialScroll) {
        _isInitialScroll = false;
        return;
      }

      // Get the first visible item's position
      final positions = itemPositionsListener.itemPositions.value.toList();
      if (positions.isEmpty) return;

      // Calculate a more accurate scroll position using multiple visible items
      double currentScrollPosition = 0;
      for (final position in positions) {
        currentScrollPosition += position.index - position.itemLeadingEdge;
      }
      currentScrollPosition = currentScrollPosition / positions.length;

      // Add threshold to avoid too sensitive changes
      const double threshold = 0.1;

      // Determine scroll direction with threshold
      if (currentScrollPosition > _lastScrollPosition + threshold) {
        // Scrolling down - hide app bar
        if (_isAppBarVisible) {
          setState(() {
            _isAppBarVisible = false;
          });
        }
      } else if (currentScrollPosition < _lastScrollPosition - threshold) {
        // Scrolling up - show app bar
        if (!_isAppBarVisible) {
          setState(() {
            _isAppBarVisible = true;
          });
        }
      }

      _lastScrollPosition = currentScrollPosition;
    }
  }

  @override
  void dispose() {
    itemPositionsListener.itemPositions.removeListener(_onScrollChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Obx(() {
              return ScrollablePositionedList.builder(
                initialScrollIndex: index,
                itemCount: list.length,
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
                padding: EdgeInsets.only(
                  top: _isAppBarVisible ? kToolbarHeight : 0,
                ),
                itemBuilder: (context, index) {
                  return ProductDetailCard(model: list[index]);
                },
              );
            }),
            // Floating App Bar
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              top: _isAppBarVisible ? 0 : -kToolbarHeight,
              left: 0,
              right: 0,
              child: Container(
                height: kToolbarHeight,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 0.5,
                    ),
                  ),
                ),
                child: AppBar(
                  leading: const AppBackButton(),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailCard extends StatelessWidget {
  final ProductModel model;

  const ProductDetailCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        '${UrlConst.baseUrl}/storage/app/public/product/${model.images.first}';
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.zero,
              child: Hero(
                tag: imageUrl,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: PinchZoom(
                    maxScale: 2.5,
                    child: CacheImage(
                      aspectRatio: 1,
                      url:
                          '${UrlConst.baseUrl}/storage/app/public/product/${model.images.first}',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${model.seller.companyName} - ${model.seller.companyAddress}',
              style: context.textTheme.headlineSmall?.copyWith(fontSize: 15),
            ),

            const SizedBox(height: 4),

            /// Owner name
            Text(
              // ownerName,
              model.seller.fName,

              style: context.textTheme.labelSmall?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.iconColor,
              ),
            ),

            const Divider(color: AppColors.iconColor, height: 20),

            /// Action buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WhatsappButton(
                  whatsapp: model.seller.whatsappLink,
                  id: model.id,
                  message: model.seller.brand,
                ),
                SocialButton(
                  type: LaunchType.call,
                  // asset: AssetConst.call,
                  data: model.seller.phoneNumber,
                  id: model.id,
                ),
                SocialButton(
                  data: model.seller.email,
                  type: LaunchType.mail,
                  id: model.id,
                ),
                SocialButton(
                  data: model.seller.website,
                  type: LaunchType.website,
                  id: model.id,
                ),
                CustomLikeButton(model: model),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  // final String asset;
  final String data;
  final LaunchType? type;
  final void Function()? onTap;
  final int id;

  final c = Get.find<HomeCtrl>();

  SocialButton({
    super.key,
    // required this.asset,
    this.data = '',
    this.onTap,
    this.type,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          onTap ??
          () async {
            if (data.isNotEmpty) {
              if (type != null) {
                await c.postInteraction(
                  productId: id,
                  interactionType: interactionType,
                );
                urlLaunch(type!, value: data);
              }
            } else {
              AppFunc.showSnackBar(message: 'No Data found');
            }
          },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.iconColor, width: 1),
        ),
        child: Center(child: SVGImage(assets, height: 20, width: 20)),
      ),
    );
  }

  String get assets {
    switch (type) {
      case LaunchType.call:
        return AssetConst.call;
      case LaunchType.whatsapp:
        return AssetConst.whatsapp;
      case LaunchType.website:
        return AssetConst.web;
      case LaunchType.mail:
        return AssetConst.mail;
      case null:
        return AssetConst.like;
    }
  }

  int get interactionType {
    switch (type) {
      case LaunchType.call:
        return 2;
      case LaunchType.whatsapp:
        return 1;
      case LaunchType.website:
        return 4;
      case LaunchType.mail:
        return 3;
      case null:
        return 0;
    }
  }
}

class CustomLikeButton extends StatelessWidget {
  final ProductModel model;

  final WishlistCtrl c = Get.find<WishlistCtrl>();

  CustomLikeButton({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isInWishlist = c.productList.any(
        (item) => item.id == model.id,
      );
      return Container(
        height: 35,
        width: 35,
        // padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.iconColor, width: 1),
        ),
        child: LikeButton(
          size: 20,
          likeCountPadding: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          isLiked: isInWishlist,
          // adjust size
          likeBuilder: (bool isLiked) {
            return isLiked
                ? const Center(
                    child: SVGImage(AssetConst.likeFill, height: 20, width: 20),
                  )
                : const Center(
                    child: SVGImage(
                      AssetConst.like,
                      height: 20,
                      width: 20,
                      color: Color.fromRGBO(109, 111, 126, 1.0),
                    ),
                  );
          },
          // optional animation circle & bubbles customization
          circleColor: const CircleColor(
            start: Color(0xff00ddff),
            end: Color(0xff0099cc),
          ),
          bubblesColor: const BubblesColor(
            dotPrimaryColor: Colors.red,
            dotSecondaryColor: Colors.pink,
          ),
          onTap: (isLiked) async {
            if (isLiked) {
              await c.removeFromWishlist(model.id);
            } else {
              await c.addToWishlist(model.id);
            }
            return !isLiked;
          },
        ),
      );
    });
  }
}

class WhatsappButton extends StatelessWidget {
  final String whatsapp;
  final String message;
  final int id;

  final c = Get.find<HomeCtrl>();

  WhatsappButton({
    super.key,
    required this.whatsapp,
    required this.id,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.green,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          await c.postInteraction(productId: id, interactionType: 1);
          urlLaunch(LaunchType.whatsapp, value: whatsapp, message: message);
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // color: Colors.green,
          ),
          child: Row(
            children: [
              const SVGImage(
                AssetConst.whatsapp,
                height: 20,
                width: 20,
                color: Colors.white,
              ),
              // const SizedBox(width: 3),
              Text(
                'WhatsApp',
                style: context.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
