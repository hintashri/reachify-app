import 'package:get/get.dart';
import 'package:reachify_app/models/product_model.dart';
import 'package:reachify_app/utils/const/url_const.dart';

import '../../configuration/network_config.dart';
import '../../utils/const/logger.dart';

class WishlistCtrl extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initCall();
  }

  Future<void> initCall() async {
    await getProducts();
  }

  RxBool initLoading = true.obs;
  List<ProductModel> productList = <ProductModel>[];

  Future<void> getProducts() async {
    try {
      initLoading(true);
      final response = await net.get(url: UrlConst.getWishlist, params: {});
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
      initLoading(false);
    } catch (e, t) {
      logger.e('$e\n$t');
      initLoading(false);
    }
  }
}
