import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:reachify_app/models/product_model.dart';
import 'package:reachify_app/modules/products/wishlist_ctrl.dart';
import 'package:reachify_app/theme/app_colors.dart';
import 'package:reachify_app/utils/const/asset_const.dart';
import 'package:reachify_app/utils/const/enums.dart';
import 'package:reachify_app/utils/const/logger.dart';
import 'package:reachify_app/utils/const/url_const.dart';
import 'package:reachify_app/utils/functions/url_luncher.dart';
import 'package:reachify_app/utils/widgets/buttons/app_back_button.dart';
import 'package:reachify_app/utils/widgets/cache_image.dart';
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
  // final String imageUrl;
  // final String shopName;
  // final String city;
  // final String ownerName;
  final ProductModel model;

  const ProductDetailCard({
    super.key,
    // required this.imageUrl,
    // required this.shopName,
    // required this.city,
    // required this.ownerName,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CacheImage(
                  url:
                      '${UrlConst.baseUrl}/storage/app/public/product/${model.images.first}',

                  // height: 180,
                  // width: double.infinity,
                  // fit: BoxFit.cover,
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
              '${model.seller.fName}',

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
                WhatsappButton(whatsapp: model.seller.whatsappLink),
                SocialButton(
                  type: LaunchType.call,
                  // asset: AssetConst.call,
                  data: model.seller.phoneNumber,
                ),
                SocialButton(data: model.seller.email, type: LaunchType.mail),
                SocialButton(
                  data: model.seller.website,
                  type: LaunchType.website,
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

  const SocialButton({
    super.key,
    // required this.asset,
    this.data = '',
    this.onTap,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          onTap ??
          () {
            if (type != null) urlLaunch(type!, value: data);
          },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 35,
        width: 35,
        // padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.iconColor, width: 1),
        ),
        child: Image.asset(assets),
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
          size: 18,
          likeCountPadding: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          isLiked: isInWishlist,
          // adjust size
          likeBuilder: (bool isLiked) {
            return isLiked
                ? const Icon(Icons.favorite, color: Colors.red, size: 20)
                : Image.asset(AssetConst.like);
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

  const WhatsappButton({super.key, required this.whatsapp});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          urlLaunch(LaunchType.whatsapp, value: whatsapp);
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.green,
          ),
          child: Row(
            children: [
              Image.asset(AssetConst.whatsapp),
              const SizedBox(width: 3),
              Text(
                'WhatsApp',
                style: context.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
