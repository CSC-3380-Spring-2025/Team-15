import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fortis/theme_change.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PointsModel with ChangeNotifier {
  static const _key = 'coins';
  int _coins = 0;
  int get coins => _coins;

  PointsModel() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _coins = prefs.getInt(_key) ?? 0;
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, _coins);
  }

  Future<void> add(int amount) async {
    _coins += amount;
    await _save();
    notifyListeners();
  }

  Future<bool> spend(int amount) async {
    if (_coins < amount) return false;
    _coins -= amount;
    await _save();
    notifyListeners();
    return true;
  }

  /* Convenience getter */
  static PointsModel of(BuildContext ctx, {bool listen = false}) =>
      Provider.of<PointsModel>(ctx, listen: listen);
}

/*─────────────────────────────────────────────────────────────
  SHOP PAGE
─────────────────────────────────────────────────────────────*/
class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bgColor = context.watch<ThemeChanger>().backgroundColor;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Shop',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        actions: [
          Consumer<PointsModel>(
            builder: (_, points, __) => Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber),
                const SizedBox(width: 4),
                Text('${points.coins}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(15.0),
        children: [
          _header('Featured'),
          _itemLong(context, 'Featured Pack', 'Awesome stuff', 50),
          _header('Themes'),
          Row(
            children: [
              Expanded(child: _itemTheme('theme name', 'PRICE coins', Colors.blue, context)),
              const SizedBox(width: 15),
              Expanded(child: _itemTheme('theme name', 'PRICE coins', Colors.pinkAccent, context)),
            ],
          ),
          _header('Premium Audio'),
          _itemLong(context, 'Rain Sounds', 'Relaxing ambience', 20),
          _itemLong(context, 'Lo-fi Beats', 'Study music', 25),
          _itemLong(context, 'White Noise', 'Sleep helper', 15),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => PointsModel.of(context).add(10), // demo grant +10
        label: const Text('+10 demo coins'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  /*────────── helper widgets ──────────*/
  Widget _header(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      );

  Widget _itemLong(
      BuildContext context, String title, String desc, int price) {
    return Card(
      color: Colors.grey[300],
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: const Icon(Icons.shopping_bag, size: 50),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(desc),
        trailing: Consumer<PointsModel>(
          builder: (_, points, __) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$price coins',
                  style: const TextStyle(color: Colors.blue)),
              const SizedBox(height: 4),
              ElevatedButton(
                onPressed:
                    points.coins >= price ? () => points.spend(price) : null,
                child: const Text('Buy'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemTheme(String title, String price, Color color, BuildContext context) {
    return Card(
      color: Colors.grey[300],
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Container(height: 100, color: color),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
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
class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PointsModel(),
      child: const MaterialApp(home: ShopPage()),
    );
  }
}

