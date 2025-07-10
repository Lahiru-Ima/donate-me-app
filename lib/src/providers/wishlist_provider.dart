import 'package:flutter/material.dart';

class WishlistProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _wishlistItems = [];

  List<Map<String, dynamic>> get wishlistItems => _wishlistItems;

  bool isInWishlist(String type, String location) {
    return _wishlistItems.any(
      (item) => item['type'] == type && item['location'] == location,
    );
  }

  void addToWishlist(Map<String, dynamic> item) {
    if (!isInWishlist(item['type'], item['location'])) {
      _wishlistItems.add(item);
      notifyListeners();
    }
  }

  void removeFromWishlist(String type, String location) {
    _wishlistItems.removeWhere(
      (item) => item['type'] == type && item['location'] == location,
    );
    notifyListeners();
  }

  void toggleWishlist(Map<String, dynamic> item) {
    if (isInWishlist(item['type'], item['location'])) {
      removeFromWishlist(item['type'], item['location']);
    } else {
      addToWishlist(item);
    }
  }

  List<Map<String, dynamic>> getWishlistByCategory(String category) {
    return _wishlistItems
        .where((item) => item['category'] == category)
        .toList();
  }
}
