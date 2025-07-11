import 'package:donate_me_app/l10n/app_localizations.dart';
import 'package:donate_me_app/src/common_widgets/donation_request_card.dart';
import 'package:donate_me_app/src/constants/constants.dart';
import 'package:donate_me_app/src/constants/donation_category.dart';
import 'package:donate_me_app/src/models/request_models/donation_request_model.dart';
import 'package:donate_me_app/src/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:donate_me_app/src/providers/donation_request_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'blood';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load initial data after the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DonationRequestProvider>().loadCategory(selectedCategory);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthenticationProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(authProvider, l10n),
      floatingActionButton: _buildFAB(),
      body: Consumer<DonationRequestProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: provider.refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategoriesSection(l10n),
                  const SizedBox(height: 24),
                  _buildContentSection(provider, l10n),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(
    AuthenticationProvider authProvider,
    AppLocalizations l10n,
  ) {
    return AppBar(
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
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                l10n.makeDifference,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          _buildSearchButton(),
        ],
      ),
    );
  }

  Widget _buildSearchButton() {
    return InkWell(
      onTap: () {
        // TODO: Implement search functionality
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.search, color: Colors.white),
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () => _showCreatePostDialog(context),
      backgroundColor: kPrimaryColor,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  Widget _buildCategoriesSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.categories,
          style: const TextStyle(
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
            children: DonationCategories.categories.map((category) {
              return _buildCategoryItem(
                category,
                l10n,
                isSelected: selectedCategory == category.id,
                onPressed: () => _onCategorySelected(category.id),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(
    DonationCategory category,
    AppLocalizations l10n, {
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
            child: Center(
              child: Icon(category.icon, size: 40, color: Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getLocalizedCategoryName(category.id, l10n),
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

  Widget _buildContentSection(
    DonationRequestProvider provider,
    AppLocalizations l10n,
  ) {
    if (provider.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: CircularProgressIndicator(color: kPrimaryColor),
        ),
      );
    }

    if (provider.error != null) {
      return _buildErrorState(provider, l10n);
    }

    final urgentRequests = provider.getUrgentRequests(selectedCategory);
    final communityRequests = provider.getCommunityRequests(selectedCategory);

    if (urgentRequests.isEmpty && communityRequests.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (urgentRequests.isNotEmpty) ...[
          _buildUrgentSection(urgentRequests, l10n),
          const SizedBox(height: 24),
        ],
        if (communityRequests.isNotEmpty)
          _buildCommunitySection(communityRequests, l10n),
      ],
    );
  }

  Widget _buildErrorState(
    DonationRequestProvider provider,
    AppLocalizations l10n,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
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
              provider.error!,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                provider.clearError();
                provider.loadCategory(selectedCategory);
              },
              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No ${selectedCategory.toLowerCase()} requests available',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to create a request!',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUrgentSection(
    List<DonationRequestModel> requests,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.urgentRequests,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: requests.length,
            itemBuilder: (context, index) {
              return DonationRequestCard.urgent(
                request: requests[index],
                onWishlistToggle: () {
                  // Optional callback for additional feedback
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCommunitySection(
    List<DonationRequestModel> requests,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.communityRequests,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            return DonationRequestCard.community(
              request: requests[index],
              onWishlistToggle: () {
                // Optional callback for additional feedback
              },
            );
          },
        ),
      ],
    );
  }

  void _onCategorySelected(String categoryId) {
    setState(() {
      selectedCategory = categoryId;
    });
    context.read<DonationRequestProvider>().loadCategory(categoryId);
  }

  String _getLocalizedCategoryName(String categoryId, AppLocalizations l10n) {
    switch (categoryId) {
      case 'blood':
        return l10n.blood;
      case 'hair':
        return l10n.hair;
      case 'kidney':
        return l10n.kidney;
      case 'fund':
        return l10n.fund;
      default:
        return categoryId;
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
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'What type of donation request would you like to create?',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ...DonationCategories.categories.map(
                (category) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildCreatePostOption(
                    context,
                    category,
                    'Request ${category.name.toLowerCase()} donation',
                    () => context.push(category.route),
                  ),
                ),
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
    DonationCategory category,
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
          color: category.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: category.color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: category.color,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(category.icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
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
}
