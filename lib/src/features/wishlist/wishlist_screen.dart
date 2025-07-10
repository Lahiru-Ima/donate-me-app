import 'package:donate_me_app/src/common_widgets/community_request_card.dart';
import 'package:donate_me_app/src/providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  // Get all wishlist requests
  List<Map<String, dynamic>> getAllWishlistRequests() {
    final wishlistProvider = Provider.of<WishlistProvider>(
      context,
      listen: false,
    );
    return wishlistProvider.wishlistItems;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WishlistProvider>(
      builder: (context, wishlistProvider, child) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            forceMaterialTransparency: true,
            automaticallyImplyLeading: false,
            title: const Text(
              'My Wishlist',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search, color: Colors.black),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Saved Requests Section
                if (getAllWishlistRequests().isNotEmpty) ...[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: getAllWishlistRequests().length,
                    itemBuilder: (context, index) {
                      final request = getAllWishlistRequests()[index];
                      return CommunityRequestCard(
                        type: request['type'],
                        location: request['location'],
                        description: request['description'],
                        category: request['category'],
                        onWishlistToggle: () {
                          final wishlistProvider =
                              Provider.of<WishlistProvider>(
                                context,
                                listen: false,
                              );
                          wishlistProvider.removeFromWishlist(
                            request['type'],
                            request['location'],
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Removed from wishlist'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],

                // Show message if no requests available
                if (getAllWishlistRequests().isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Column(
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No requests in your wishlist',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Browse requests and add them to your wishlist',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
