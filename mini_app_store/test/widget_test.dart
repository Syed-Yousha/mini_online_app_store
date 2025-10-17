import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mini_app_store/main.dart';
import 'package:mini_app_store/providers.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    // Check if home screen loads
    expect(find.text('Mini Store'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  test('ProductProvider initializes correctly', () {
    final provider = ProductProvider();
    expect(provider.products, isEmpty);
    expect(provider.isLoading, false);
    expect(provider.selectedCategory, 'All');
  });

  test('FavoritesProvider toggles favorites', () {
    final provider = FavoritesProvider();
    
    provider.toggleFavorite(1);
    expect(provider.isFavorite(1), true);
    
    provider.toggleFavorite(1);
    expect(provider.isFavorite(1), false);
  });

  test('CartProvider adds items to cart', () {
    final provider = CartProvider();
    
    provider.addToCart(1);
    expect(provider.getQuantity(1), 1);
    expect(provider.itemCount, 1);
    
    provider.addToCart(1);
    expect(provider.getQuantity(1), 2);
    expect(provider.itemCount, 2);
  });

  test('CartProvider removes items', () {
    final provider = CartProvider();
    
    provider.addToCart(1);
    provider.addToCart(2);
    expect(provider.itemCount, 2);
    
    provider.removeFromCart(1);
    expect(provider.itemCount, 1);
    expect(provider.getQuantity(1), 0);
  });

  test('CartProvider clears cart', () {
    final provider = CartProvider();
    
    provider.addToCart(1);
    provider.addToCart(2);
    provider.addToCart(3);
    expect(provider.itemCount, 3);
    
    provider.clearCart();
    expect(provider.itemCount, 0);
    expect(provider.cartItems, isEmpty);
  });
}