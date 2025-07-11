import 'package:donate_me_app/src/constants/constants.dart';
import 'package:donate_me_app/src/models/request_models/kidney_request_model.dart';
import 'package:donate_me_app/src/providers/auth_provider.dart';
import 'package:donate_me_app/src/providers/donation_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateKidneyPostScreen extends StatefulWidget {
  const CreateKidneyPostScreen({super.key});

  @override
  State<CreateKidneyPostScreen> createState() => _CreateKidneyPostScreenState();
}

class _CreateKidneyPostScreenState extends State<CreateKidneyPostScreen> {
  final _formKey = GlobalKey<FormState>();

  // Request Information
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _hospitalController = TextEditingController();

  // Patient Information
  final _patientNameController = TextEditingController();
  final _patientAgeController = TextEditingController();
  String _selectedBloodGroup = '';
  String _selectedGender = '';
  String _kidneyFailureStage = '';

  // Medical Information
  final _medicalConditionController = TextEditingController();
  final _doctorNameController = TextEditingController();
  final _hospitalIdController = TextEditingController();
  final _dialysisHistoryController = TextEditingController();
  String _donationType = '';

  // Urgency and Timeline
  String _urgencyLevel = '';
  final _timelineController = TextEditingController();
  bool _onDialysis = false;
  final _dialysisFrequencyController = TextEditingController();

  // Compatibility Requirements
  final _compatibilityNotesController = TextEditingController();
  bool _crossMatchRequired = true;

  // Contact Information
  final _contactPersonController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _contactEmailController = TextEditingController();

  // Additional Information
  final _familyHistoryController = TextEditingController();
  final _additionalNotesController = TextEditingController();
  bool _isEmergency = false;

  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _urgencyLevels = ['Low', 'Medium', 'High', 'Critical'];
  final List<String> _kidneyFailureStages = [
    'Stage 3 (Moderate)',
    'Stage 4 (Severe)',
    'Stage 5 (End-stage)',
    'Acute Kidney Failure',
  ];
  final List<String> _donationTypes = [
    'Living Related Donation (Family)',
    'Living Unrelated Donation',
    'Deceased Donor Transplant',
    'Any Compatible Donor',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _hospitalController.dispose();
    _patientNameController.dispose();
    _patientAgeController.dispose();
    _medicalConditionController.dispose();
    _doctorNameController.dispose();
    _hospitalIdController.dispose();
    _dialysisHistoryController.dispose();
    _timelineController.dispose();
    _dialysisFrequencyController.dispose();
    _compatibilityNotesController.dispose();
    _contactPersonController.dispose();
    _contactPhoneController.dispose();
    _contactEmailController.dispose();
    _familyHistoryController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }

