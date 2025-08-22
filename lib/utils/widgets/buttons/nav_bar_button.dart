import 'package:flutter/material.dart';

class NavBarButton extends StatelessWidget {
  final String assetName;
  final int index;
  final VoidCallback? onTap;

  const NavBarButton({
    super.key,
    required this.assetName,
    this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index == 0 ? const Color.fromRGBO(133, 133, 133, 0.12) : null,
        ),
        child: Image.asset(assetName, height: 24),
      ),
    );
  }
}
