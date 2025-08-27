import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  @override
  void onInit() {
    super.onInit();
    _initializeAnimation();
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

  // Handle scroll notifications from ANY scrollable widget
  // bool handleScrollNotification(ScrollNotification notification) {
  //   if (notification is ScrollUpdateNotification) {
  //     final scrollDelta = notification.scrollDelta ?? 0;
  //
  //     // Mark that user has started scrolling
  //     if (!hasUserScrolled.value && scrollDelta.abs() > 0) {
  //       hasUserScrolled.value = true;
  //     }
  //
  //     // Always show navbar when at the top of ANY scroll view
  //     if (notification.metrics.pixels <= 0) {
  //       _showNavBar();
  //       return false;
  //     }
  //
  //     // Only animate if user has scrolled before and delta is significant
  //     if (hasUserScrolled.value && scrollDelta.abs() > scrollThreshold) {
  //       if (scrollDelta > 0 && isNavBarVisible.value) {
  //         _hideNavBar();
  //       } else if (scrollDelta < 0 && !isNavBarVisible.value) {
  //         _showNavBar();
  //       }
  //     }
  //   }
  //
  //   // Return false to allow the notification to continue bubbling up
  //   return false;
  // }

  bool handleScrollNotification(ScrollNotification notification) {
    // Ignore horizontal scrolling (carousel, horizontal listviews, etc.)
    if (notification.metrics.axis == Axis.horizontal) {
      return false;
    }

    if (notification is ScrollUpdateNotification) {
      final scrollDelta = notification.scrollDelta ?? 0;

      if (!hasUserScrolled.value && scrollDelta.abs() > 0) {
        hasUserScrolled.value = true;
      }

      if (notification.metrics.pixels <= 0) {
        _showNavBar();
        return false;
      }

      if (hasUserScrolled.value && scrollDelta.abs() > scrollThreshold) {
        if (scrollDelta > 0 && isNavBarVisible.value) {
          _hideNavBar();
        } else if (scrollDelta < 0 && !isNavBarVisible.value) {
          _showNavBar();
        }
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

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
