import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/product.dart';

/// ✅ Handles the favorites logic
class FavoritesProvider with ChangeNotifier {
  final List<Product> _favorites = [];

  List<Product> get favorites => _favorites;

  void toggleFavorite(Product product) {
    if (_favorites.contains(product)) {
      _favorites.remove(product);
    } else {
      _favorites.add(product);
    }
    notifyListeners(); // Notify listeners when favorites list changes
  }

  bool isFavorite(Product product) {
    return _favorites.contains(product);
  }
}

/// ✅ A wrapper that provides all app-level providers
class AppProviders extends StatelessWidget {
  final Widget child;
  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: child,
    );
  }
}
