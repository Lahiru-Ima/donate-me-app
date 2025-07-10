import 'package:donate_me_app/src/features/home/donation_details_screen.dart';
import 'package:donate_me_app/src/features/donation/blood_donation_form_screen.dart';
import 'package:donate_me_app/src/features/donation/hair_donation_form_screen.dart';
import 'package:donate_me_app/src/features/donation/kidney_donation_form_screen.dart';
import 'package:donate_me_app/src/features/donation/fund_donation_form_screen.dart';
import 'package:donate_me_app/src/providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UrgentRequestCard extends StatelessWidget {
  final String type;
  final String location;
  final String description;
  final String category;
  final VoidCallback? onWishlistToggle;

  const UrgentRequestCard({
    super.key,
    required this.type,
    required this.location,
    required this.description,
    required this.category,
    this.onWishlistToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (category.toLowerCase() == 'blood') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BloodDonationFormScreen(
                type: type,
                location: location,
                description: description,
              ),
            ),
          );
        } else if (category.toLowerCase() == 'hair') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HairDonationFormScreen(
                type: type,
                location: location,
                description: description,
              ),
            ),
          );
        } else if (category.toLowerCase() == 'kidney') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KidneyDonationFormScreen(
                type: type,
                location: location,
                description: description,
              ),
            ),
          );
        } else if (category.toLowerCase() == 'fund') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FundDonationFormScreen(
                type: type,
                location: location,
                description: description,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DonationDetailsScreen(
                type: type,
                location: location,
                description: description,
                isUrgent: true,
                category: category,
              ),
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(12),
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
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (onWishlistToggle != null) ...[
                  SizedBox(width: 8),
                  Consumer<WishlistProvider>(
                    builder: (context, wishlistProvider, child) {
                      final isInWishlist = wishlistProvider.isInWishlist(
                        type,
                        location,
                      );
                      return GestureDetector(
                        onTap: onWishlistToggle,
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
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    location,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Flexible(
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                  height: 1.3,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (category.toLowerCase() == 'blood') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BloodDonationFormScreen(
                          type: type,
                          location: location,
                          description: description,
                        ),
                      ),
                    );
                  } else if (category.toLowerCase() == 'hair') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HairDonationFormScreen(
                          type: type,
                          location: location,
                          description: description,
                        ),
                      ),
                    );
                  } else if (category.toLowerCase() == 'kidney') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KidneyDonationFormScreen(
                          type: type,
                          location: location,
                          description: description,
                        ),
                      ),
                    );
                  } else if (category.toLowerCase() == 'fund') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FundDonationFormScreen(
                          type: type,
                          location: location,
                          description: description,
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DonationDetailsScreen(
                          type: type,
                          location: location,
                          description: description,
                          isUrgent: true,
                          category: category,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  minimumSize: Size(double.infinity, 36),
                ),
                child: Text(
                  'Donate',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
