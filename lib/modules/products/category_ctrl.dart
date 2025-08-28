import 'package:get/get.dart';
import 'package:reachify_app/configuration/init_config.dart';
import 'package:reachify_app/configuration/user_config.dart';
import 'package:reachify_app/models/category_model.dart';
import 'package:reachify_app/models/product_model.dart';
import 'package:reachify_app/utils/const/url_const.dart';

import '../../configuration/network_config.dart';
import '../../utils/const/logger.dart';

class CategoryCtrl extends GetxController {
  RxBool initLoading = true.obs;
  RxBool proLoading = true.obs;
  List<ProductModel> productList = <ProductModel>[];
  List<CategoryModel> categoryList = <CategoryModel>[];

  String get categoryName =>
      init.categoryList
          .where((e) => e.id == user.appUser.selectedCategory)
          .isEmpty
      ? ''
      : init.categoryList
            .where((e) => e.id == user.appUser.selectedCategory)
            .first
            .name;

  Future<void> getCategories() async {
    try {
      final response = await net.post(
        url: UrlConst.getProCategories,
        params: {'id': 1},
      );
      if (net.successfulRes(response: response)) {
        final List<dynamic> data = response.data;
        final List<CategoryModel> elements = data
            .map((json) => CategoryModel.fromJson(json))
            .toList();
        categoryList = elements;
        // logger.d(categoryList.length);
      } else {
        logger.e(response);
      }
    } catch (e, t) {
      logger.e('$e\n$t');
    }
  }

  Future<void> getProducts({
    required int categoryId,
    bool showLoader = true,
  }) async {
    try {
      if (showLoader) proLoading(true);
      final response = await net.post(
        url: UrlConst.getProducts,
        params: {'id': categoryId},
      );
      if (net.successfulRes(response: response)) {
        final List<dynamic> data = response.data;
        final List<ProductModel> elements = data
            .map((json) => ProductModel.fromJson(json))
            .toList();
        productList = elements;
        // logger.d(productList.length);
      } else {
        logger.e(response);
      }
      proLoading(false);
    } catch (e, t) {
      logger.e('$e\n$t');
      proLoading(false);
    }
  }
}
