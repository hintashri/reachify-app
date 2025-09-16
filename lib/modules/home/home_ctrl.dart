import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:reachify_app/configuration/network_config.dart';
import 'package:reachify_app/configuration/user_config.dart';
import 'package:reachify_app/models/banner_model.dart';
import 'package:reachify_app/models/category_model.dart';
import 'package:reachify_app/models/product_model.dart';
import 'package:reachify_app/routes/app_routes.dart';
import 'package:reachify_app/utils/const/logger.dart';
import 'package:reachify_app/utils/const/url_const.dart';
import 'package:reachify_app/utils/functions/register_dialog.dart';

import 'init_home_ctrl.dart';

class HomeCtrl extends GetxController with GetSingleTickerProviderStateMixin {
  final InitHomeCtrl initHomeCtrl = Get.find<InitHomeCtrl>();
  TextEditingController searchCTRL = TextEditingController();
  RxList<ProductModel> searchList = <ProductModel>[].obs;
  RxString searchParam = ''.obs;

  /// For search animation
  late AnimationController searchController;
  late Animation<Offset> searchOffset;

  static const Duration animationDuration = Duration(milliseconds: 300);

  static const Offset hiddenOffset = Offset(0.0, -1.0); // slide up hidden
  static const Offset visibleOffset = Offset(0.0, 0.0);

  @override
  void onInit() {
    super.onInit();
    initCall();
    _initSearchAnimation();
    searchActive();
  }

  void searchActive() {
    initHomeCtrl.activeTab.listen((p0) {
      if (p0 == 2) {
        showSearch();
      } else {
        hideSearch();
      }
    });
  }

  void _initSearchAnimation() {
    searchController = AnimationController(
      duration: animationDuration,
      vsync: this,
    );
    searchOffset = Tween<Offset>(begin: hiddenOffset, end: visibleOffset)
        .animate(
          CurvedAnimation(parent: searchController, curve: Curves.easeInOut),
        );

    searchController.value = 0.0; // hidden initially
  }

  void hideSearch() =>
      searchController.status == AnimationStatus.completed ||
          searchController.status == AnimationStatus.forward
      ? searchController.reverse()
      : null;

  void showSearch() => searchController.forward();

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> initCall() async {
    isLoading(true);
    await Future.wait([getBanners(), getHomeData()]);
    isLoading(false);
  }

  final CarouselSliderController controller = CarouselSliderController();

  // final List<String> images = [
  //   'https://picsum.photos/id/237/400/200',
  //   'https://picsum.photos/id/239/400/200',
  //   'https://picsum.photos/id/240/400/200',
  //   'https://picsum.photos/id/241/400/200',
  //   'https://picsum.photos/id/242/400/200',
  // ];
  RxList<BannerModel> bannerList = <BannerModel>[].obs;
  RxList<CategoryModel> homeList = <CategoryModel>[].obs;
  RxInt activeIndex = 0.obs;
  // RxBool gettingBanner = true.obs;
  RxBool otherData = true.obs;
  RxBool isSearching = false.obs;
  RxBool isLoading = false.obs;

  Future<void> getBanners() async {
    try {
      // gettingBanner(true);
      final response = await net.get(url: UrlConst.getBanners, params: {});
      if (net.successfulRes(response: response)) {
        final List<dynamic> data = response.data;
        final List<BannerModel> elements = data
            .map((json) => BannerModel.fromJson(json))
            .toList();
        final filterList = elements
            .where((e) => e.catId == user.appUser().selectedCategory)
            .toList();
        bannerList(filterList);
        // logger.d(bannerList.length);
      } else {
        logger.e(response);
      }
      // gettingBanner(false);
    } catch (e, t) {
      logger.e('$e\n$t');
      // gettingBanner(false);
    }
  }

  Future<void> getHomeData() async {
    try {
      otherData(true);
      final response = await net.get(url: UrlConst.getHomeProduct, params: {});
      if (net.successfulRes(response: response)) {
        final List<dynamic> data = response.data;
        final List<CategoryModel> elements = data
            .map((json) => CategoryModel.fromJson(json))
            .toList();
        homeList(elements);
        // logger.d(homeList.length);
      } else {
        logger.e(response);
      }
      otherData(false);
    } catch (e, t) {
      logger.e('$e\n$t');
      otherData(false);
    }
  }

  Future<void> search() async {
    try {
      if (searchParam.isEmpty) return;
      isSearching(true);
      final response = await net.get(
        url: UrlConst.getProductSearch,
        params: {'search': searchParam.value},
      );
      if (net.successfulRes(response: response)) {
        if (response.data is List) {
          final List<dynamic> data = response.data;
          logger.d(data.map((e) => e.toString()).toList());
          final List<ProductModel> elements = data
              .map((json) => ProductModel.fromJson(json))
              .toList();
          searchList(elements);
          Get.toNamed(AppRoutes.searchList);
          logger.d(searchList.length);
        } else {
          searchList([]);
          Get.toNamed(AppRoutes.searchList);
        }
      } else {
        logger.e(response);
      }
      isSearching(false);
    } catch (e, t) {
      logger.e('$e\n$t');
      isSearching(false);
    }
  }

  Future<void> postInteraction({
    required int productId,
    required int interactionType,
  }) async {
    try {
      final response = await net.post(
        url: UrlConst.postInteraction,
        params: {'product_id': productId, 'interaction_type': interactionType},
      );
      if (net.successfulRes(response: response)) {
        logger.d(response);
      } else {
        logger.e(response);
      }
    } catch (e, t) {
      logger.e('$e\n$t');
    }
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    registerDialogue();
  }
}
