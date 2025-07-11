import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/constants.dart';
import '../../providers/auth_provider.dart';
import '../../services/donation_request_service.dart';
import '../../models/request_models/blood_request_model.dart';
import '../../models/request_models/hair_request_model.dart';
import '../../models/request_models/kidney_request_model.dart';
import '../../models/request_models/fund_request_model.dart';

class MyPostsScreen extends StatefulWidget {
  const MyPostsScreen({super.key});

  @override
  State<MyPostsScreen> createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends State<MyPostsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DonationRequestService _donationService = DonationRequestService();

  List<BloodRequestModel> bloodRequests = [];
  List<HairRequestModel> hairRequests = [];
  List<KidneyRequestModel> kidneyRequests = [];
  List<FundRequestModel> fundRequests = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadUserPosts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserPosts() async {
    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );
    if (authProvider.userModel?.id == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final results = await Future.wait([
        _donationService.getBloodRequestsByUserId(authProvider.userModel!.id),
        _donationService.getHairRequestsByUserId(authProvider.userModel!.id),
        _donationService.getKidneyRequestsByUserId(authProvider.userModel!.id),
        _donationService.getFundRequestsByUserId(authProvider.userModel!.id),
      ]);

      setState(() {
        bloodRequests = results[0] as List<BloodRequestModel>;
        hairRequests = results[1] as List<HairRequestModel>;
        kidneyRequests = results[2] as List<KidneyRequestModel>;
        fundRequests = results[3] as List<FundRequestModel>;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading posts: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,

        title: const Text(
          'My Posts',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: kPrimaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: kPrimaryColor,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          tabs: [
            Tab(text: 'Blood (${bloodRequests.length})'),
            Tab(text: 'Hair (${hairRequests.length})'),
            Tab(text: 'Kidney (${kidneyRequests.length})'),
            Tab(text: 'Fund (${fundRequests.length})'),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildPostsList(bloodRequests, 'blood'),
                _buildPostsList(hairRequests, 'hair'),
                _buildPostsList(kidneyRequests, 'kidney'),
                _buildPostsList(fundRequests, 'fund'),
              ],
            ),
    );
  }

  Widget _buildPostsList<T>(List<T> posts, String type) {
    if (posts.isEmpty) {
      return _buildEmptyState(type);
    }

    return RefreshIndicator(
      onRefresh: _loadUserPosts,
      color: kPrimaryColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return _buildPostCard(post, type);
        },
      ),
    );
  }

  Widget _buildEmptyState(String type) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_getTypeIcon(type), size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No $type donation posts yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first $type donation post',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard<T>(T post, String type) {
    String title = '';
    String subtitle = '';
    String status = '';
    String? urgency;
    DateTime? createdAt;

    // Extract common properties based on type
    if (post is BloodRequestModel) {
      title = 'Blood Type: ${post.bloodGroup}';
      subtitle = '${post.hospital} - ${post.location}';
      status = post.status;
      urgency = post.urgencyLevel;
      createdAt = post.createdAt;
    } else if (post is HairRequestModel) {
      title = 'Hair Length: ${post.minLength}-${post.maxLength}cm';
      subtitle = '${post.contactPerson} - ${post.location}';
      status = post.status;
      urgency = post.urgencyLevel;
      createdAt = post.createdAt;
    } else if (post is KidneyRequestModel) {
      title = 'Blood Type: ${post.bloodGroup}';
      subtitle = '${post.hospital} - ${post.location}';
      status = post.status;
      urgency = post.urgencyLevel;
      createdAt = post.createdAt;
    } else if (post is FundRequestModel) {
      title = 'Amount: \$${post.targetAmount ?? post.amountRequested ?? 0}';
      subtitle = post.reason ?? post.purpose ?? '';
      status = post.status;
      urgency = post.urgencyLevel;
      createdAt = post.createdAt;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          _showPostDetails(post, type);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getTypeColor(type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getTypeIcon(type),
                      color: _getTypeColor(type),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (urgency != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getUrgencyColor(urgency).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _getUrgencyColor(urgency).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        urgency.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _getUrgencyColor(urgency),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    type.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _getTypeColor(type),
                    ),
                  ),
                  const Spacer(),
                  if (createdAt != null)
                    Text(
                      _formatDate(createdAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'approved':
        color = Colors.green;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      case 'rejected':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'blood':
        return Icons.water_drop;
      case 'hair':
        return Icons.content_cut;
      case 'kidney':
        return Icons.favorite;
      case 'fund':
        return Icons.attach_money;
      default:
        return Icons.help;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'blood':
        return Colors.red;
      case 'hair':
        return Colors.brown;
      case 'kidney':
        return kPrimaryColor;
      case 'fund':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _showPostDetails<T>(T post, String type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: _buildPostDetailsContent(post, type, scrollController),
          );
        },
      ),
    );
  }

  Widget _buildPostDetailsContent<T>(
    T post,
    String type,
    ScrollController scrollController,
  ) {
    return Column(
      children: [
        // Handle bar
        Container(
          margin: const EdgeInsets.only(top: 8),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getTypeColor(type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getTypeIcon(type),
                  color: _getTypeColor(type),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${type.toUpperCase()} DONATION REQUEST',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        // Content
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            child: _buildDetailContent(post, type),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailContent<T>(T post, String type) {
    if (post is BloodRequestModel) {
      return _buildBloodDetails(post);
    } else if (post is HairRequestModel) {
      return _buildHairDetails(post);
    } else if (post is KidneyRequestModel) {
      return _buildKidneyDetails(post);
    } else if (post is FundRequestModel) {
      return _buildFundDetails(post);
    }
    return const SizedBox();
  }

  Widget _buildBloodDetails(BloodRequestModel post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Patient Name', post.patientName),
        _buildDetailRow('Blood Type', post.bloodGroup),
        _buildDetailRow('Hospital', post.hospital),
        _buildDetailRow('Location', post.location),
        _buildDetailRow('Units Needed', post.unitsNeeded.toString()),
        _buildDetailRow('Urgency', post.urgencyLevel),
        _buildDetailRow('Contact', post.contactPhone),
        if (post.description.isNotEmpty)
          _buildDetailRow('Description', post.description),
        _buildDetailRow('Status', post.status),
        _buildDetailRow('Created', _formatFullDate(post.createdAt!)),
      ],
    );
  }

  Widget _buildHairDetails(HairRequestModel post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Contact Person', post.contactPerson),
        _buildDetailRow('Hair Length', '${post.minLength}-${post.maxLength}cm'),
        _buildDetailRow('Hair Color', post.hairColor),
        _buildDetailRow('Location', post.location),
        _buildDetailRow('Urgency', post.urgencyLevel),
        _buildDetailRow('Contact', post.contactPhone),
        if (post.description.isNotEmpty)
          _buildDetailRow('Description', post.description),
        _buildDetailRow('Status', post.status),
        _buildDetailRow('Created', _formatFullDate(post.createdAt!)),
      ],
    );
  }

  Widget _buildKidneyDetails(KidneyRequestModel post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Patient Name', post.patientName),
        _buildDetailRow('Blood Type', post.bloodGroup),
        _buildDetailRow('Age', post.patientAge.toString()),
        _buildDetailRow('Hospital', post.hospital),
        _buildDetailRow('Location', post.location),
        _buildDetailRow('Urgency', post.urgencyLevel),
        _buildDetailRow('Contact', post.contactPhone),
        if (post.description.isNotEmpty)
          _buildDetailRow('Description', post.description),
        _buildDetailRow('Status', post.status),
        _buildDetailRow('Created', _formatFullDate(post.createdAt!)),
      ],
    );
  }

  Widget _buildFundDetails(FundRequestModel post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
          'Target Amount',
          '\$${post.targetAmount ?? post.amountRequested ?? 0}',
        ),
        _buildDetailRow('Reason', post.reason ?? post.purpose ?? ''),
        _buildDetailRow('Urgency', post.urgencyLevel),
        _buildDetailRow(
          'Contact',
          post.phone ?? post.organizationContact ?? '',
        ),
        if (post.description.isNotEmpty)
          _buildDetailRow('Description', post.description),
        _buildDetailRow('Status', post.status),
        _buildDetailRow('Created', _formatFullDate(post.createdAt!)),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  String _formatFullDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
