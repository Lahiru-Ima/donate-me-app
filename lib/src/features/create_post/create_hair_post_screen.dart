import 'package:donate_me_app/src/constants/constants.dart';
import 'package:donate_me_app/src/models/request_models/hair_request_model.dart';
import 'package:donate_me_app/src/providers/auth_provider.dart';
import 'package:donate_me_app/src/providers/donation_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateHairPostScreen extends StatefulWidget {
  const CreateHairPostScreen({super.key});

  @override
  State<CreateHairPostScreen> createState() => _CreateHairPostScreenState();
}

class _CreateHairPostScreenState extends State<CreateHairPostScreen> {
  final _formKey = GlobalKey<FormState>();

  // Request Information
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _organizationController = TextEditingController();

  // Hair Requirements
  String _hairType = '';
  final _minLengthController = TextEditingController();
  final _maxLengthController = TextEditingController();
  String _hairColor = '';
  String _purposeCategory = '';

  // Recipient Information
  final _recipientAgeController = TextEditingController();
  String _recipientGender = '';
  final _medicalConditionController = TextEditingController();

  // Collection Details
  String _collectionMethod = '';
  final _collectionLocationController = TextEditingController();
  final _availableDatesController = TextEditingController();

  // Contact Information
  final _contactPersonController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _contactEmailController = TextEditingController();

  // Additional Information
  final _quantityNeededController = TextEditingController();
  String _urgencyLevel = '';
  final _additionalNotesController = TextEditingController();
  bool _certificateOffered = false;

  final List<String> _hairTypes = [
    'Natural (Untreated)',
    'Virgin Hair (Never chemically treated)',
    'Straight',
    'Wavy',
    'Curly',
    'Any type accepted',
  ];

  final List<String> _hairColors = [
    'Black',
    'Brown',
    'Blonde',
    'Red',
    'Grey/Silver',
    'Any color',
  ];

  final List<String> _purposeCategories = [
    'Cancer Patient Support',
    'Alopecia Support',
    'Children with Hair Loss',
    'Medical Hair Loss Conditions',
    'General Wig Making',
    'Charity Organization',
  ];

  final List<String> _genders = ['Male', 'Female', 'Child', 'Any'];
  final List<String> _urgencyLevels = ['Low', 'Medium', 'High', 'Critical'];
  final List<String> _collectionMethods = [
    'Home Pickup',
    'Drop-off at Center',
    'Salon Collection',
    'Hospital Collection',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _organizationController.dispose();
    _minLengthController.dispose();
    _maxLengthController.dispose();
    _recipientAgeController.dispose();
    _medicalConditionController.dispose();
    _collectionLocationController.dispose();
    _availableDatesController.dispose();
    _contactPersonController.dispose();
    _contactPhoneController.dispose();
    _contactEmailController.dispose();
    _quantityNeededController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }

