import 'package:donate_me_app/src/common_widgets/urgent_request_card.dart';
import 'package:donate_me_app/src/constants/constants.dart';
import 'package:donate_me_app/src/common_widgets/community_request_card.dart';
import 'package:donate_me_app/src/providers/auth_provider.dart';
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

  // Sample data for different categories
  final Map<String, List<Map<String, dynamic>>> categoryData = {
    'Blood': [
      {
        'type': 'A- Blood Needed',
        'location': 'Kurunegala',
        'description':
            'Urgent need for A- blood donation to support a medical emergency.',
        'isUrgent': true,
      },
      {
        'type': 'O+ Blood Needed',
        'location': 'Colombo',
        'description': 'Blood donation needed for surgery patient.',
        'isUrgent': true,
      },
      {
        'type': 'B+ Blood Needed',
        'location': 'Kandy',
        'description': 'Regular blood donation needed for thalassemia patient.',
        'isUrgent': false,
      },
    ],
    'Hair': [
      {
        'type': 'Long Hair Donation Needed',
        'location': 'Colombo',
        'description':
            'Urgent: Hair donation needed for cancer patients wigs at Maharagama Cancer Hospital.',
        'isUrgent': true,
      },
      {
        'type': 'Natural Hair Donation',
        'location': 'Kandy',
        'description':
            'Natural hair donation needed for children with alopecia support.',
        'isUrgent': false,
      },
      {
        'type': 'Curly Hair Needed',
        'location': 'Galle',
        'description': 'Specific curly hair type needed for custom wig making.',
        'isUrgent': false,
      },
    ],
    'Kidney': [
      {
        'type': 'Kidney Donor Needed',
        'location': 'Colombo General',
        'description': 'Urgent kidney donation needed for critical patient.',
        'isUrgent': true,
      },
    ],
    'Fund': [
      {
        'type': 'Medical Fund',
        'location': 'Kandy',
        'description': 'Financial support needed for heart surgery.',
        'isUrgent': true,
      },
      {
        'type': 'Education Fund',
        'location': 'Gampaha',
        'description': 'Educational support for underprivileged children.',
        'isUrgent': false,
      },
    ],
  };

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

  // Get category color
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Blood':
        return kBloodColor;
      case 'Hair':
        return Colors.brown;
      case 'Kidney':
        return Colors.green;
      case 'Fund':
        return Colors.orange;
      default:
        return kPrimaryColor;
    }
  }

  // Get filtered data based on selected category
  List<Map<String, dynamic>> getFilteredData() {
    if (selectedCategory == null) {
      return [];
    }
    return categoryData[selectedCategory] ?? [];
  }

  // Get urgent requests for selected category
  List<Map<String, dynamic>> getUrgentRequests() {
    return getFilteredData().where((item) => item['isUrgent'] == true).toList();
  }

  // Get community requests for selected category
  List<Map<String, dynamic>> getCommunityRequests() {
    return getFilteredData()
        .where((item) => item['isUrgent'] == false)
        .toList();
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

  void _navigateToCreatePost(String category) {
    switch (category) {
      case 'Blood':
        context.push(RouterNames.createBloodPost);
        break;
      case 'Hair':
        context.push(RouterNames.createHairPost);
        break;
      case 'Kidney':
        context.push(RouterNames.createKidneyPost);
        break;
      case 'Fund':
        context.push(RouterNames.createFundPost);
        break;
    }
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreatePostDialog(context),
        backgroundColor: kPrimaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          l10n.createRequest,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
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
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Show content only if category is selected
            if (selectedCategory != null) ...[
              // Create Request Button for selected category
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                child: ElevatedButton.icon(
                  onPressed: () => _navigateToCreatePost(selectedCategory!),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: Text(
                    '${l10n.createRequest} ${getLocalizedCategoryName(selectedCategory!, l10n)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getCategoryColor(selectedCategory!),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              // Urgent Requests Section
              if (getUrgentRequests().isNotEmpty) ...[
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
                    itemCount: getUrgentRequests().length,
                    itemBuilder: (context, index) {
                      final request = getUrgentRequests()[index];
                      return Container(
                        width: 200,
                        margin: const EdgeInsets.only(right: 12),
                        child: UrgentRequestCard(
                          type: request['type'],
                          location: request['location'],
                          description: request['description'],
                          category: selectedCategory ?? '',
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
                              'category': selectedCategory ?? '',
                              'isUrgent': true,
                            };

                            wishlistProvider.toggleWishlist(item);

                            // Show feedback to user
                            final isInWishlist = wishlistProvider.isInWishlist(
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
              if (getCommunityRequests().isNotEmpty) ...[
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
                  itemCount: getCommunityRequests().length,
                  itemBuilder: (context, index) {
                    final request = getCommunityRequests()[index];
                    return CommunityRequestCard(
                      type: request['type'],
                      location: request['location'],
                      description: request['description'],
                      category: selectedCategory ?? '',
                      onWishlistToggle: () {
                        final wishlistProvider = Provider.of<WishlistProvider>(
                          context,
                          listen: false,
                        );

                        final item = {
                          'type': request['type'],
                          'location': request['location'],
                          'description': request['description'],
                          'category': selectedCategory ?? '',
                          'isUrgent': false,
                        };

                        wishlistProvider.toggleWishlist(item);

                        // Show feedback to user
                        final isInWishlist = wishlistProvider.isInWishlist(
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
              if (getFilteredData().isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      'No ${selectedCategory?.toLowerCase()} requests available',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ),
                ),
            ] else
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    'Select a category to view requests',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ),
              ),
          ],
        ),
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
