import 'package:flutter/material.dart';
import 'package:fortis/globals.dart';



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
    return ValueListenableBuilder<Color>(
      valueListenable: globalBgColor,
      builder: (context, bgColor, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: bgColor,
            title: const Text(
              'Shop',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            actions: [ /* … */ ],
          ),

         
          body: Container(
            color: bgColor,        
            child: ListView(
              padding: const EdgeInsets.all(15.0),
              children: [
                _headerTitle('Featured'),
                _itemLong('featured name', 'description', 'PRICE coins'),
                _headerTitle('Themes'),
                Row(
                  children: [
                    Expanded(
                      child: _itemTheme('Blue Theme', 'PRICE coins', Colors.blue),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _itemTheme('Orange Theme', 'PRICE coins', Colors.orange),
                    ),
                  ],
                ),
                _headerTitle('Premium Audio'),
                _itemLong('audio 1', 'desc', 'PRICE coins'),
                _itemLong('audio 2', 'desc', 'PRICE coins'),
                _itemLong('audio 3', 'desc', 'PRICE coins'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _headerTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );

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

  Widget _itemTheme(String title, String price, Color color) => Card(
        elevation: 3,
        color: Colors.grey[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Container(height: 100, color: color),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(price, style: const TextStyle(color: Colors.blue)),
                  ElevatedButton(
                    onPressed: () {
                      globalBgColor.value = color;
                    },
                    child: const Text('Buy'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
