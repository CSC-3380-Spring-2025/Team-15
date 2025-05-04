import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fortis/theme_change.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ShopPage(),
    );
  }
}

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bgColor = context.watch<ThemeChanger>().backgroundColor;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Shop', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        actions: [
          Row(
            children: [
              const Icon(Icons.monetization_on, color: Colors.amber),
              const SizedBox(width: 5),
              const Text('# Coins', style: TextStyle(fontSize: 18)), // User coin count variable goes here
              const SizedBox(width: 15),

              const Icon(Icons.notifications, color: Colors.grey), // Notifications placeholder icon
              const Text('      ')
            ],

          )
          
        ],
      ),
      
      body: ListView(
        padding: const EdgeInsets.all(15.0),
        children: [
          _headerTitle('Featured'),
          _itemLong('featured name', 'description', 'PRICE coins'),
          
          _headerTitle('Themes'),
          Row(
            children: [
              Expanded(child: _itemTheme('theme name', 'PRICE coins', Colors.blue, context)),
              const SizedBox(width: 15),
              Expanded(child: _itemTheme('theme name', 'PRICE coins', Colors.pinkAccent, context)),
            ],
          ),
          // Repeat Row() for more themes

          
          _headerTitle('Premium Audio'),
          _itemLong('audio name', 'description', 'PRICE coins'),
          _itemLong('audio name', 'description', 'PRICE coins'), 
          _itemLong('audio name', 'description', 'PRICE coins'),
          // Repeat _itemLong() for more items
        ],
      ),
    );
  }

  Widget _headerTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _itemLong(String title, String description, String price) {
    return Card(
      color: Colors.grey[300],
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: const Icon(Icons.music_note, size: 50, color: Colors.green),
        title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(price, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            SizedBox(
            height: 30,
            child: ElevatedButton(
              onPressed: () {}, // Add purchase mechanic
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), 
                textStyle: const TextStyle(fontSize: 13),
              ),
              child: const Text('Buy'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemTheme(String title, String price, Color color, BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.grey[300],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Container(
            height: 100,
            color: color, // Preview theme color
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(price, style: const TextStyle(color: Colors.blue)),
                ElevatedButton(
                  onPressed: () {
                    context.read<ThemeChanger>().setColor(color);
                  }, // Add purchase mechanic 
                  child: const Text('Buy'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}