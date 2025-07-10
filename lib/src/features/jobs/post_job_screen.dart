import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../../common_widgets/primary_button.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  // Form fields
  String _selectedJobType = 'Elderly Care';
  String _selectedLocation = 'Colombo';
  String _selectedWorkHours = 'Full-time (8 hours/day)';
  String _selectedGender = 'Any';
  String _selectedAgeRange = '18-65';
  bool _isUrgentHiring = false;
  bool _isLoading = false;

  final List<String> _jobTypes = [
    'Elderly Care',
    'Child Care',
    'Disability Support',
    'Medical Care',
    'Companion Care',
    'Overnight Care',
    'Housekeeping',
    'Personal Assistant',
  ];

  final List<String> _locations = [
    'Colombo',
    'Gampaha',
    'Kalutara',
    'Kandy',
    'Galle',
    'Matara',
    'Kurunegala',
    'Anuradhapura',
    'Polonnaruwa',
    'Badulla',
    'Ratnapura',
    'Kegalle',
    'Puttalam',
    'Hambantota',
    'Monaragala',
    'Vavuniya',
    'Batticaloa',
    'Ampara',
    'Trincomalee',
    'Jaffna',
    'Kilinochchi',
    'Mannar',
    'Mullaitivu',
  ];

  final List<String> _workHours = [
    'Full-time (8 hours/day)',
    'Part-time (4 hours/day)',
    'Overnight (10pm - 6am)',
    'Flexible hours',
    'Weekend only',
    'Weekdays only',
  ];

  final List<String> _genderOptions = ['Any', 'Male', 'Female'];

  final List<String> _ageRanges = ['18-30', '25-40', '30-50', '25-55', '18-65'];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Post a Job',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: FormBuilder(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Job Details'),
              const SizedBox(height: 16),

              // Job Title
              _buildTextFormField(
                'job_title',
                'Job Title *',
                'e.g., Elderly Care Assistant',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a job title';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Job Type
              _buildDropdownField(
                'Job Type *',
                _selectedJobType,
                _jobTypes,
                (value) => setState(() => _selectedJobType = value!),
              ),

              const SizedBox(height: 16),

              // Location
              _buildDropdownField(
                'Location *',
                _selectedLocation,
                _locations,
                (value) => setState(() => _selectedLocation = value!),
              ),

              const SizedBox(height: 16),

              // Work Hours
              _buildDropdownField(
                'Work Hours *',
                _selectedWorkHours,
                _workHours,
                (value) => setState(() => _selectedWorkHours = value!),
              ),

              const SizedBox(height: 16),

              // Salary
              _buildTextFormField(
                'salary',
                'Salary Range *',
                'e.g., Rs. 45,000 - 55,000',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter salary range';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              _buildSectionTitle('Requirements'),
              const SizedBox(height: 16),

              // Required Skills
              _buildTextFormField(
                'skills',
                'Required Skills *',
                'e.g., First Aid, Patient Care, Communication (separate with commas)',
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter required skills';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Preferred Gender
              _buildDropdownField(
                'Preferred Gender',
                _selectedGender,
                _genderOptions,
                (value) => setState(() => _selectedGender = value!),
              ),

              const SizedBox(height: 16),

              // Preferred Age Range
              _buildDropdownField(
                'Preferred Age Range',
                _selectedAgeRange,
                _ageRanges,
                (value) => setState(() => _selectedAgeRange = value!),
              ),

              const SizedBox(height: 24),

              _buildSectionTitle('Job Description'),
              const SizedBox(height: 16),

              // Description
              _buildTextFormField(
                'description',
                'Job Description *',
                'Provide detailed description of the job responsibilities, requirements, and working conditions...',
                maxLines: 6,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter job description';
                  }
                  if (value.trim().length < 50) {
                    return 'Description should be at least 50 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              _buildSectionTitle('Additional Options'),
              const SizedBox(height: 16),

              // Urgent Hiring Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _isUrgentHiring,
                    onChanged: (value) {
                      setState(() {
                        _isUrgentHiring = value ?? false;
                      });
                    },
                    activeColor: Colors.red[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Mark as urgent hiring',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),

              if (_isUrgentHiring)
                Padding(
                  padding: const EdgeInsets.only(left: 40, top: 4),
                  child: Text(
                    'This will highlight your job posting and show it at the top of search results.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  press: _isLoading ? null : _submitJob,
                  text: _isLoading ? 'Posting Job...' : 'Post Job',
                ),
              ),

              const SizedBox(height: 16),

              // Guidelines
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Posting Guidelines',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Be honest and accurate in your job description\n'
                      '• Specify clear requirements and expectations\n'
                      '• Respect privacy and dignity of applicants\n'
                      '• Respond to applications in a timely manner\n'
                      '• Follow fair hiring practices',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[600],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextFormField(
    String name,
    String label,
    String hint, {
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        FormBuilderTextField(
          name: name,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    String value,
    List<String> options,
    void Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: options.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(option, style: const TextStyle(fontSize: 16)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submitJob() async {
    if (!_formKey.currentState!.saveAndValidate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // final formData = _formKey.currentState!.value;

      // TODO: Submit job to Supabase database
      // final jobData = {
      //   'title': formData['job_title'],
      //   'type': _selectedJobType,
      //   'location': _selectedLocation,
      //   'work_hours': _selectedWorkHours,
      //   'salary': formData['salary'],
      //   'skills': formData['skills'],
      //   'preferred_gender': _selectedGender,
      //   'preferred_age': _selectedAgeRange,
      //   'description': formData['description'],
      //   'urgent_hiring': _isUrgentHiring,
      // };

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Job posted successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error posting job: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
