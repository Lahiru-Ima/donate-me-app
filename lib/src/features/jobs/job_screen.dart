import 'package:donate_me_app/src/router/router_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common_widgets/primary_button.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  String selectedJobType = 'All';
  String selectedLocation = 'All';

  final List<String> jobTypes = [
    'All',
    'Elderly Care',
    'Child Care',
    'Disability Support',
    'Medical Care',
    'Companion Care',
    'Overnight Care',
  ];

  final List<String> locations = [
    'All',
    'Colombo',
    'Gampaha',
    'Kalutara',
    'Kandy',
    'Galle',
    'Matara',
    'Kurunegala',
    'Anuradhapura',
  ];

  // Sample job data - in real app, this would come from Supabase
  List<Map<String, dynamic>> get jobs => [
    {
      'id': '1',
      'title': 'Elderly Care Assistant',
      'type': 'Elderly Care',
      'location': 'Colombo',
      'workHours': 'Full-time (8 hours/day)',
      'salary': 'Rs. 45,000 - 55,000',
      'requiredSkills': ['First Aid', 'Patient Care', 'Communication'],
      'preferredGender': 'Female',
      'preferredAge': '25-45',
      'description':
          'Looking for a compassionate caregiver to assist elderly patient with daily activities, medication management, and companionship.',
      'postedBy': 'Sarah Fernando',
      'postedDate': '2 days ago',
      'urgentHiring': true,
    },
    {
      'id': '2',
      'title': 'Child Care Specialist',
      'type': 'Child Care',
      'location': 'Gampaha',
      'workHours': 'Part-time (4 hours/day)',
      'salary': 'Rs. 25,000 - 35,000',
      'requiredSkills': [
        'Child Development',
        'Activity Planning',
        'Safety Awareness',
      ],
      'preferredGender': 'Any',
      'preferredAge': '22-40',
      'description':
          'Seeking a caring individual to provide after-school care for two children aged 6 and 9. Activities include homework help and recreational activities.',
      'postedBy': 'Rajesh Kumar',
      'postedDate': '1 week ago',
      'urgentHiring': false,
    },
    {
      'id': '3',
      'title': 'Disability Support Worker',
      'type': 'Disability Support',
      'location': 'Kandy',
      'workHours': 'Flexible',
      'salary': 'Rs. 40,000 - 50,000',
      'requiredSkills': [
        'Disability Care',
        'Mobility Assistance',
        'Personal Care',
      ],
      'preferredGender': 'Male',
      'preferredAge': '25-50',
      'description':
          'Supporting an adult with physical disabilities in daily living activities, mobility assistance, and community participation.',
      'postedBy': 'Nimal Perera',
      'postedDate': '3 days ago',
      'urgentHiring': true,
    },
    {
      'id': '4',
      'title': 'Overnight Care Nurse',
      'type': 'Overnight Care',
      'location': 'Galle',
      'workHours': 'Night shift (10pm - 6am)',
      'salary': 'Rs. 50,000 - 65,000',
      'requiredSkills': [
        'Nursing Experience',
        'Emergency Response',
        'Medication Management',
      ],
      'preferredGender': 'Any',
      'preferredAge': '25-55',
      'description':
          'Providing overnight care for elderly patient with medical conditions. Must be comfortable with night shifts and emergency situations.',
      'postedBy': 'Priya Jayawardena',
      'postedDate': '5 days ago',
      'urgentHiring': false,
    },
  ];

  List<Map<String, dynamic>> get filteredJobs {
    return jobs.where((job) {
      final typeMatch =
          selectedJobType == 'All' ||
          selectedJobType == 'Select Job Type' ||
          job['type'] == selectedJobType;
      final locationMatch =
          selectedLocation == 'All' ||
          selectedLocation == 'Select Location' ||
          job['location'] == selectedLocation;
      return typeMatch && locationMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Caregiver Jobs',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: Column(
        children: [
          // Post Job Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: PrimaryButton(
              text: 'Post a Job Vacancy',
              press: () {
                context.push(RouterNames.postJob);
              },
            ),
          ),

          // Filters
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: _buildFilterDropdown(
                    'Job Type',
                    selectedJobType,
                    jobTypes,
                    (value) => setState(() => selectedJobType = value!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFilterDropdown(
                    'Location',
                    selectedLocation,
                    locations,
                    (value) => setState(() => selectedLocation = value!),
                  ),
                ),
              ],
            ),
          ),

          // Jobs List
          Expanded(
            child: filteredJobs.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredJobs.length,
                    itemBuilder: (context, index) {
                      final job = filteredJobs[index];
                      return _buildJobCard(job);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(
    String label,
    String value,
    List<String> options,
    void Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(label),
          items: options.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              job['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          if (job['urgentHiring'])
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'URGENT',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[700],
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job['type'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Job Details
            _buildDetailRow(Icons.location_on, job['location']),
            _buildDetailRow(Icons.access_time, job['workHours']),
            _buildDetailRow(Icons.payments, job['salary']),
            _buildDetailRow(
              Icons.person,
              '${job['preferredGender']}, ${job['preferredAge']} years',
            ),

            const SizedBox(height: 12),

            // Skills
            if (job['requiredSkills'].isNotEmpty) ...[
              const Text(
                'Required Skills:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: job['requiredSkills'].map<Widget>((skill) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Text(
                      skill,
                      style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
            ],

            // Description
            Text(
              job['description'],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 12),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Posted by ${job['postedBy']}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      job['postedDate'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    context.push(RouterNames.jobApplication, extra: job);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work_off, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No jobs found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or check back later for new opportunities.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
