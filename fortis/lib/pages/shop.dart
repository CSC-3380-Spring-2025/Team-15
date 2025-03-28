import 'package:flutter/material.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ShopItem> items = const [
      ShopItem(
        id: 'coupon_food',
        title: 'Free Burger Coupon',
        price: 4.99,
        icon: Icons.fastfood,
      ),
      ShopItem(
        id: 'skin_icon_blue',
        title: 'Blue Icon Skin',
        price: 2.49,
        icon: Icons.circle,
      ),
      ShopItem(
        id: 'hat_top_hat',
        title: 'Top Hat',
        price: 3.99,
        icon: Icons.emoji_events,
      ),
      ShopItem(
        id: 'badge_star',
        title: 'Star Badge',
        price: 1.99,
        icon: Icons.star,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to the Shop'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.7,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              color: Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.icon, size: 40),
                    const SizedBox(height: 8),
                    Text(item.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 4),
                    Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Purchased ${item.title}!')),
                        );
                      },
                      child: const Text('Buy'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ShopItem {
  final String id;
  final String title;
  final double price;
  final IconData icon;

  const ShopItem({
    required this.id,
    required this.title,
    required this.price,
    required this.icon,
  });
}