import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:photo_view/photo_view.dart';
import 'package:reachify_app/models/product_model.dart';
import 'package:reachify_app/modules/home/home_ctrl.dart';
import 'package:reachify_app/modules/products/wishlist_ctrl.dart';
import 'package:reachify_app/theme/app_colors.dart';
import 'package:reachify_app/utils/const/asset_const.dart';
import 'package:reachify_app/utils/const/enums.dart';
import 'package:reachify_app/utils/const/logger.dart';
import 'package:reachify_app/utils/const/url_const.dart';
import 'package:reachify_app/utils/functions/app_func.dart';
import 'package:reachify_app/utils/functions/url_luncher.dart';
import 'package:reachify_app/utils/widgets/buttons/app_back_button.dart';
import 'package:reachify_app/utils/widgets/cache_image.dart';
import 'package:reachify_app/utils/widgets/svg_image.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ProductDetailScreen extends StatelessWidget {
  ProductDetailScreen({super.key});

  final int index = Get.arguments['index'];
  final List<ProductModel> list = Get.arguments['list'];

  @override
  Widget build(BuildContext context) {
    logger.d(list[index].toJson());
    return Scaffold(
      appBar: AppBar(leading: const AppBackButton()),
      body: ScrollablePositionedList.builder(
        initialScrollIndex: index,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return ProductDetailCard(model: list[index]);
        },
      ),
      // ListView(
      //   children: const [
      //     ProductDetailCard(
      //       imageUrl:
      //           'https://images.pexels.com/photos/326055/pexels-photo-326055.jpeg?_gl=1*3h4c5x*_ga*Mjg5MjczNDk4LjE3NTYzNTA2ODA.*_ga_8JE65Q40S6*czE3NTYzNTA2NzkkbzEkZzEkdDE3NTYzNTA3MTYkajIzJGwwJGgw',
      //       shopName: 'Balaji Hardware',
      //       city: 'Rajkot',
      //       ownerName: 'Mr. Chiragbhai Patel',
      //     ),
      //     ProductDetailCard(
      //       imageUrl:
      //           'https://images.pexels.com/photos/326055/pexels-photo-326055.jpeg?_gl=1*3h4c5x*_ga*Mjg5MjczNDk4LjE3NTYzNTA2ODA.*_ga_8JE65Q40S6*czE3NTYzNTA2NzkkbzEkZzEkdDE3NTYzNTA3MTYkajIzJGwwJGgw',
      //       shopName: 'Rajan Polyplast',
      //       city: 'Rajkot',
      //       ownerName: 'Mr. Chiragbhai Patel',
      //     ),
      //   ],
      // ),
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
              child: GestureDetector(
                onTap: () {
                  Get.to(
                    () => ProductImageDetailPage(imageUrl: imageUrl),
                    transition: Transition.noTransition,
                  );
                },
                child: Hero(
                  tag: imageUrl,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CacheImage(
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

class ProductImageDetailPage extends StatefulWidget {
  final String imageUrl;

  const ProductImageDetailPage({super.key, required this.imageUrl});

  @override
  State<ProductImageDetailPage> createState() => _ProductImageDetailPageState();
}

class _ProductImageDetailPageState extends State<ProductImageDetailPage> {
  final PhotoViewController _photoController = PhotoViewController();
  bool _showPhotoView = true; // we will toggle this before popping

  Future<void> _handleBack(BuildContext context) async {
    if (_photoController.scale != 1.0) {
      // ✅ Hide PhotoView first so Hero sees it in its original state
      setState(() => _showPhotoView = false);

      // wait one frame so widget tree updates before pop
      await Future.delayed(const Duration(milliseconds: 16));
    }

    Get.back(); // now hero animates from contained state
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: AppBackButton(onPressed: () => _handleBack(context)),
      ),
      body: Center(
        child: Hero(
          tag: widget.imageUrl,
          child: _showPhotoView
              ? PhotoView(
                  controller: _photoController,
                  imageProvider: CachedNetworkImageProvider(widget.imageUrl),
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 3.0,
                  initialScale: PhotoViewComputedScale.contained,
                  enableRotation: false,
                )
              : Image(
                  image: CachedNetworkImageProvider(widget.imageUrl),
                  fit: BoxFit.contain,
                ),
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
