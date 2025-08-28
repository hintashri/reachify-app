import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachify_app/theme/app_colors.dart';
import 'package:reachify_app/utils/const/asset_const.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Category')),
      body: ListView(
        children: const [
          ProductDetailCard(
            imageUrl:
                'https://images.pexels.com/photos/326055/pexels-photo-326055.jpeg?_gl=1*3h4c5x*_ga*Mjg5MjczNDk4LjE3NTYzNTA2ODA.*_ga_8JE65Q40S6*czE3NTYzNTA2NzkkbzEkZzEkdDE3NTYzNTA3MTYkajIzJGwwJGgw',
            shopName: 'Balaji Hardware',
            city: 'Rajkot',
            ownerName: 'Mr. Chiragbhai Patel',
          ),
          ProductDetailCard(
            imageUrl:
                'https://images.pexels.com/photos/326055/pexels-photo-326055.jpeg?_gl=1*3h4c5x*_ga*Mjg5MjczNDk4LjE3NTYzNTA2ODA.*_ga_8JE65Q40S6*czE3NTYzNTA2NzkkbzEkZzEkdDE3NTYzNTA3MTYkajIzJGwwJGgw',
            shopName: 'Rajan Polyplast',
            city: 'Rajkot',
            ownerName: 'Mr. Chiragbhai Patel',
          ),
        ],
      ),
    );
  }
}

class ProductDetailCard extends StatelessWidget {
  final String imageUrl;
  final String shopName;
  final String city;
  final String ownerName;

  const ProductDetailCard({
    super.key,
    required this.imageUrl,
    required this.shopName,
    required this.city,
    required this.ownerName,
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
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              '$shopName - $city',
              style: context.textTheme.headlineSmall?.copyWith(fontSize: 15),
            ),

            const SizedBox(height: 4),

            /// Owner name
            Text(
              ownerName,
              style: context.textTheme.labelSmall?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.iconColor,
              ),
            ),

            const Divider(color: AppColors.iconColor, height: 20),

            /// Action buttons row
            const Row(
              children: [
                WhatsappButton(),
                SizedBox(width: 10),
                SocialButton(asset: AssetConst.call),
                SizedBox(width: 10),
                SocialButton(asset: AssetConst.mail),
                SizedBox(width: 10),
                SocialButton(asset: AssetConst.web),
                SizedBox(width: 10),
                SocialButton(asset: AssetConst.like),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String asset;

  const SocialButton({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.iconColor, width: 1),
        ),
        child: Image.asset(asset),
      ),
    );
  }
}

class WhatsappButton extends StatelessWidget {
  const WhatsappButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
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
    );
  }
}
