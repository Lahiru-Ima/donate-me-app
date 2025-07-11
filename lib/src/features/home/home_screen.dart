import 'package:donate_me_app/src/common_widgets/urgent_request_card.dart';
import 'package:donate_me_app/src/constants/constants.dart';
import 'package:donate_me_app/src/common_widgets/community_request_card.dart';
import 'package:donate_me_app/src/providers/auth_provider.dart';
import 'package:donate_me_app/src/providers/donation_request_provider.dart';
import 'package:donate_me_app/src/providers/wishlist_provider.dart';
import 'package:donate_me_app/src/router/router_names.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:donate_me_app/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedCategory = 'Blood';
  final List<String> categories = ['Blood', 'Hair', 'Kidney', 'Fund'];

  @override
  void initState() {
    super.initState();
    // Load initial data for default category
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final donationProvider = Provider.of<DonationRequestProvider>(
        context,
        listen: false,
      );
      if (selectedCategory != null) {
        donationProvider.loadRequestsByCategory(selectedCategory!);
      }
    });
  }

  // Get localized category name
  String getLocalizedCategoryName(String category, AppLocalizations l10n) {
    switch (category) {
      case 'Blood':
        return l10n.blood;
      case 'Hair':
        return l10n.hair;
      case 'Kidney':
        return l10n.kidney;
      case 'Fund':
        return l10n.fund;
      default:
        return category;
    }
  }

  // Get icon for each category
  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Blood':
        return Icons.bloodtype;
      case 'Hair':
        return Icons.content_cut;
      case 'Kidney':
        return Icons.favorite;
      case 'Fund':
        return Icons.attach_money;
      default:
        return Icons.category;
    }
  }

  void _showCreatePostDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            l10n.createDonationRequest,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'What type of donation request would you like to create?',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildCreatePostOption(
                context,
                'Blood',
                Icons.bloodtype,
                kBloodColor,
                'Request blood donation',
                () => context.push(RouterNames.createBloodPost),
              ),
              const SizedBox(height: 12),
              _buildCreatePostOption(
                context,
                'Hair',
                Icons.content_cut,
                Colors.brown,
                'Request hair donation',
                () => context.push(RouterNames.createHairPost),
              ),
              const SizedBox(height: 12),
              _buildCreatePostOption(
                context,
                'Kidney',
                Icons.favorite,
                Colors.green,
                'Request kidney donation',
                () => context.push(RouterNames.createKidneyPost),
              ),
              const SizedBox(height: 12),
              _buildCreatePostOption(
                context,
                'Fund',
                Icons.attach_money,
                Colors.orange,
                'Request financial assistance',
                () => context.push(RouterNames.createFundPost),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCreatePostOption(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String subtitle,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.hiUser(
                    authProvider.userModel?.name.split(' ')[0] ?? 'User',
                  ),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  l10n.makeDifference,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            InkWell(
              onTap: () {},
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.search, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostDialog(context),
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Consumer<DonationRequestProvider>(
        builder: (context, donationProvider, child) {
          return RefreshIndicator(
            onRefresh: () async {
              if (selectedCategory != null) {
                await donationProvider.loadRequestsByCategory(
                  selectedCategory!,
                );
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.categories,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: categories.map((category) {
                        return _buildCategoryItem(
                          getLocalizedCategoryName(category, l10n),
                          getCategoryIcon(category),
                          isSelected: selectedCategory == category,
                          onPressed: () {
                            setState(() {
                              selectedCategory = category;
                            });
                            donationProvider.loadRequestsByCategory(category);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Show loading indicator
                  if (donationProvider.isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: CircularProgressIndicator(color: kPrimaryColor),
                      ),
                    )
                  // Show error message
                  else if (donationProvider.error != null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Failed to load requests',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              donationProvider.error!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                donationProvider.clearError();
                                if (selectedCategory != null) {
                                  donationProvider.loadRequestsByCategory(
                                    selectedCategory!,
                                  );
                                }
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    )
                  // Show content only if category is selected and no error
                  else if (selectedCategory != null) ...[             

                    // Urgent Requests Section
                    if (donationProvider
                        .getUrgentRequestsByCategory(selectedCategory)
                        .isNotEmpty) ...[
                      Text(
                        l10n.urgentRequests,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 170,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: donationProvider
                              .getUrgentRequestsByCategory(selectedCategory)
                              .length,
                          itemBuilder: (context, index) {
                            final request = donationProvider
                                .getUrgentRequestsByCategory(
                                  selectedCategory,
                                )[index];
                            return Container(
                              width: 200,
                              margin: const EdgeInsets.only(right: 12),
                              child: UrgentRequestCard(
                                request: request,
                                onWishlistToggle: () {
                                  final wishlistProvider =
                                      Provider.of<WishlistProvider>(
                                        context,
                                        listen: false,
                                      );

                                  final item = {
                                    'type': request['type'],
                                    'location': request['location'],
                                    'description': request['description'],
                                    'category': request['category'],
                                    'isUrgent': request['isUrgent'],
                                  };

                                  wishlistProvider.toggleWishlist(item);

                                  // Show feedback to user
                                  final isInWishlist = wishlistProvider
                                      .isInWishlist(
                                        request['type'],
                                        request['location'],
                                      );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        isInWishlist
                                            ? 'Added to wishlist'
                                            : 'Removed from wishlist',
                                      ),
                                      backgroundColor: isInWishlist
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Community Requests Section
                    if (donationProvider
                        .getCommunityRequestsByCategory(selectedCategory)
                        .isNotEmpty) ...[
                      Text(
                        l10n.communityRequests,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: donationProvider
                            .getCommunityRequestsByCategory(selectedCategory)
                            .length,
                        itemBuilder: (context, index) {
                          final request = donationProvider
                              .getCommunityRequestsByCategory(
                                selectedCategory,
                              )[index];
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

                              final item = {
                                'type': request['type'],
                                'location': request['location'],
                                'description': request['description'],
                                'category': request['category'],
                                'isUrgent': request['isUrgent'],
                              };

                              wishlistProvider.toggleWishlist(item);

                              // Show feedback to user
                              final isInWishlist = wishlistProvider
                                  .isInWishlist(
                                    request['type'],
                                    request['location'],
                                  );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isInWishlist
                                        ? 'Added to wishlist'
                                        : 'Removed from wishlist',
                                  ),
                                  backgroundColor: isInWishlist
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],

                    // Show message if no requests available
                    if (donationProvider
                            .getRequestsByCategory(selectedCategory!)
                            .isEmpty &&
                        donationProvider
                            .getUrgentRequestsByCategory(selectedCategory!)
                            .isEmpty &&
                        donationProvider
                            .getCommunityRequestsByCategory(selectedCategory!)
                            .isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No ${selectedCategory?.toLowerCase()} requests available',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Be the first to create a request!',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ] else
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Text(
                          'Select a category to view requests',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryItem(
    String title,
    IconData icon, {
    bool isSelected = false,
    VoidCallback? onPressed,
  }) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: isSelected ? kPrimaryColor : kSecondaryColor,
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
              color: isSelected ? kPrimaryColor : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
