import 'package:get/get.dart';
import 'package:reachify_app/models/product_model.dart';
import 'package:reachify_app/utils/const/url_const.dart';

import '../../configuration/network_config.dart';
import '../../utils/const/logger.dart';

class WishlistCtrl extends GetxController {
  @override
  void onInit() {
    logger.d('Wishlist INIT Called');
    // TODO: implement onInit
    super.onInit();
    initCall();
  }

  Future<void> initCall() async {
    await getProducts();
  }

  RxBool initLoading = true.obs;
  RxList<ProductModel> productList = <ProductModel>[].obs;

  Future<void> getProducts() async {
    try {
      initLoading(true);
      final response = await net.get(url: UrlConst.getWishlist, params: {});
      if (net.successfulRes(response: response)) {
        final List<dynamic> data = response.data;
        final List<ProductModel> elements = data
            .map((json) => ProductModel.fromJson(json))
            .toList();
        productList(elements);
        // logger.d(productList.length);
      } else {
        logger.e(response);
      }
      initLoading(false);
    } catch (e, t) {
      logger.e('$e\n$t');
      initLoading(false);
    }
  }

  Future<bool> addToWishlist(int id) async {
    try {
      final response = await net.post(
        url: UrlConst.addWishlist,
        params: {'product_id': id},
      );
      if (net.successfulRes(response: response)) {
        logger.d(response.data);
        getProducts();
        return true;
      } else {
        logger.e(response);
        return false;
      }
    } catch (e, t) {
      logger.e('$e\n$t');
      return false;
    }
  }

  Future<bool> removeFromWishlist(int id) async {
    try {
      final response = await net.delete(
        url: UrlConst.removeWishlist,
        params: {'product_id': id},
      );
      if (net.successfulRes(response: response)) {
        logger.d(response.data);
        // final List<dynamic> data = response.data;
        // final List<ProductModel> elements = data
        //     .map((json) => ProductModel.fromJson(json))
        //     .toList();
        // productList = elements;
        // logger.d(productList.length);
        getProducts();
        return true;
      } else {
        logger.e(response);
        return false;
      }
    } catch (e, t) {
      logger.e('$e\n$t');
      return false;
    }
  }
}
