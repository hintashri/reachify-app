import 'package:flutter/material.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Category')),
      body: ListView(
        children: const [
          ProductDetailCard(
            imageUrl: 'https://via.placeholder.com/400x200.png',
            shopName: 'Balaji Hardware',
            city: 'Rajkot',
            ownerName: 'Mr. Chiragbhai Patel',
          ),
          ProductDetailCard(
            imageUrl: 'https://via.placeholder.com/400x200.png',
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Banner image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.network(
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Shop title
                Text(
                  '$shopName - $city',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                /// Owner name
                Text(
                  ownerName,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),

                const SizedBox(height: 12),

                /// Action buttons row
                Row(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      label: const Text('WhatsApp'),
                      icon: const Icon(Icons.message, size: 16),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.phone, color: Colors.black54),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.share, color: Colors.black54),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