  Future<void> _submitPost() async {
    if (_formKey.currentState!.validate()) {
      if (_urgencyLevel.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select urgency level'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Validate length fields if both are provided
      final minLength = double.tryParse(_minLengthController.text.trim());
      final maxLength = double.tryParse(_maxLengthController.text.trim());

      if (minLength != null && maxLength != null && minLength > maxLength) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Maximum length must be greater than or equal to minimum length',
            ),
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
        final hairRequest = HairRequestModel(
          userId: authProvider.userModel!.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          location: _locationController.text.trim(),
          organization: _organizationController.text.trim(),
          hairType: _hairType,
          minLength: double.tryParse(_minLengthController.text.trim()) ?? 0.0,
          maxLength: double.tryParse(_maxLengthController.text.trim()) ?? 0.0,
          hairColor: _hairColor,
          purposeCategory: _purposeCategory,
          recipientAge: int.tryParse(_recipientAgeController.text.trim()) ?? 0,
          recipientGender: _recipientGender,
          medicalCondition: _medicalConditionController.text.trim(),
          collectionMethod: _collectionMethod,
          collectionLocation: _collectionLocationController.text.trim(),
          availableDates: _availableDatesController.text.trim(),
          contactPerson: _contactPersonController.text.trim(),
          contactPhone: _contactPhoneController.text.trim(),
          contactEmail: _contactEmailController.text.trim(),
          quantityNeeded:
              int.tryParse(_quantityNeededController.text.trim()) ?? 0,
          urgencyLevel: _urgencyLevel,
          certificateOffered: _certificateOffered,
        );

        // Show loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator(color: kHairColor)),
        );

        final success = await requestProvider.createHairRequest(hairRequest);

        // Hide loading dialog
        if (mounted) Navigator.of(context).pop();

        if (success) {
          // Show success message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Hair request created successfully!'),
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
                  requestProvider.error ?? 'Failed to create hair request',
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
          'Create Hair Request',
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
                    left: BorderSide(color: Colors.brown, width: 6),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hair Donation Request',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create a request for hair donation. Specify your requirements clearly.',
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
                hintText: 'e.g., Long Hair Needed for Cancer Patient',
              ),
              _buildTextField(
                'Description',
                _descriptionController,
                maxLines: 3,
                isRequired: true,
                hintText: 'Describe the hair requirement and purpose',
              ),
              _buildTextField(
                'Location/City',
                _locationController,
                isRequired: true,
                hintText: 'e.g., Colombo, Kandy',
              ),
              _buildTextField(
                'Organization/Hospital',
                _organizationController,
                isRequired: true,
                hintText: 'Name of the organization or hospital',
              ),

              const SizedBox(height: 20),

              // Hair Requirements Section
              _buildSectionTitle('Hair Requirements'),
              _buildDropdownField(
                'Hair Type',
                _hairType,
                _hairTypes,
                (value) => setState(() => _hairType = value ?? ''),
                isRequired: true,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      'Min Length (inches)',
                      _minLengthController,
                      keyboardType: TextInputType.number,
                      isRequired: true,
                      hintText: 'e.g., 8',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      'Max Length (inches)',
                      _maxLengthController,
                      keyboardType: TextInputType.number,
                      hintText: 'e.g., 20',
                    ),
                  ),
                ],
              ),
              _buildDropdownField(
                'Preferred Hair Color',
                _hairColor,
                _hairColors,
                (value) => setState(() => _hairColor = value ?? ''),
                isRequired: true,
              ),
              _buildDropdownField(
                'Purpose Category',
                _purposeCategory,
                _purposeCategories,
                (value) => setState(() => _purposeCategory = value ?? ''),
                isRequired: true,
              ),
              _buildTextField(
                'Quantity Needed',
                _quantityNeededController,
                keyboardType: TextInputType.number,
                isRequired: true,
                hintText: 'Number of hair donations needed',
              ),

              const SizedBox(height: 20),

              // Recipient Information Section
              _buildSectionTitle('Recipient Information'),
              _buildTextField(
                'Recipient Age',
                _recipientAgeController,
                keyboardType: TextInputType.number,
                hintText: 'Age of the person who will receive the wig',
              ),
              _buildDropdownField(
                'Recipient Gender',
                _recipientGender,
                _genders,
                (value) => setState(() => _recipientGender = value ?? ''),
              ),
              _buildTextField(
                'Medical Condition',
                _medicalConditionController,
                maxLines: 2,
                hintText: 'Brief description of the medical condition',
              ),

              const SizedBox(height: 20),

              // Collection Details Section
              _buildSectionTitle('Collection Details'),
              _buildDropdownField(
                'Collection Method',
                _collectionMethod,
                _collectionMethods,
                (value) => setState(() => _collectionMethod = value ?? ''),
                isRequired: true,
              ),
              _buildTextField(
                'Collection Location',
                _collectionLocationController,
                isRequired: true,
                hintText: 'Specific address or location for collection',
              ),
              _buildTextField(
                'Available Dates/Times',
                _availableDatesController,
                maxLines: 2,
                isRequired: true,
                hintText: 'When can donors drop off or when can you collect',
              ),

              const SizedBox(height: 20),

              // Urgency and Additional Info
              _buildUrgencySelection(),

              // Certificate Offered Checkbox
              CheckboxListTile(
                value: _certificateOffered,
                onChanged: (value) {
                  setState(() {
                    _certificateOffered = value ?? false;
                  });
                },
                title: Text(
                  'Donation certificate will be provided',
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
                    backgroundColor: Colors.brown,
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 12 : 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Post Hair Request',
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
                borderSide: const BorderSide(color: Colors.brown),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 12 : 16,
                vertical: isSmallScreen ? 12 : 16,
              ),
              isDense: true,
            ),
            style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
            validator: isRequired
                ? (value) {
                    if (value?.isEmpty ?? true) {
                      return 'This field is required';
                    }
                    // Additional validation for numeric fields
                    if (keyboardType == TextInputType.number) {
                      final numValue = double.tryParse(value!);
                      if (numValue == null) {
                        return 'Please enter a valid number';
                      }
                      if (label.contains('Min Length') && numValue < 1) {
                        return 'Minimum length must be at least 1 inch';
                      }
                      if (label.contains('Max Length') && numValue < 1) {
                        return 'Maximum length must be at least 1 inch';
                      }
                      if (label.contains('Age') &&
                          (numValue < 0 || numValue > 120)) {
                        return 'Please enter a valid age';
                      }
                      if (label.contains('Quantity') && numValue < 1) {
                        return 'Quantity must be at least 1';
                      }
                    }
                    return null;
                  }
                : (value) {
                    // Validation for optional numeric fields
                    if (keyboardType == TextInputType.number &&
                        value != null &&
                        value.isNotEmpty) {
                      final numValue = double.tryParse(value);
                      if (numValue == null) {
                        return 'Please enter a valid number';
                      }
                      if (label.contains('Max Length') && numValue < 1) {
                        return 'Maximum length must be at least 1 inch';
                      }
                      if (label.contains('Age') &&
                          (numValue < 0 || numValue > 120)) {
                        return 'Please enter a valid age';
                      }
                    }
                    return null;
                  },
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
                borderSide: const BorderSide(color: Colors.brown),
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
