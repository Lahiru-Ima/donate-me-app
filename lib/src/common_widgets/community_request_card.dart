import 'package:donate_me_app/src/constants/constants.dart';
import 'package:donate_me_app/src/router/router_names.dart';
import 'package:donate_me_app/src/providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CommunityRequestCard extends StatelessWidget {
  final String type;
  final String location;
  final String description;
  final String category;
  final VoidCallback? onWishlistToggle;

  const CommunityRequestCard({
    super.key,
    required this.type,
    required this.location,
    required this.description,
    required this.category,
    this.onWishlistToggle,
  });

  @override
  Widget build(BuildContext context) {
    // Get category color
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

    return GestureDetector(
      onTap: () {
        context.push(
          RouterNames.donationDetails,
          extra: {
            'type': type,
            'location': location,
            'description': description,
            'isUrgent': false,
            'category': category,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
            ),
          ],
          border: Border(
            left: BorderSide(color: getCategoryColor(category), width: 6),
          ),
        ),
        child: Column(
          children: [
            // Top section with heart icon
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              type,
                              style: TextStyle(
                                color: Colors.red[700],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          if (onWishlistToggle != null)
                            Consumer<WishlistProvider>(
                              builder: (context, wishlistProvider, child) {
                                final isInWishlist = wishlistProvider
                                    .isInWishlist(type, location);
                                return IconButton(
                                  onPressed: onWishlistToggle,
                                  icon: Icon(
                                    isInWishlist
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isInWishlist
                                        ? Colors.red
                                        : Colors.grey,
                                    size: 20,
                                  ),
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                );
                              },
                            ),
                        ],
                      ),

                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Bottom section with donate button aligned to right
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (category.toLowerCase() == 'blood') {
                    context.push(RouterNames.bloodDonation, extra: {
                      'type': type,
                      'location': location,
                      'description': description,
                    });
                  } else if (category.toLowerCase() == 'hair') {
                    context.push(RouterNames.hairDonation, extra: {
                      'type': type,
                      'location': location,
                      'description': description,
                    });
                  } else if (category.toLowerCase() == 'kidney') {
                    context.push(RouterNames.kidneyDonation, extra: {
                      'type': type,
                      'location': location,
                      'description': description,
                    });
                  } else if (category.toLowerCase() == 'fund') {
                    context.push(RouterNames.fundDonation, extra: {
                      'type': type,
                      'location': location,
                      'description': description,
                      'isUrgent': true,
                      'category': category,
                    });
                  }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Donate',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
