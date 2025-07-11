import 'package:donate_me_app/src/constants/constants.dart';
import 'package:flutter/material.dart';

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
                'Hair Type: ${requestData['hairType'] ?? 'Not specified'}',
          },
          {
            'icon': '🎨',
            'requirement':
                'Hair Color: ${requestData['hairColor'] ?? 'Not specified'}',
          },
          {
            'icon': '📏',
            'requirement':
                'Min Length: ${requestData['minLength'] ?? 'Not specified'} inches',
          },
          {
            'icon': '📦',
            'requirement':
                'Collection: ${requestData['collectionMethod'] ?? 'Not specified'}',
          },
          {
            'icon': '🎯',
            'requirement':
                'Purpose: ${requestData['purpose'] ?? 'Not specified'}',
          },
        ];
      case 'kidney':
        return [
          {
            'icon': '🫘',
            'requirement':
                'Kidney Type: ${requestData['kidneyType'] ?? 'Not specified'}',
          },
          {
            'icon': '🔬',
            'requirement':
                'Stage: ${requestData['kidneyFailureStage'] ?? 'Not specified'}',
          },
          {
            'icon': '💉',
            'requirement':
                'Dialysis: ${requestData['dialysisFrequency'] ?? 'Not specified'}',
          },
          {
            'icon': '🧬',
            'requirement':
                'Blood Group: ${requestData['bloodGroup'] ?? 'Not specified'}',
          },
          {
            'icon': '⚡',
            'requirement':
                'Urgency: ${requestData['urgencyLevel'] ?? 'Not specified'}',
          },
        ];
      case 'fund':
        return [
          {
            'icon': '💰',
            'requirement':
                'Amount Needed: \$${requestData['amountNeeded'] ?? 'Not specified'}',
          },
          {
            'icon': '📄',
            'requirement':
                'Request Type: ${requestData['requestType'] ?? 'Not specified'}',
          },
          {
            'icon': '🏥',
            'requirement':
                'For: ${requestData['patientName'] ?? requestData['beneficiaryName'] ?? 'Not specified'}',
          },
          {
            'icon': '📅',
            'requirement':
                'Deadline: ${requestData['deadline'] ?? 'Not specified'}',
          },
          {
            'icon': '📋',
            'requirement':
                'Purpose: ${requestData['purpose'] ?? 'Not specified'}',
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

  List<String> get requirements {
    switch (type.toLowerCase()) {
      case 'blood':
        return [
          'Age: 18-65 years',
          'Weight: Minimum 50kg',
          'Good health condition',
          'No recent illness or medication',
          'Valid ID required',
          'No alcohol 24 hours before donation',
        ];
      case 'kidney':
        return [
          'Age: 18-70 years',
          'Comprehensive medical evaluation',
          'Psychological assessment',
          'Family consent required',
          'Valid ID and medical records',
          'No history of major diseases',
        ];
      case 'hair':
        return [
          'Age: 18-60 years',
          'Weight: Minimum 55kg',
          'Previous blood donation experience',
          'Good hydration required',
          'Valid ID required',
          'No recent vaccinations',
        ];
      case 'fund':
        return [
          'Age: 18-60 years',
          'Weight: Minimum 50kg',
          'Normal platelet count',
          'No aspirin 48 hours before',
          'Valid ID required',
          'Good health condition',
        ];
      default:
        return [
          'Age: 18-65 years',
          'Good health condition',
          'Valid ID required',
          'Medical clearance if needed',
        ];
    }
  }

  Map<String, String> get contactInfo {
    switch (type.toLowerCase()) {
      case 'blood donation':
        return {
          'coordinator': 'Blood Bank Coordinator',
          'name': 'Dr. Priya Mendis',
          'phone': '+94 77 234 5678',
          'email': 'bloodbank@hospital.lk',
          'time': '24/7 Emergency Available',
        };
      case 'organ donation':
        return {
          'coordinator': 'Organ Transplant Coordinator',
          'name': 'Dr. Kamal Perera',
          'phone': '+94 77 345 6789',
          'email': 'organs@transplant.lk',
          'time': '24/7 Critical Care',
        };
      case 'plasma donation':
        return {
          'coordinator': 'Plasma Center Coordinator',
          'name': 'Dr. Nimal Silva',
          'phone': '+94 77 456 7890',
          'email': 'plasma@medcenter.lk',
          'time': '8:00 AM - 4:00 PM',
        };
      case 'platelet donation':
        return {
          'coordinator': 'Hematology Coordinator',
          'name': 'Dr. Anjali Fernando',
          'phone': '+94 77 567 8901',
          'email': 'platelets@hospital.lk',
          'time': '9:00 AM - 5:00 PM',
        };
      default:
        return {
          'coordinator': 'Medical Coordinator',
          'name': 'Dr. Sarah Johnson',
          'phone': '+94 77 123 4567',
          'email': 'coordinator@hospital.lk',
          'time': '8:00 AM - 6:00 PM',
        };
    }
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
            onPressed: () {
              // Implement share functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {
              // Implement save functionality
            },
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
                  _showDonationConfirmation(context);
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

  void _showDonationConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Confirm Donation',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to donate for "$type"? The coordinator will contact you shortly.',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showSuccessMessage(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Thank you! Your donation request has been submitted.',
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
