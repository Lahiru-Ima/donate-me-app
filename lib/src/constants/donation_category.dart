import 'package:flutter/material.dart';

class DonationCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final String route;

  const DonationCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.route,
  });
}

class DonationCategories {
  static const Color kBloodColor = Color(0xFFE53E3E);
  static const Color kHairColor = Color(0xFF8B4513);
  static const Color kKidneyColor = Color(0xFF38A169);
  static const Color kFundColor = Color(0xFFD69E2E);

  static const List<DonationCategory> categories = [
    DonationCategory(
      id: 'blood',
      name: 'Blood',
      icon: Icons.bloodtype,
      color: kBloodColor,
      route: '/create-blood-post',
    ),
    DonationCategory(
      id: 'hair',
      name: 'Hair',
      icon: Icons.content_cut,
      color: kHairColor,
      route: '/create-hair-post',
    ),
    DonationCategory(
      id: 'kidney',
      name: 'Kidney',
      icon: Icons.favorite,
      color: kKidneyColor,
      route: '/create-kidney-post',
    ),
    DonationCategory(
      id: 'fund',
      name: 'Fund',
      icon: Icons.attach_money,
      color: kFundColor,
      route: '/create-fund-post',
    ),
  ];

  static DonationCategory? getCategoryById(String id) {
    try {
      return categories.firstWhere(
        (cat) => cat.id.toLowerCase() == id.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  static Color getCategoryColor(String categoryId) {
    final category = getCategoryById(categoryId);
    return category?.color ?? kBloodColor;
  }
}