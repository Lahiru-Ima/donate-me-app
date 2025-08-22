import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../common_widgets/primary_button.dart';
import '../../models/job_models/job_model.dart';
import '../../models/job_models/job_application_model.dart';
import '../../providers/job_provider.dart';
import '../../providers/auth_provider.dart';

class JobApplicationScreen extends StatefulWidget {
  final JobModel? job;

  const JobApplicationScreen({super.key, required this.job});

  @override
  State<JobApplicationScreen> createState() => _JobApplicationScreenState();
}

class _JobApplicationScreenState extends State<JobApplicationScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  // Form fields
  String _selectedWorkType = 'Full-time (8 hours/day)';
  String _selectedLanguage = 'English';
  String _selectedAvailability = 'Immediately';
  File? _resumeFile;
  bool _isLoading = false;

  final List<String> _workTypes = ['Full-time (8 hours/day)', 'Part-time (4 hours/day)', 'Overnight (10pm - 6am)', 'Flexible hours', 'Weekend only', 'Weekdays only'];

  final List<String> _languages = ['English', 'Sinhala', 'Tamil', 'English & Sinhala', 'English & Tamil', 'All three languages'];

  final List<String> _availabilityOptions = ['Immediately', 'Within 1 week', 'Within 2 weeks', 'Within 1 month', 'Negotiable'];

  @override
  Widget build(BuildContext context) {
    if (widget.job == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Apply for Job')),
        body: const Center(child: Text('Job information not available')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Apply for Job',
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
              // Job Info Card
              _buildJobInfoCard(),

              const SizedBox(height: 24),

              _buildSectionTitle('Personal Information'),
              const SizedBox(height: 16),

              // Full Name
              _buildTextFormField(
                'full_name',
                'Full Name *',
                'Enter your full name',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Phone Number
              _buildTextFormField(
                'phone',
                'Phone Number *',
                'Enter your phone number',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Email
              _buildTextFormField(
                'email',
                'Email Address *',
                'Enter your email address',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email address';
                  }

                  // Improved email validation regex
                  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Please enter a valid email address (e.g., user@example.com)';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Address
              _buildTextFormField(
                'address',
                'Address *',
                'Enter your full address',
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              _buildSectionTitle('Professional Information'),
              const SizedBox(height: 16),

              // Years of Experience
              _buildTextFormField(
                'experience',
                'Years of Experience *',
                'e.g., 3 years',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your experience';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Previous Experience
              _buildTextFormField(
                'previous_experience',
                'Previous Experience *',
                'Describe your previous work experience in caregiving or related fields...',
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please describe your previous experience';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Skills & Qualifications
              _buildTextFormField(
                'skills',
                'Skills & Qualifications *',
                'List your relevant skills, certifications, and qualifications (separate with commas)',
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please list your skills';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              _buildSectionTitle('Work Preferences'),
              const SizedBox(height: 16),

              // Preferred Work Type
              _buildDropdownField('Preferred Work Type *', _selectedWorkType, _workTypes, (value) => setState(() => _selectedWorkType = value!)),

              const SizedBox(height: 16),

              // Language Proficiency
              _buildDropdownField('Language Proficiency *', _selectedLanguage, _languages, (value) => setState(() => _selectedLanguage = value!)),

              const SizedBox(height: 16),

              // Availability
              _buildDropdownField('Availability *', _selectedAvailability, _availabilityOptions, (value) => setState(() => _selectedAvailability = value!)),

              const SizedBox(height: 16),

              // Expected Salary
              _buildTextFormField(
                'expected_salary',
                'Expected Salary *',
                'e.g., Rs. 40,000 - 50,000',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your expected salary';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              _buildSectionTitle('Documents'),
              const SizedBox(height: 16),

              // Resume Upload
              _buildFileUploadField('Resume/CV *', 'Upload your resume or CV', _resumeFile, () => _pickFile()),

              const SizedBox(height: 24),

              _buildSectionTitle('Additional Information'),
              const SizedBox(height: 16),

              // Why should we hire you
              _buildTextFormField(
                'why_hire',
                'Why should we hire you? *',
                'Explain why you are the best candidate for this position...',
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please explain why we should hire you';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(press: _isLoading ? null : _submitApplication, text: _isLoading ? 'Processing Application...' : 'Submit Application'),
              ),

              // Loading Indicator
              if (_isLoading)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!))),
                      const SizedBox(width: 12),
                      Text(
                        'Please wait while we process your application...',
                        style: TextStyle(fontSize: 14, color: Colors.blue[600], fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // Application Guidelines
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.tips_and_updates, color: Colors.green[600], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Application Tips',
                          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.green[700]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Be honest and accurate in your application\n'
                      '• Highlight relevant experience and skills\n'
                      '• Upload clear and readable documents\n'
                      '• Show genuine interest in caregiving\n'
                      '• Follow up professionally after applying',
                      style: TextStyle(fontSize: 14, color: Colors.green[600], height: 1.4),
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

  Widget _buildJobInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Applying for:',
              style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              widget.job?.title ?? 'Job Title',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 4),
            Text('${widget.job?.type ?? 'Job Type'} • ${widget.job?.location ?? 'Location'}', style: TextStyle(fontSize: 14, color: Colors.blue[600])),
            const SizedBox(height: 8),
            Text(
              widget.job?.salary ?? 'Salary not specified',
              style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  Widget _buildTextFormField(String name, String label, String hint, {int maxLines = 1, TextInputType keyboardType = TextInputType.text, String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        FormBuilderTextField(
          name: name,
          maxLines: maxLines,
          keyboardType: keyboardType,
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> options, void Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
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

  Widget _buildFileUploadField(String label, String hint, File? file, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: file != null ? Colors.green[300]! : Colors.grey[300]!, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(12),
              color: file != null ? Colors.green[50] : Colors.white,
            ),
            child: Row(
              children: [
                Icon(file != null ? Icons.check_circle : Icons.upload_file, color: file != null ? Colors.green[600] : Colors.grey[600]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    file != null ? file.path.split('/').last : hint,
                    style: TextStyle(color: file != null ? Colors.green[700] : Colors.grey[600], fontWeight: file != null ? FontWeight.w500 : FontWeight.normal),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickFile() async {
    try {
      // Show dialog to choose between different file sources
      final String? source = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select File Source'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take Photo'),
                  subtitle: const Text('Capture document with camera'),
                  onTap: () => Navigator.of(context).pop('camera'),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Gallery'),
                  subtitle: const Text('Select image from gallery'),
                  onTap: () => Navigator.of(context).pop('gallery'),
                ),
                ListTile(leading: const Icon(Icons.description), title: const Text('Browse Files'), subtitle: const Text('Select PDF or document'), onTap: () => Navigator.of(context).pop('files')),
              ],
            ),
          );
        },
      );

      if (source != null) {
        File? selectedFile;

        if (source == 'camera' || source == 'gallery') {
          // Use ImagePicker for camera and gallery
          final ImagePicker picker = ImagePicker();
          final ImageSource imageSource = source == 'camera' ? ImageSource.camera : ImageSource.gallery;

          final XFile? pickedFile = await picker.pickImage(source: imageSource);

          if (pickedFile != null) {
            selectedFile = File(pickedFile.path);
          }
        } else if (source == 'files') {
          // Use FilePicker for documents
          FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'jpg', 'jpeg', 'png'], allowMultiple: false);

          if (result != null && result.files.single.path != null) {
            selectedFile = File(result.files.single.path!);
          }
        }

        if (selectedFile != null) {
          setState(() {
            _resumeFile = selectedFile;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error picking file: $e'), backgroundColor: Colors.red));
    }
  }

  Future<String?> uploadFileAndGetUrl(File file) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      final userId = user?.id ?? '';

      // Create a unique filename with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileExtension = file.path.split('.').last.toLowerCase();
      final fileName = 'resume_${userId}_$timestamp.$fileExtension';

      // Determine folder based on file type
      String folder;
      List<String> imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
      List<String> documentExtensions = ['pdf', 'doc', 'docx', 'txt', 'rtf'];

      if (imageExtensions.contains(fileExtension)) {
        folder = 'images';
      } else if (documentExtensions.contains(fileExtension)) {
        folder = 'files';
      } else {
        // Default to files folder for unknown extensions
        folder = 'files';
      }

      final path = '$folder/$fileName';

      // Upload file
      await Supabase.instance.client.storage.from('avatars').upload(path, file, fileOptions: FileOptions(upsert: true));

      // Get public URL
      final publicUrl = Supabase.instance.client.storage.from('avatars').getPublicUrl(path);

      return publicUrl;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error uploading resume: ${e.toString()}'), backgroundColor: Colors.red));
      }
      return null;
    }
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.saveAndValidate()) {
      return;
    }

    // if (_resumeFile == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Please upload your resume/CV'),
    //       backgroundColor: Colors.red,
    //     ),
    //   );
    //   return;
    // }

    if (widget.job?.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job information is not available'), backgroundColor: Colors.red));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    final jobProvider = Provider.of<JobProvider>(context, listen: false);

    if (authProvider.userModel?.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User not authenticated'), backgroundColor: Colors.red));
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Check if user has already applied for this job
      final existingApplication = await jobProvider.checkExistingApplication(authProvider.userModel!.id, widget.job!.id!);

      if (existingApplication) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You have already applied for this job'), backgroundColor: Colors.orange));
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Upload files if they exist
      List<String> uploadedFiles = [];

      if (_resumeFile != null) {
        setState(() {
          _isLoading = true;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Uploading resume...'), backgroundColor: Colors.blue));
        }

        final resumeUrl = await uploadFileAndGetUrl(_resumeFile!);
        if (resumeUrl != null) {
          uploadedFiles.add('Resume: $resumeUrl');
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Submitting application...'), backgroundColor: Colors.blue));
      }

      final formData = _formKey.currentState!.fields;

      // Get form values with null safety
      final fullName = formData['full_name']?.value?.toString() ?? '';
      final phone = formData['phone']?.value?.toString() ?? '';
      final email = formData['email']?.value?.toString() ?? '';
      final address = formData['address']?.value?.toString() ?? '';
      final experience = formData['experience']?.value?.toString() ?? '';
      final previousExperience = formData['previous_experience']?.value?.toString() ?? '';
      final skillsString = formData['skills']?.value?.toString() ?? '';
      final expectedSalary = formData['expected_salary']?.value?.toString() ?? '';
      final whyHire = formData['why_hire']?.value?.toString() ?? '';

      // Convert skills string to list
      List<String> skillsList = skillsString.isNotEmpty ? skillsString.split(',').map((skill) => skill.trim()).where((skill) => skill.isNotEmpty).toList() : [];

      final applicationData = JobApplicationModel(
        jobId: widget.job!.id!,
        applicantUserId: authProvider.userModel!.id,
        fullName: fullName,
        email: email,
        phone: phone,
        address: address,
        experience: '$experience years of experience. $previousExperience',
        skills: skillsList,
        availability: _selectedAvailability,
        motivation: whyHire,
        emergencyContact: phone,
        emergencyPhone: phone,
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        previousEmployment: '',
        healthConditions: '',
        hasTransportation: false,
        additionalNotes:
            'Preferred work type: $_selectedWorkType. Language proficiency: $_selectedLanguage. Expected salary: $expectedSalary. ${uploadedFiles.isNotEmpty ? "Uploaded files: ${uploadedFiles.join(", ")}" : ""}',
      );

      final success = await jobProvider.submitJobApplication(applicationData);

      if (success) {
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Application submitted successfully!'), backgroundColor: Colors.green));

          // Navigate back
          Navigator.pop(context);
        }
      } else {
        // Show error message with better formatting
        if (mounted) {
          String errorMessage = jobProvider.error ?? 'Unknown error occurred';

          // Check for specific database constraint errors
          if (errorMessage.contains('chk_email_format')) {
            errorMessage = 'Invalid email format. Please enter a valid email address.';
          } else if (errorMessage.contains('unique_user_job_application')) {
            errorMessage = 'You have already applied for this job.';
          } else if (errorMessage.contains('check constraint')) {
            errorMessage = 'One or more fields contain invalid data. Please check your entries.';
          }

          print('Job application error: ${jobProvider.error}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error submitting application: $errorMessage'), backgroundColor: Colors.red, duration: const Duration(seconds: 5)));
        }
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = e.toString();

        // Check for specific database constraint errors in catch block too
        if (errorMessage.contains('chk_email_format')) {
          errorMessage = 'Invalid email format. Please enter a valid email address.';
        } else if (errorMessage.contains('unique_user_job_application')) {
          errorMessage = 'You have already applied for this job.';
        } else if (errorMessage.contains('check constraint')) {
          errorMessage = 'One or more fields contain invalid data. Please check your entries.';
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error submitting application: $errorMessage'), backgroundColor: Colors.red, duration: const Duration(seconds: 5)));
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