  Future<void> _submitPost() async {
    if (_formKey.currentState!.validate()) {
      // Validate required fields
      if (_selectedBloodGroup.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a blood group'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_selectedGender.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select gender'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_urgencyLevel.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select urgency level'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      final requestProvider = Provider.of<DonationRequestProvider>(
        context,
        listen: false,
      );

      if (authProvider.userModel?.id == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not authenticated'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      try {
        // Create blood donation request model
        final kidneyRequest = KidneyRequestModel(
          userId: authProvider.userModel!.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          location: _locationController.text.trim(),
          hospital: _hospitalController.text.trim(),
          patientName: _patientNameController.text.trim(),
          patientAge: int.parse(_patientAgeController.text.trim()),
          bloodGroup: _selectedBloodGroup,
          gender: _selectedGender,
          urgencyLevel: _urgencyLevel,
          medicalCondition: _medicalConditionController.text.trim(),
          doctorName: _doctorNameController.text.trim(),
          contactPerson: _contactPersonController.text.trim(),
          contactPhone: _contactPhoneController.text.trim(),
          contactEmail: _contactEmailController.text.trim(),
          isEmergency: _isEmergency,
          additionalNotes: _additionalNotesController.text.trim().isEmpty
              ? null
              : _additionalNotesController.text.trim(),
          kidneyFailureStage: _kidneyFailureStage,
          hospitalId: _hospitalIdController.text.trim(),
          dialysisHistory: _dialysisHistoryController.text.trim(),
          donationType: _donationType,
          timeline: _timelineController.text.trim(),
          onDialysis: _onDialysis,
          dialysisFrequency: _dialysisFrequencyController.text.trim(),
          compatibilityNotes: _compatibilityNotesController.text.trim(),
          crossMatchRequired: _crossMatchRequired,
          familyHistory: _familyHistoryController.text.trim(),
        );

        // Show loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(color: kKidneyColor),
          ),
        );

        // Create the kidney request
        final success = await requestProvider.createKidneyRequest(
          kidneyRequest,
        );

        // Hide loading dialog
        if (mounted) Navigator.of(context).pop();

        if (success) {
          // Show success message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Kidney donation request posted successfully! Your request will be reviewed and published.',
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 4),
              ),
            );
            Navigator.pop(context);
          }
        } else {
          // Show error message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  requestProvider.error ?? 'Failed to create kidney request',
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        }
      } catch (e) {
        // Hide loading dialog if still showing
        if (mounted && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }

        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error creating request: ${e.toString()}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Create Kidney Request',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Card
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: const Border(
                    left: BorderSide(color: Colors.green, width: 6),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kidney Donation Request',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create a request for kidney donation. Please provide accurate medical information.',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Request Information Section
              _buildSectionTitle('Request Information'),
              _buildTextField(
                'Request Title',
                _titleController,
                isRequired: true,
                hintText:
                    'e.g., Urgent Kidney Donor Needed for 45-year-old Patient',
              ),
              _buildTextField(
                'Description',
                _descriptionController,
                maxLines: 3,
                isRequired: true,
                hintText:
                    'Describe the patient\'s condition and kidney requirement',
              ),
              _buildTextField(
                'Location/City',
                _locationController,
                isRequired: true,
                hintText: 'e.g., Colombo, Kandy',
              ),
              _buildTextField(
                'Hospital/Medical Center',
                _hospitalController,
                isRequired: true,
                hintText: 'Name of the hospital for transplant',
              ),

              const SizedBox(height: 20),

              // Patient Information Section
              _buildSectionTitle('Patient Information'),
              _buildTextField(
                'Patient Name',
                _patientNameController,
                isRequired: true,
              ),
              _buildTextField(
                'Patient Age',
                _patientAgeController,
                keyboardType: TextInputType.number,
                isRequired: true,
              ),
              _buildBloodGroupSelection(),
              _buildGenderSelection(),
              _buildDropdownField(
                'Kidney Failure Stage',
                _kidneyFailureStage,
                _kidneyFailureStages,
                (value) => setState(() => _kidneyFailureStage = value ?? ''),
                isRequired: true,
              ),

              const SizedBox(height: 20),

              // Medical Information Section
              _buildSectionTitle('Medical Information'),
              _buildTextField(
                'Medical Condition Details',
                _medicalConditionController,
                maxLines: 3,
                isRequired: true,
                hintText: 'Detailed description of the kidney condition',
              ),
              _buildTextField(
                'Doctor Name',
                _doctorNameController,
                isRequired: true,
                hintText: 'Name of the attending nephrologist',
              ),
              _buildTextField(
                'Hospital ID/Patient ID',
                _hospitalIdController,
                isRequired: true,
                hintText: 'Patient identification number',
              ),
              _buildDropdownField(
                'Preferred Donation Type',
                _donationType,
                _donationTypes,
                (value) => setState(() => _donationType = value ?? ''),
                isRequired: true,
              ),

              const SizedBox(height: 20),

              // Dialysis Information Section
              _buildSectionTitle('Dialysis Information'),
              CheckboxListTile(
                value: _onDialysis,
                onChanged: (value) {
                  setState(() {
                    _onDialysis = value ?? false;
                  });
                },
                title: Text(
                  'Patient is currently on dialysis',
                  style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                ),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              ),

              if (_onDialysis) ...[
                _buildTextField(
                  'Dialysis Frequency',
                  _dialysisFrequencyController,
                  isRequired: true,
                  hintText: 'e.g., 3 times per week',
                ),
                _buildTextField(
                  'Dialysis History',
                  _dialysisHistoryController,
                  maxLines: 2,
                  hintText: 'How long has the patient been on dialysis',
                ),
              ],

              const SizedBox(height: 20),

              // Urgency and Timeline Section
              _buildSectionTitle('Urgency and Timeline'),
              _buildUrgencySelection(),
              _buildTextField(
                'Expected Timeline',
                _timelineController,
                isRequired: true,
                hintText:
                    'When is the transplant needed? e.g., Within 6 months',
              ),

              const SizedBox(height: 20),

              // Compatibility Requirements Section
              _buildSectionTitle('Compatibility Requirements'),
              CheckboxListTile(
                value: _crossMatchRequired,
                onChanged: (value) {
                  setState(() {
                    _crossMatchRequired = value ?? true;
                  });
                },
                title: Text(
                  'Cross-match testing required',
                  style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                ),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              ),
              _buildTextField(
                'Compatibility Notes',
                _compatibilityNotesController,
                maxLines: 2,
                hintText:
                    'Any specific compatibility requirements or restrictions',
              ),

              const SizedBox(height: 20),

              // Family History Section
              _buildSectionTitle('Family History'),
              _buildTextField(
                'Family History of Kidney Disease',
                _familyHistoryController,
                maxLines: 2,
                hintText: 'Any family history relevant to kidney disease',
              ),

              const SizedBox(height: 20),

              // Emergency Checkbox
              CheckboxListTile(
                value: _isEmergency,
                onChanged: (value) {
                  setState(() {
                    _isEmergency = value ?? false;
                  });
                },
                title: Text(
                  'This is a critical emergency request',
                  style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                ),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              ),

              const SizedBox(height: 20),

              // Contact Information Section
              _buildSectionTitle('Contact Information'),
              _buildTextField(
                'Contact Person',
                _contactPersonController,
                isRequired: true,
                hintText: 'Name of person to contact',
              ),
              _buildTextField(
                'Phone Number',
                _contactPhoneController,
                keyboardType: TextInputType.phone,
                isRequired: true,
              ),
              _buildTextField(
                'Email Address',
                _contactEmailController,
                keyboardType: TextInputType.emailAddress,
                isRequired: true,
              ),

              // Additional Notes
              _buildTextField(
                'Additional Notes (Optional)',
                _additionalNotesController,
                maxLines: 3,
                hintText: 'Any additional information that might be helpful',
              ),

              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 12 : 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Post Kidney Request',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: isSmallScreen ? 16 : 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isRequired = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? hintText,
  }) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isRequired ? '$label*' : label,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.green),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 12 : 16,
                vertical: isSmallScreen ? 12 : 16,
              ),
              isDense: true,
            ),
            style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
            validator: isRequired
                ? (value) =>
                      value?.isEmpty ?? true ? 'This field is required' : null
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged, {
    bool isRequired = false,
  }) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isRequired ? '$label*' : label,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value.isEmpty ? null : value,
            onChanged: onChanged,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.green),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 12 : 16,
                vertical: isSmallScreen ? 12 : 16,
              ),
              isDense: true,
            ),
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              color: Colors.black,
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
            validator: isRequired
                ? (value) => value == null ? 'Please select an option' : null
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildBloodGroupSelection() {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Blood Group*',
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _bloodGroups.map((group) {
              return ChoiceChip(
                label: Text(
                  group,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 11 : 12,
                    color: _selectedBloodGroup == group
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
                selected: _selectedBloodGroup == group,
                onSelected: (selected) {
                  setState(() {
                    _selectedBloodGroup = selected ? group : '';
                  });
                },
                backgroundColor: Colors.grey[200],
                selectedColor: Colors.green,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelection() {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender*',
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: _genders.map((gender) {
              return Expanded(
                child: RadioListTile<String>(
                  title: Text(
                    gender,
                    style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                  ),
                  value: gender,
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value ?? '';
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUrgencySelection() {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Urgency Level*',
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _urgencyLevels.map((level) {
              Color getColor() {
                switch (level) {
                  case 'Low':
                    return Colors.green;
                  case 'Medium':
                    return Colors.orange;
                  case 'High':
                    return Colors.red;
                  case 'Critical':
                    return Colors.red[800]!;
                  default:
                    return Colors.grey;
                }
              }

              return ChoiceChip(
                label: Text(
                  level,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 11 : 12,
                    color: _urgencyLevel == level ? Colors.white : getColor(),
                  ),
                ),
                selected: _urgencyLevel == level,
                onSelected: (selected) {
                  setState(() {
                    _urgencyLevel = selected ? level : '';
                  });
                },
                backgroundColor: Colors.grey[200],
                selectedColor: getColor(),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
