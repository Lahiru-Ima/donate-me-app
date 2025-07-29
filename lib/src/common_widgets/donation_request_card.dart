import 'package:donate_me_app/src/constants/constants.dart';
import 'package:donate_me_app/src/constants/donation_category.dart';
import 'package:donate_me_app/src/models/request_models/donation_request_model.dart';
import 'package:donate_me_app/src/router/router_names.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:donate_me_app/src/providers/wishlist_provider.dart';

enum CardType { urgent, community }

class DonationRequestCard extends StatelessWidget {
  final DonationRequestModel request;
  final CardType cardType;
  final VoidCallback? onWishlistToggle;

  const DonationRequestCard({
    super.key,
    required this.request,
    required this.cardType,
    this.onWishlistToggle,
  });

  const DonationRequestCard.urgent({
    super.key,
    required this.request,
    this.onWishlistToggle,
  }) : cardType = CardType.urgent;

  const DonationRequestCard.community({
    super.key,
    required this.request,
    this.onWishlistToggle,
  }) : cardType = CardType.community;

  bool get isUrgent => cardType == CardType.urgent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(RouterNames.donationDetails, extra: request.toMap());
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        width: isUrgent ? 200 : double.infinity,
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
          border: isUrgent
              ? null
              : Border(
                  left: BorderSide(
                    color: DonationCategories.getCategoryColor(
                      request.category,
                    ),
                    width: 6,
                  ),
                ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isUrgent ? Colors.red[50] : Colors.blue[50]!,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      request.title.toUpperCase(),
                      style: TextStyle(
                        color: isUrgent ? Colors.red[700] : Colors.blue[700]!,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (onWishlistToggle != null) ...[
                  const SizedBox(width: 8),
                  Consumer<WishlistProvider>(
                    builder: (context, wishlistProvider, child) {
                      // Check if in wishlist using multiple methods for better accuracy
                      bool isInWishlist = false;
                      if (request.id.isNotEmpty) {
                        isInWishlist = wishlistProvider.isInWishlistById(
                          request.id,
                        );
                      } else {
                        isInWishlist = wishlistProvider.isInWishlist(
                          request.title,
                          request.location,
                        );
                      }

                      return GestureDetector(
                        onTap: () async {
                          if (isInWishlist) {
                            // Remove from wishlist
                            if (request.id.isNotEmpty) {
                              await wishlistProvider.removeFromWishlistById(
                                request.id,
                              );
                            } else {
                              await wishlistProvider.removeFromWishlist(
                                request.title,
                                request.location,
                              );
                            }

                            // Show removed message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Removed from wishlist'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else {
                            // Add to wishlist
                            await wishlistProvider.addToWishlist(
                              request.toMap(),
                            );

                            // Show added message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Added to wishlist'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }

                          // Call the external callback if provided
                          if (onWishlistToggle != null) {
                            onWishlistToggle!();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            isInWishlist
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isInWishlist ? Colors.red : Colors.grey,
                            size: 18,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    request.location,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              request.description,
              style: TextStyle(fontSize: 11, color: Colors.black87),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            isUrgent
                ? SizedBox(
                    width: double.infinity,
                    child: _buildDonateButton(context),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [_buildDonateButton(context)],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonateButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _navigateToCategory(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        padding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: isUrgent ? 0 : 20,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        minimumSize: isUrgent ? const Size(double.infinity, 36) : null,
      ),
      child: const Text(
        'Donate',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _navigateToCategory(BuildContext context) {
    final routeMap = {
      'blood': RouterNames.bloodDonation,
      'hair': RouterNames.hairDonation,
      'kidney': RouterNames.kidneyDonation,
      'fund': RouterNames.fundDonation,
    };

    final route = routeMap[request.category.toLowerCase()];
    if (route != null) {
      context.push(
        route,
        extra: {
          'type': request.title,
          'location': request.location,
          'description': request.description,
          'category': request.category,
          'isUrgent': request.isUrgent,
          'id': request.id,
          ...request.additionalData,
        },
      );
    }
  }
}
