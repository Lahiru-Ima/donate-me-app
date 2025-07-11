import 'package:donate_me_app/src/constants/constants.dart';
import 'package:donate_me_app/src/models/request_models/fund_request_model.dart';
import 'package:donate_me_app/src/providers/auth_provider.dart';
import 'package:donate_me_app/src/providers/donation_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class CreateFundPostScreen extends StatefulWidget {
  const CreateFundPostScreen({super.key});

  @override
  State<CreateFundPostScreen> createState() => _CreateFundPostScreenState();
}

class _CreateFundPostScreenState extends State<CreateFundPostScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _requestFormKey = GlobalKey<FormState>();
  final _charityFormKey = GlobalKey<FormState>();

  // Medical Assistance Request Form Fields
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _nicController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _amountRequestedController = TextEditingController();
  final _reasonController = TextEditingController();
  final _hospitalController = TextEditingController();
  final _doctorController = TextEditingController();
  final _treatmentController = TextEditingController();
  final _timelineController = TextEditingController();

  // Charity Fundraising Form Fields
  final _charityTitleController = TextEditingController();
  final _charityDescriptionController = TextEditingController();
  final _organizationController = TextEditingController();
  final _beneficiaryController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _purposeController = TextEditingController();
  final _organizationContactController = TextEditingController();
  final _organizationEmailController = TextEditingController();
  final _organizationAddressController = TextEditingController();
  final _additionalNotesController = TextEditingController();

  List<File> _uploadedFiles = [];
  List<String> _supportingDocuments = [];
  String _urgencyLevel = '';
  String _fundCategory = '';
  String _charityCategory = '';
  bool _declarationAccepted = false;
  bool _isRegisteredCharity = false;

  final List<String> _documentTypes = [
    'Medical Certificate',
    'Hospital Reports',
    'Prescription/Invoice',
    'Doctor\'s Letter',
    'Diagnosis Report',
    'Treatment Plan',
    'Cost Estimation',
    'Other relevant documents',
  ];

  final List<String> _fundCategories = [
    'Medical Treatment',
    'Surgery',
    'Medication',
    'Hospital Bills',
    'Rehabilitation',
    'Emergency Medical',
    'Therapy/Counseling',
    'Medical Equipment',
  ];

  final List<String> _charityCategories = [
    'Education Support',
    'Children Welfare',
    'Elderly Care',
    'Disaster Relief',
    'Community Development',
    'Animal Welfare',
    'Environmental Cause',
    'Religious/Cultural',
  ];

  final List<String> _urgencyLevels = ['Low', 'Medium', 'High', 'Critical'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _fullNameController.dispose();
    _nicController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _amountRequestedController.dispose();
    _reasonController.dispose();
    _hospitalController.dispose();
    _doctorController.dispose();
    _treatmentController.dispose();
    _timelineController.dispose();
    _charityTitleController.dispose();
    _charityDescriptionController.dispose();
    _organizationController.dispose();
    _beneficiaryController.dispose();
    _targetAmountController.dispose();
    _purposeController.dispose();
    _organizationContactController.dispose();
    _organizationEmailController.dispose();
    _organizationAddressController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();

      if (images.isNotEmpty) {
        setState(() {
          _uploadedFiles.addAll(
            images.map((image) => File(image.path)).toList(),
          );
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking files: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeFile(int index) {
    setState(() {
      _uploadedFiles.removeAt(index);
    });
  }

  Future<void> _submitMedicalRequest() async {
    if (_requestFormKey.currentState!.validate() && _declarationAccepted) {
      if (_urgencyLevel.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select urgency level'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_supportingDocuments.isEmpty && _uploadedFiles.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please select at least one supporting document type or upload an image',
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
        // Create fund request model
        final fundRequest = FundRequestModel(
          userId: authProvider.userModel!.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          requestType: 'medical',
          fullName: _fullNameController.text.trim(),
          nic: _nicController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          address: _addressController.text.trim(),
          amountRequested: double.tryParse(
            _amountRequestedController.text.trim(),
          ),
          reason: _reasonController.text.trim(),
          hospital: _hospitalController.text.trim(),
          doctor: _doctorController.text.trim(),
          treatment: _treatmentController.text.trim(),
          timeline: _timelineController.text.trim(),
          fundCategory: _fundCategory,
          supportingDocuments: _supportingDocuments,
          urgencyLevel: _urgencyLevel,
          declarationAccepted: _declarationAccepted,
        );

        // Show loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator(color: kFundColor)),
        );

        // Create the fund request
        final success = await requestProvider.createFundRequest(fundRequest);

        // Hide loading dialog
        if (mounted) Navigator.of(context).pop();

        if (success) {
          // Show success message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Fund request posted successfully! Your request will be reviewed and published.',
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
                  requestProvider.error ?? 'Failed to create fund request',
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
    } else if (!_declarationAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the declaration to proceed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _submitCharityRequest() async {
    if (_charityFormKey.currentState!.validate()) {
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
        // Create charity fund request model
        final charityRequest = FundRequestModel(
          userId: authProvider.userModel!.id,
          title: _charityTitleController.text.trim(),
          description: _charityDescriptionController.text.trim(),
          requestType: 'charity',
          organization: _organizationController.text.trim(),
          beneficiary: _beneficiaryController.text.trim(),
          targetAmount: double.tryParse(_targetAmountController.text.trim()),
          purpose: _purposeController.text.trim(),
          organizationContact: _organizationContactController.text.trim(),
          organizationEmail: _organizationEmailController.text.trim(),
          organizationAddress: _organizationAddressController.text.trim(),
          charityCategory: _charityCategory,
          isRegisteredCharity: _isRegisteredCharity,
          additionalNotes: _additionalNotesController.text.trim().isNotEmpty
              ? _additionalNotesController.text.trim()
              : null,
          urgencyLevel: 'Medium', // Default for charity requests
          declarationAccepted: true, // Assumed for charity requests
        );

        // Show loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator(color: kFundColor)),
        );

        // Create the charity fund request
        final success = await requestProvider.createFundRequest(charityRequest);

        // Hide loading dialog
        if (mounted) Navigator.of(context).pop();

        if (success) {
          // Show success message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Charity fundraising request posted successfully! Your request will be reviewed and published.',
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
                  requestProvider.error ?? 'Failed to create charity request',
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
              content: Text('Error creating charity request: ${e.toString()}'),
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
          'Create Fund Request',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.orange,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.orange,
          tabs: const [
            Tab(text: 'Medical Assistance'),
            Tab(text: 'Charity Fundraising'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMedicalRequestForm(isSmallScreen),
          _buildCharityRequestForm(isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildMedicalRequestForm(bool isSmallScreen) {
    return Form(
      key: _requestFormKey,
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
                  left: BorderSide(color: Colors.orange, width: 6),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Medical Financial Assistance Request',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Request financial help for medical expenses, treatments, or emergency medical needs.',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Request Information
            _buildSectionTitle('Request Information'),
            _buildTextField(
              'Request Title',
              _titleController,
              isRequired: true,
              hintText: 'e.g., Help Needed for Heart Surgery',
            ),
            _buildTextField(
              'Description',
              _descriptionController,
              maxLines: 3,
              isRequired: true,
              hintText: 'Describe the medical condition and financial need',
            ),
            _buildDropdownField(
              'Fund Category',
              _fundCategory,
              _fundCategories,
              (value) => setState(() => _fundCategory = value ?? ''),
              isRequired: true,
            ),
            _buildUrgencySelection(),

            const SizedBox(height: 20),

            // Personal Information
            _buildSectionTitle('Personal Information'),
            _buildTextField('Full Name', _fullNameController, isRequired: true),
            _buildTextField(
              'National Identity Card (NIC) Number',
              _nicController,
              isRequired: true,
            ),
            _buildTextField(
              'Contact Number',
              _phoneController,
              keyboardType: TextInputType.phone,
              isRequired: true,
            ),
            _buildTextField(
              'Email Address',
              _emailController,
              keyboardType: TextInputType.emailAddress,
              isRequired: true,
            ),
            _buildTextField(
              'Residential Address',
              _addressController,
              maxLines: 3,
              isRequired: true,
            ),

            const SizedBox(height: 20),

            // Medical Information
            _buildSectionTitle('Medical Information'),
            _buildTextField(
              'Hospital/Medical Center',
              _hospitalController,
              isRequired: true,
            ),
            _buildTextField(
              'Doctor\'s Name',
              _doctorController,
              isRequired: true,
            ),
            _buildTextField(
              'Medical Condition/Treatment',
              _treatmentController,
              maxLines: 3,
              isRequired: true,
              hintText: 'Describe the medical condition and required treatment',
            ),
            _buildTextField(
              'Amount Requested (LKR)',
              _amountRequestedController,
              keyboardType: TextInputType.number,
              isRequired: true,
              prefix: 'LKR ',
            ),
            _buildTextField(
              'Detailed Reason for Request',
              _reasonController,
              maxLines: 4,
              isRequired: true,
              hintText: 'Explain why financial assistance is needed',
            ),
            _buildTextField(
              'Timeline/Urgency',
              _timelineController,
              isRequired: true,
              hintText: 'When is the treatment/funding needed?',
            ),

            const SizedBox(height: 20),

            // Supporting Documents
            _buildSectionTitle('Supporting Documents'),
            Text(
              'Select document types you can provide:',
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            ..._documentTypes.map((doc) {
              return CheckboxListTile(
                value: _supportingDocuments.contains(doc),
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _supportingDocuments.add(doc);
                    } else {
                      _supportingDocuments.remove(doc);
                    }
                  });
                },
                title: Text(
                  doc,
                  style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                ),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              );
            }).toList(),

            const SizedBox(height: 16),

            // File Upload Section
            Text(
              'Upload Document Images:',
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Icon(Icons.cloud_upload, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to upload images\n(JPG, PNG)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _pickFiles,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text(
                      'Choose Images',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // Display uploaded files
            if (_uploadedFiles.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Uploaded Images:',
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              ...List.generate(_uploadedFiles.length, (index) {
                final file = _uploadedFiles[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.image, color: Colors.grey[600]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          file.path.split('/').last,
                          style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red[400]),
                        onPressed: () => _removeFile(index),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                );
              }),
            ],

            const SizedBox(height: 20),

            // Declaration
            CheckboxListTile(
              value: _declarationAccepted,
              onChanged: (value) {
                setState(() {
                  _declarationAccepted = value ?? false;
                });
              },
              title: Text(
                'I declare that all information provided is true and accurate. I understand that false information may result in rejection of the request.',
                style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
              ),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),

            const SizedBox(height: 30),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitMedicalRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(
                    vertical: isSmallScreen ? 12 : 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Post Medical Request',
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
    );
  }

  Widget _buildCharityRequestForm(bool isSmallScreen) {
    return Form(
      key: _charityFormKey,
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
                  left: BorderSide(color: Colors.orange, width: 6),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Charity Fundraising Request',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Request funding for charity causes, community projects, or social welfare initiatives.',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Request Information
            _buildSectionTitle('Campaign Information'),
            _buildTextField(
              'Campaign Title',
              _charityTitleController,
              isRequired: true,
              hintText: 'e.g., Help Build School for Underprivileged Children',
            ),
            _buildTextField(
              'Campaign Description',
              _charityDescriptionController,
              maxLines: 4,
              isRequired: true,
              hintText: 'Detailed description of the charity cause or project',
            ),
            _buildDropdownField(
              'Charity Category',
              _charityCategory,
              _charityCategories,
              (value) => setState(() => _charityCategory = value ?? ''),
              isRequired: true,
            ),

            const SizedBox(height: 20),

            // Organization Information
            _buildSectionTitle('Organization Information'),
            _buildTextField(
              'Organization Name',
              _organizationController,
              isRequired: true,
            ),
            CheckboxListTile(
              value: _isRegisteredCharity,
              onChanged: (value) {
                setState(() {
                  _isRegisteredCharity = value ?? false;
                });
              },
              title: Text(
                'This is a registered charity organization',
                style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
              ),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),
            _buildTextField(
              'Organization Contact Person',
              _organizationContactController,
              isRequired: true,
            ),
            _buildTextField(
              'Organization Email',
              _organizationEmailController,
              keyboardType: TextInputType.emailAddress,
              isRequired: true,
            ),
            _buildTextField(
              'Organization Address',
              _organizationAddressController,
              maxLines: 3,
              isRequired: true,
            ),

            const SizedBox(height: 20),

            // Fundraising Details
            _buildSectionTitle('Fundraising Details'),
            _buildTextField(
              'Target Amount (LKR)',
              _targetAmountController,
              keyboardType: TextInputType.number,
              isRequired: true,
              prefix: 'LKR ',
            ),
            _buildTextField(
              'Purpose of Funds',
              _purposeController,
              maxLines: 3,
              isRequired: true,
              hintText: 'How will the collected funds be used?',
            ),
            _buildTextField(
              'Beneficiary Information',
              _beneficiaryController,
              maxLines: 2,
              isRequired: true,
              hintText: 'Who will benefit from this fundraising?',
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
                onPressed: _submitCharityRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(
                    vertical: isSmallScreen ? 12 : 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Post Charity Request',
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
    String? prefix,
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
              prefixText: prefix,
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
                borderSide: const BorderSide(color: Colors.orange),
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
                      if (label.contains('Amount') && numValue <= 0) {
                        return 'Amount must be greater than 0';
                      }
                    }
                    // Email validation
                    if (keyboardType == TextInputType.emailAddress) {
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value!)) {
                        return 'Please enter a valid email address';
                      }
                    }
                    return null;
                  }
                : (value) {
                    // Validation for optional fields
                    if (value != null && value.isNotEmpty) {
                      if (keyboardType == TextInputType.number) {
                        final numValue = double.tryParse(value);
                        if (numValue == null) {
                          return 'Please enter a valid number';
                        }
                        if (label.contains('Amount') && numValue <= 0) {
                          return 'Amount must be greater than 0';
                        }
                      }
                      if (keyboardType == TextInputType.emailAddress) {
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
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
                borderSide: const BorderSide(color: Colors.orange),
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
