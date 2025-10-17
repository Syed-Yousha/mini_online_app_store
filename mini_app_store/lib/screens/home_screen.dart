import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../widgets.dart';
import '../providers.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateToFavorites(BuildContext context, List<Product> favorites) {
    if (favorites.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No favorites yet!')),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Favorites')),
            body: ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (ctx, i) => ProductItem(product: favorites[i]),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final products = dummyProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Online Store'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => _navigateToFavorites(
              context,
              favoritesProvider.favorites,
            ),
          ),
        ],
      ),
      body: products.isEmpty
          ? const Center(
              child: Text('No products available'),
            )
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (ctx, i) => ProductItem(product: products[i]),
            ),
    );
  }
}