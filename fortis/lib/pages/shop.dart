import 'package:flutter/material.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String?> items  = List.generate(15, (index) => null); // Placeholder items

    return Scaffold(
      appBar: AppBar(title : const Text('Welcome to the Shop'), centerTitle: true),
      body: Padding(padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount ( // Builds the grid
          crossAxisCount: 3, // 3 columns
          crossAxisSpacing: 8, // Space between columns
          mainAxisSpacing: 8, // space between rows
          childAspectRatio: 0.8, // width to height ratio
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.grey[200],
              child: Center(
                child: items[index] != null ? 
                  Text(
                    'Item $index',
                    style: const TextStyle(fontSize: 16),
                  )
                : const Icon(
                  Icons.shopping_cart,
                  color: Colors.grey,
                  size: 40,
                ),
              ),
            );
          })
      )
    );
  } 
}