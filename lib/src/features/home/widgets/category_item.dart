import 'package:donate_me_app/src/constants/constants.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onPressed;

  const CategoryItem({
    super.key,
    required this.title,
    required this.icon,
    this.isSelected = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color getCategoryColor(String category) {
      switch (category) {
        case 'Blood':
          return kBloodColor;
        case 'Hair':
          return kHairColor;
        case 'Kidney':
          return kKidneyColor;
        case 'Fund':
          return kFundColor;
        default:
          return kBloodColor;
      }
    }

    return InkWell(
      splashColor: Colors.transparent,
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: isSelected ? getCategoryColor(title) : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Icon(icon, size: 40, color: Colors.white)),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? getCategoryColor(title) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
