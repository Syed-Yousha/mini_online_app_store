import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mini_app_store/main.dart';
import 'package:mini_app_store/providers.dart';
import 'package:mini_app_store/models/product.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => FavoritesProvider(),
        child: const MiniStoreApp(),
      ),
    );

    await tester.pumpAndSettle();

    // App title check
    expect(find.text('Mini Online Store'), findsOneWidget);
    
    // Products display check
    expect(find.textContaining('Fjallraven'), findsOneWidget);
  });

  testWidgets('Favorite functionality works', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => FavoritesProvider(),
        child: const MiniStoreApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Tap favorite icon
    final favoriteIcon = find.byIcon(Icons.favorite_border).first;
    await tester.tap(favoriteIcon);
    await tester.pumpAndSettle();

    // Check favorite added
    expect(find.byIcon(Icons.favorite), findsWidgets);
  });

  test('Product model works with rating', () {
    final product = dummyProducts[0];
    expect(product.title, contains('Fjallraven'));
    expect(product.price, 109.95);
    expect(product.rating.rate, 3.9);
    expect(product.rating.count, 120);
  });

  test('FavoritesProvider works', () {
    final provider = FavoritesProvider();
    final product = dummyProducts[0];

    provider.toggleFavorite(product);
    expect(provider.isFavorite(product), true);

    provider.toggleFavorite(product);
    expect(provider.isFavorite(product), false);
  });

  test('All 20 products loaded', () {
    expect(dummyProducts.length, 20);
  });

  test('Products have categories', () {
    final categories = dummyProducts.map((p) => p.category).toSet();
    expect(categories.contains("men's clothing"), true);
    expect(categories.contains("women's clothing"), true);
    expect(categories.contains("electronics"), true);
    expect(categories.contains("jewelery"), true);
  });
}