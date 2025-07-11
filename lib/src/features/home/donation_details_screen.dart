import 'package:donate_me_app/src/constants/constants.dart';
import 'package:donate_me_app/src/router/router_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DonationDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> requestData;

  const DonationDetailsScreen({super.key, required this.requestData});

  String get type => requestData['type'] ?? 'Unknown';
  String get location => requestData['location'] ?? 'Unknown Location';
  String get description =>
      requestData['description'] ?? 'No description available';
  bool get isUrgent => requestData['is_emergency'] ?? false;
  String get category => requestData['category'] ?? 'Unknown';
  String get id => requestData['id'] ?? '';

  List<Map<String, String>> get dynamicRequirements {
    switch (category.toLowerCase()) {
      case 'blood':
        return [
          {
            'icon': '🩸',
            'requirement':
                'Blood Group: ${requestData['blood_group'] ?? 'Not specified'}',
          },
          {
            'icon': '🏥',
            'requirement':
                'Hospital: ${requestData['hospital'] ?? 'Not specified'}',
          },
          {
            'icon': '👤',
            'requirement':
                'Patient: ${requestData['patient_name'] ?? 'Not specified'}',
          },
          {
            'icon': '📅',
            'requirement':
                'Age: ${requestData['patient_age'] ?? 'Not specified'}',
          },
          {
            'icon': '🍽️',
            'requirement':
                'Medical Condition: ${requestData['medical_condition'] ?? 'Not specified'}',
          },
        ];
      case 'hair':
        return [
          {
            'icon': '✂️',
            'requirement':
                'Hair Type: ${requestData['hair_type'] ?? 'Not specified'}',
          },
          {
            'icon': '🎨',
            'requirement':
                'Hair Color: ${requestData['hair_color'] ?? 'Not specified'}',
          },
          {
            'icon': '📏',
            'requirement':
                'Min Length: ${requestData['min_length'] ?? 'Not specified'} inches',
          },
          {
            'icon': '📦',
            'requirement':
                'Collection: ${requestData['collection_method'] ?? 'Not specified'}',
          },
          {
            'icon': '🎯',
            'requirement':
                'Purpose: ${requestData['purpose_category'] ?? 'Not specified'}',
          },
        ];
      case 'kidney':
        return [
          {
            'icon': '🫘',
            'requirement':
                'Kidney Type: ${requestData['blood_group'] ?? 'Not specified'}',
          },
          {
            'icon': '🔬',
            'requirement':
                'Stage: ${requestData['kidney_failure_stage'] ?? 'Not specified'}',
          },
          {
            'icon': '💉',
            'requirement':
                'Dialysis: ${requestData['dialysis_history'] ?? 'Not specified'}',
          },
          {
            'icon': '🧬',
            'requirement':
                'Blood Group: ${requestData['blood_group'] ?? 'Not specified'}',
          },
          {
            'icon': '⚡',
            'requirement':
                'Urgency: ${requestData['urgency_level'] ?? 'Not specified'}',
          },
        ];
      case 'fund':
        return [
          {
            'icon': '💰',
            'requirement':
                'Amount Needed: LKR ${requestData['amount_requested'] ?? requestData['target_amount'] ?? 'Not specified'}',
          },
          {
            'icon': '📄',
            'requirement':
                'Request Type: ${requestData['request_type'] ?? 'Not specified'}',
          },
          {
            'icon': '🏥',
            'requirement':
                'For: ${requestData['full_name'] ?? requestData['beneficiary'] ?? requestData['organization'] ?? 'Not specified'}',
          },
          {
            'icon': '📅',
            'requirement':
                'Deadline: ${requestData['timeline'] ?? 'Not specified'}',
          },
          {
            'icon': '📋',
            'requirement':
                'Purpose: ${requestData['purpose'] ?? requestData['reason'] ?? requestData['fund_category'] ?? requestData['charity_category'] ?? 'Not specified'}',
          },
        ];
      default:
        return [
          {'icon': '❓', 'requirement': 'No specific requirements available'},
        ];
    }
  }

  Map<String, String> get dynamicContactInfo {
    return {
      'coordinator': '$category Request Coordinator',
      'name': requestData['contact_person'] ?? 'Contact Person',
      'phone': requestData['contact_phone'] ?? '+94 77 XXX XXXX',
      'email': requestData['contact_email'] ?? 'contact@donate.lk',
      'time': isUrgent ? 'Urgent - Call Anytime' : 'Available 8 AM - 6 PM',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Donation Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isUrgent ? Colors.red[50] : Colors.blue[50],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isUrgent ? 'URGENT' : 'REGULAR',
                          style: TextStyle(
                            color: isUrgent
                                ? Colors.red[700]
                                : Colors.blue[700],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          category.toUpperCase(),
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    type,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 18,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        location,
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Description Section
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Requirements Section
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Requirements',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...dynamicRequirements.map(
                    (requirement) => _buildDynamicRequirementItem(requirement),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Contact Information
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildContactItem(
                    Icons.person,
                    dynamicContactInfo['coordinator']!,
                    dynamicContactInfo['name']!,
                  ),
                  _buildContactItem(
                    Icons.phone,
                    'Phone Number',
                    dynamicContactInfo['phone']!,
                  ),
                  _buildContactItem(
                    Icons.email,
                    'Email',
                    dynamicContactInfo['email']!,
                  ),
                  _buildContactItem(
                    Icons.access_time,
                    'Available Time',
                    dynamicContactInfo['time']!,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100), // Space for fixed bottom buttons
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // Implement call functionality
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: kPrimaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone, color: kPrimaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'Call',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  _navigateToCategory(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'I Want to Donate',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
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

    final route = routeMap[category.toLowerCase()];
    if (route != null) {
      context.push(
        route,
        extra: {
          'donationRequestId': id, // Pass the donation request ID
          'type': type,
          'location': location,
          'description': description,
          'category': category,
          'isUrgent': isUrgent,
          'id': id,
          ...requestData,
        },
      );
    }
  }

  Widget _buildDynamicRequirementItem(Map<String, String> requirement) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            requirement['icon'] ?? '✓',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              requirement['requirement'] ?? 'No requirement specified',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
