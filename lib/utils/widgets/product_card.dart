import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachify_app/models/product_model.dart';
import 'package:reachify_app/routes/app_routes.dart';
import 'package:reachify_app/utils/const/url_const.dart';
import 'package:reachify_app/utils/widgets/cache_image.dart';

class ProductCard extends StatelessWidget {
  final List<ProductModel> list;
  final int index;

  const ProductCard({super.key, required this.list, required this.index});

  @override
  Widget build(BuildContext context) {
    final ProductModel product = list[index];
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        Get.toNamed(
          AppRoutes.productDetail,
          arguments: {'index': index, 'list': list},
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CacheImage(
            url:
                '${UrlConst.baseUrl}/storage/app/public/product/${product.images.first}',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}
