import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _wishlistItems = [];
  static const String _wishlistKey = 'wishlist_items';

  List<Map<String, dynamic>> get wishlistItems => _wishlistItems;

  // Initialize wishlist from SharedPreferences
  Future<void> initializeWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? wishlistJson = prefs.getString(_wishlistKey);

      if (wishlistJson != null) {
        final List<dynamic> decodedList = json.decode(wishlistJson);
        _wishlistItems.clear();
        _wishlistItems.addAll(
          decodedList.map((item) => Map<String, dynamic>.from(item)).toList(),
        );
        notifyListeners();
      }
    } catch (e) {
      print('Error loading wishlist from SharedPreferences: $e');
    }
  }

  // Save wishlist to SharedPreferences
  Future<void> _saveWishlistToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String wishlistJson = json.encode(_wishlistItems);
      await prefs.setString(_wishlistKey, wishlistJson);
    } catch (e) {
      print('Error saving wishlist to SharedPreferences: $e');
    }
  }

  bool isInWishlist(String type, String location) {
    return _wishlistItems.any(
      (item) => item['type'] == type && item['location'] == location,
    );
  }

  // Alternative method to check by ID if available
  bool isInWishlistById(String id) {
    return _wishlistItems.any((item) => item['id'] == id);
  }

  Future<void> addToWishlist(Map<String, dynamic> item) async {
    if (!isInWishlist(item['type'] ?? '', item['location'] ?? '')) {
      _wishlistItems.add(item);
      await _saveWishlistToPrefs();
      notifyListeners();
    }
  }

  Future<void> removeFromWishlist(String type, String location) async {
    final initialLength = _wishlistItems.length;
    _wishlistItems.removeWhere(
      (item) => item['type'] == type && item['location'] == location,
    );

    // Only save and notify if something was actually removed
    if (_wishlistItems.length != initialLength) {
      await _saveWishlistToPrefs();
      notifyListeners();
    }
  }

  // Remove by ID method
  Future<void> removeFromWishlistById(String id) async {
    final initialLength = _wishlistItems.length;
    _wishlistItems.removeWhere((item) => item['id'] == id);

    if (_wishlistItems.length != initialLength) {
      await _saveWishlistToPrefs();
      notifyListeners();
    }
  }

  Future<void> toggleWishlist(Map<String, dynamic> item) async {
    if (isInWishlist(item['type'] ?? '', item['location'] ?? '')) {
      await removeFromWishlist(item['type'] ?? '', item['location'] ?? '');
    } else {
      await addToWishlist(item);
    }
  }

  // Toggle by ID method
  Future<void> toggleWishlistById(Map<String, dynamic> item) async {
    final id = item['id'] ?? '';
    if (isInWishlistById(id)) {
      await removeFromWishlistById(id);
    } else {
      await addToWishlist(item);
    }
  }

  List<Map<String, dynamic>> getWishlistByCategory(String category) {
    return _wishlistItems
        .where((item) => item['category'] == category)
        .toList();
  }

  // Clear all wishlist items
  Future<void> clearWishlist() async {
    _wishlistItems.clear();
    await _saveWishlistToPrefs();
    notifyListeners();
  }

  // Get wishlist count
  int get wishlistCount => _wishlistItems.length;

  // Check if wishlist is empty
  bool get isEmpty => _wishlistItems.isEmpty;
}
