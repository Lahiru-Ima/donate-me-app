import 'package:donate_me_app/src/router/router_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/primary_button.dart';
import '../../providers/job_provider.dart';
import '../../models/job_models/job_model.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch jobs when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JobProvider>().fetchJobs();
    });
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
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.search),
        //     onPressed: () => _showSearchDialog(context),
        //   ),
        // ],
      ),
      body: Consumer<JobProvider>(
        builder: (context, jobProvider, child) {
          return Column(
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
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildFilterDropdown(
                            'Job Type',
                            jobProvider.selectedType,
                            jobProvider.jobTypes,
                            (value) => jobProvider.setTypeFilter(value!),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildFilterDropdown(
                            'Location',
                            jobProvider.selectedLocation,
                            jobProvider.locations,
                            (value) => jobProvider.setLocationFilter(value!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text(
                              'Urgent Hiring Only',
                              style: TextStyle(fontSize: 14),
                            ),
                            value: jobProvider.urgentOnly,
                            onChanged: (value) =>
                                jobProvider.toggleUrgentFilter(),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        TextButton(
                          onPressed: () => jobProvider.clearFilters(),
                          child: const Text('Clear Filters'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Jobs List
              Expanded(child: _buildJobsList(jobProvider)),
            ],
          );
        },
      ),
    );
  }

  // void _showSearchDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       final TextEditingController searchController = TextEditingController();
  //       return AlertDialog(
  //         title: const Text('Search Jobs'),
  //         content: TextField(
  //           controller: searchController,
  //           decoration: const InputDecoration(
  //             hintText: 'Enter keywords...',
  //             border: OutlineInputBorder(),
  //           ),
  //           autofocus: true,
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text('Cancel'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               context.read<JobProvider>().setSearchKeyword(
  //                 searchController.text,
  //               );
  //               context.read<JobProvider>().searchJobs();
  //               Navigator.pop(context);
  //             },
  //             child: const Text('Search'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget _buildJobsList(JobProvider jobProvider) {
    if (jobProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (jobProvider.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: Colors.red[400]),
              const SizedBox(height: 16),
              Text(
                'Error loading jobs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                jobProvider.error!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => jobProvider.fetchJobs(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (jobProvider.jobs.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: jobProvider.jobs.length,
      itemBuilder: (context, index) {
        final job = jobProvider.jobs[index];
        return _buildJobCard(context, job);
      },
    );
  }
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

Widget _buildJobCard(BuildContext context, JobModel job) {
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
                            job.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (job.urgentHiring)
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
                      job.type,
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
          _buildDetailRow(Icons.location_on, job.location),
          _buildDetailRow(Icons.access_time, job.workHours),
          _buildDetailRow(Icons.payments, job.salary),
          _buildDetailRow(
            Icons.person,
            '${job.preferredGender}, ${job.preferredAge}',
          ),

          const SizedBox(height: 12),

          // Skills
          if (job.requiredSkills.isNotEmpty) ...[
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
              children: job.requiredSkills.map<Widget>((skill) {
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
            job.description,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
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
                    'Posted by ${job.contactPerson}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Text(
                    job.createdAt != null
                        ? '${DateTime.now().difference(job.createdAt!).inDays} days ago'
                        : 'Recently posted',
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
