import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../products/wishlist_ctrl.dart';

class InitHomeCtrl extends GetxController
    with GetSingleTickerProviderStateMixin {
  /// animation
  late AnimationController animationController;
  late Animation<Offset> offsetAnimation;

  // Observable variables
  final RxBool isNavBarVisible = true.obs;
  final RxBool hasUserScrolled = false.obs;
  RxInt activeTab = 0.obs;

  // Animation configuration
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const double scrollThreshold = 5.0;
  static const Offset hiddenOffset = Offset(0.0, 1.0);
  static const Offset visibleOffset = Offset(0.0, 0.0);

  // Track last scroll position to detect scroll direction
  double _lastScrollPosition = 0.0;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimation();
    initController();
  }

  void initController() {
    Get.lazyPut(() => WishlistCtrl(), fenix: true);
  }

  void _initializeAnimation() {
    animationController = AnimationController(
      duration: animationDuration,
      vsync: this,
    );

    offsetAnimation = Tween<Offset>(begin: hiddenOffset, end: visibleOffset)
        .animate(
          CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
        );

    // Start with navbar visible WITHOUT animation
    animationController.value = 1.0;
  }

  bool handleScrollNotification(ScrollNotification notification) {
    // Ignore horizontal scrolling (carousel, horizontal listviews, etc.)
    if (notification.metrics.axis == Axis.horizontal) {
      return false;
    }

    if (notification is ScrollUpdateNotification) {
      final scrollDelta = notification.scrollDelta ?? 0;
      final currentPosition = notification.metrics.pixels;

      // Mark that user has started scrolling
      if (!hasUserScrolled.value && scrollDelta.abs() > 0) {
        hasUserScrolled.value = true;
      }

      // ALWAYS show navbar when at the top (pixels <= 0)
      if (currentPosition <= 0) {
        _showNavBar();
        _lastScrollPosition = currentPosition;
        return false;
      }

      // Only proceed with hide/show logic if user has scrolled and delta is significant
      if (hasUserScrolled.value && scrollDelta.abs() > scrollThreshold) {
        // Scrolling down (positive delta) - hide navbar
        if (scrollDelta > 0 && isNavBarVisible.value) {
          _hideNavBar();
        }
        // Scrolling up (negative delta) - show navbar
        else if (scrollDelta < 0 && !isNavBarVisible.value) {
          _showNavBar();
        }
      }

      _lastScrollPosition = currentPosition;
    }
    // Handle scroll end - show navbar if user reaches the top
    else if (notification is ScrollEndNotification) {
      final currentPosition = notification.metrics.pixels;

      // If scroll ended at or near the top, ensure navbar is visible
      if (currentPosition <= 0) {
        _showNavBar();
      }
    }

    return false;
  }

  void _hideNavBar() {
    if (isNavBarVisible.value) {
      isNavBarVisible.value = false;
      animationController.reverse();
    }
  }

  void _showNavBar() {
    if (!isNavBarVisible.value) {
      isNavBarVisible.value = true;
      animationController.forward();
    }
  }

  // Method to manually show navbar (can be called from outside)
  void showNavBar() {
    _showNavBar();
  }

  // Method to manually hide navbar (can be called from outside)
  void hideNavBar() {
    _hideNavBar();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
