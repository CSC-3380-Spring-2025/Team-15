import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fortis/theme_change.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  // Constants for styling
  static const double headerFontSize = 20.0;
  static const double titleFontSize = 18.0;
  static const double itemSpacing = 15.0;
  static const double themeItemHeight = 100.0;
  static const double iconSize = 50.0;
  static const EdgeInsets defaultPadding = EdgeInsets.all(15.0);
  static const BorderRadius cardBorderRadius = BorderRadius.all(
    Radius.circular(15),
  );

  @override
  Widget build(BuildContext context) {
    final bgColor = context.watch<ThemeChanger>().backgroundColor;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          'Shop',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        actions: [
          Row(
            children: [
              const Icon(
                Icons.monetization_on,
                color: Colors.amber,
                semanticLabel: 'Coins',
              ),
              const SizedBox(width: 5),
              const Text('# Coins', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 15),
              const Icon(
                Icons.notifications,
                color: Colors.grey,
                semanticLabel: 'Notifications',
              ),
              const SizedBox(width: 15),
            ],
          ),
        ],
      ),

      body: ListView(
        padding: defaultPadding,
        children: [
          _buildHeaderTitle('Featured'),
          _buildLongItem(
            context,
            'Featured item',
            'This is a featured item description',
            '100 coins',
          ),
          _buildHeaderTitle('Themes'),
          const SizedBox(height: itemSpacing),
          _buildThemeRow(context),

          _buildHeaderTitle('Premium Audio'),
          _buildLongItem(
            context,
            'Premium Audio 1',
            'High quality audio track',
            '200 coins',
          ),
          _buildLongItem(
            context,
            'Premium Audio 2',
            'Exclusive sound effect',
            '250 coins',
          ),
          _buildLongItem(
            context,
            'Premium Audio 3',
            'Limited edition music',
            '300 coins',
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: headerFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLongItem(
    BuildContext context,
    String title,
    String description,
    String price,
  ) {
    return Card(
      color: Colors.grey[300],
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: cardBorderRadius),
      margin: const EdgeInsets.only(bottom: itemSpacing),
      child: ListTile(
        contentPadding: defaultPadding,
        leading: const Icon(
          Icons.music_note,
          size: iconSize,
          color: Colors.green,
          semanticLabel: 'Item icon',
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(description),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              price,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 30,
              child: ElevatedButton(
                onPressed: () => _handlePurchase(context, title, price),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                ),
                child: const Text('Buy'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildThemeItem(
            'Blue Theme',
            '150 coins',
            Colors.blue,
            context,
          ),
        ),
        const SizedBox(width: itemSpacing),
        Expanded(
          child: _buildThemeItem(
            'Pink Theme',
            '150 coins',
            Colors.pinkAccent,
            context,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeItem(
    String title,
    String price,
    Color color,
    BuildContext context,
  ) {
    return Card(
      elevation: 3,
      color: Colors.grey[300],
      shape: RoundedRectangleBorder(borderRadius: cardBorderRadius),
      child: Column(
        children: [
          Container(height: themeItemHeight, color: color),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(price, style: const TextStyle(color: Colors.blue)),
                ElevatedButton(
                  onPressed: () => _handleThemeChange(context, color),
                  child: const Text('Buy'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handlePurchase(BuildContext context, String itemName, String price) {
    // Implement purchase logic
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Purchased $itemName for $price')));
  }

  void _handleThemeChange(BuildContext context, Color color) {
    try {
      context.read<ThemeChanger>().setColor(color);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Theme changed successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to change theme')));
    }
  }
}
