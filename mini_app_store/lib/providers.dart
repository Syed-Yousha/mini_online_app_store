import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'models/product.dart';

/// Product Provider - Handles API fetching and filtering
class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String _error = '';
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _sortBy = 'default'; // default, price_asc, price_desc

  List<Product> get products => _filteredProducts;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get sortBy => _sortBy;

  // Get unique categories
  List<String> get categories {
    final cats = _products.map((p) => p.category).toSet().toList();
    cats.insert(0, 'All');
    return cats;
  }

  // Fetch products from API
  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://fakestoreapi.com/products'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _products = data.map((json) => Product.fromJson(json)).toList();
        _applyFilters();
        _error = '';
      } else {
        _error = 'Failed to load products';
      }
    } catch (e) {
      _error = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search products
  void searchProducts(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  // Filter by category
  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  // Sort products
  void sortProducts(String sortType) {
    _sortBy = sortType;
    _applyFilters();
    notifyListeners();
  }

  // Apply all filters
  void _applyFilters() {
    _filteredProducts = _products;

    // Category filter
    if (_selectedCategory != 'All') {
      _filteredProducts = _filteredProducts
          .where((p) => p.category == _selectedCategory)
          .toList();
    }

    // Search filter
    if (_searchQuery.isNotEmpty) {
      _filteredProducts = _filteredProducts
          .where((p) =>
              p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.description.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Sort
    if (_sortBy == 'price_asc') {
      _filteredProducts.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'price_desc') {
      _filteredProducts.sort((a, b) => b.price.compareTo(a.price));
    }
  }
}

/// Favorites Provider - Manages favorites with SharedPreferences
class FavoritesProvider with ChangeNotifier {
  List<int> _favoriteIds = [];

  List<int> get favoriteIds => _favoriteIds;

  // Load favorites from SharedPreferences
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteData = prefs.getStringList('favorites') ?? [];
    _favoriteIds = favoriteData.map((id) => int.parse(id)).toList();
    notifyListeners();
  }

  // Save favorites to SharedPreferences
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'favorites',
      _favoriteIds.map((id) => id.toString()).toList(),
    );
  }

  // Check if product is favorite
  bool isFavorite(int productId) {
    return _favoriteIds.contains(productId);
  }

  // Toggle favorite
  Future<void> toggleFavorite(int productId) async {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    await _saveFavorites();
    notifyListeners();
  }

  // Get favorite products
  List<Product> getFavoriteProducts(List<Product> allProducts) {
    return allProducts.where((p) => _favoriteIds.contains(p.id)).toList();
  }
}

/// Cart Provider - Manages shopping cart
class CartProvider with ChangeNotifier {
  final Map<int, int> _cartItems = {}; // productId -> quantity

  Map<int, int> get cartItems => _cartItems;

  int get itemCount => _cartItems.values.fold(0, (sum, qty) => sum + qty);

  void addToCart(int productId) {
    if (_cartItems.containsKey(productId)) {
      _cartItems[productId] = _cartItems[productId]! + 1;
    } else {
      _cartItems[productId] = 1;
    }
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  int getQuantity(int productId) {
    return _cartItems[productId] ?? 0;
  }
}