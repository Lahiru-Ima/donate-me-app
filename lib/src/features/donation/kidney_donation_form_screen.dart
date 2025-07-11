import 'package:donate_me_app/src/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:donate_me_app/src/models/donation_models/donation_registration_model.dart';
import 'package:donate_me_app/src/providers/donation_registration_provider.dart';

class KidneyDonationFormScreen extends StatefulWidget {
  final String donationRequestId;
  final String type;
  final String location;
  final String description;

  const KidneyDonationFormScreen({
    super.key,
    required this.donationRequestId,
    required this.type,
    required this.location,
    required this.description,
  });

  @override
  State<KidneyDonationFormScreen> createState() =>
      _KidneyDonationFormScreenState();
}

class _KidneyDonationFormScreenState extends State<KidneyDonationFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Personal Information
  final _fullNameController = TextEditingController();
  final _nicController = TextEditingController();
  final _dobController = TextEditingController();
  final _ageController = TextEditingController();
  String _selectedGender = '';

  // Contact Details
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  // Donation Details
  String _selectedBloodGroup = '';
  String _donationType = '';
  final _recipientRelationController = TextEditingController();

  // Medical History
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  bool _hasChronicDiseases = false;
  final _chronicDiseasesController = TextEditingController();
  bool _hasPreviousSurgeries = false;
  final _surgeriesController = TextEditingController();
  bool _hasCurrentMedication = false;
  final _medicationDetailsController = TextEditingController();
  bool _hasAllergies = false;
  final _allergiesController = TextEditingController();

  // Lifestyle Factors
  bool _smoker = false;
  bool _alcoholConsumer = false;
  final _smokingDetailsController = TextEditingController();
  final _alcoholDetailsController = TextEditingController();

  // Medical Screening (to be completed by medical staff)
  final _bloodPressureController = TextEditingController();
  final _creatinineController = TextEditingController();
  final _gfrController = TextEditingController();

  // Consent
  bool _consentGiven = false;
  bool _psychologicalEvaluationConsent = false;

  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
    'Unknown',
  ];
  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _donationTypes = [
    'Living Related Donation',
    'Living Unrelated Donation',
    'Deceased Donation Registration',
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _nicController.dispose();
    _dobController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _emergencyContactController.dispose();
    _emergencyPhoneController.dispose();
    _recipientRelationController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _chronicDiseasesController.dispose();
    _surgeriesController.dispose();
    _medicationDetailsController.dispose();
    _allergiesController.dispose();
    _smokingDetailsController.dispose();
    _alcoholDetailsController.dispose();
    _bloodPressureController.dispose();
    _creatinineController.dispose();
    _gfrController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        _consentGiven &&
        _psychologicalEvaluationConsent) {
      try {

        // Prepare kidney-specific data
        Map<String, dynamic> kidneySpecificData = {
          'emergencyContact': _emergencyContactController.text,
          'emergencyPhone': _emergencyPhoneController.text,
          'selectedBloodGroup': _selectedBloodGroup,
          'recipientRelation': _recipientRelationController.text,
          'height': _heightController.text,
          'weight': _weightController.text,
          'hasChronicDiseases': _hasChronicDiseases,
          'chronicDiseases': _chronicDiseasesController.text,
          'hasPreviousSurgeries': _hasPreviousSurgeries,
          'surgeries': _surgeriesController.text,
          'hasCurrentMedication': _hasCurrentMedication,
          'medicationDetails': _medicationDetailsController.text,
          'hasAllergies': _hasAllergies,
          'allergies': _allergiesController.text,
          'smoker': _smoker,
          'alcoholConsumer': _alcoholConsumer,
        };final authProvider = Provider.of<AuthenticationProvider>(
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

        // Create donation registration model
        final registration = DonationRegistrationModel(
          donationRequestId: widget.donationRequestId,
          donorUserId: authProvider.userModel!.id,
          category: 'kidney',
          status: 'pending',
          createdAt: DateTime.now(),
          fullName: _fullNameController.text,
          nic: _nicController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          address: _addressController.text,
          gender: _selectedGender,
          age: int.tryParse(_ageController.text) ?? 0,
          categorySpecificData: kidneySpecificData,
        );

        // Save to database
        final provider = Provider.of<DonationRegistrationProvider>(
          context,
          listen: false,
        );
        final success = await provider.createDonationRegistration(registration);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Kidney donation registration submitted successfully! You will be contacted for further evaluation.',
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 4),
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(provider.error ?? 'Failed to submit registration'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } else if (!_consentGiven || !_psychologicalEvaluationConsent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide all required consents to proceed'),
          backgroundColor: Colors.red,
        ),
      );
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
          'Kidney Donation Registration',
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
              // Donation Request Info
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
                      widget.type,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.location,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: isSmallScreen ? 12 : 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.description,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Personal Information Section
              _buildSectionTitle('Personal Information'),
              _buildTextField(
                'Full Name',
                _fullNameController,
                isRequired: true,
              ),
              _buildTextField('NIC Number', _nicController, isRequired: true),
              
              _buildTextField(
                'Age',
                _ageController,
                keyboardType: TextInputType.number,
                isRequired: true,
              ),
              _buildGenderSelection(),

              const SizedBox(height: 20),

              // Contact Details Section
              _buildSectionTitle('Contact Details'),
              _buildTextField(
                'Address',
                _addressController,
                maxLines: 2,
                isRequired: true,
              ),
              _buildTextField(
                'Phone Number',
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
                'Emergency Contact Name',
                _emergencyContactController,
                isRequired: true,
              ),
              _buildTextField(
                'Emergency Contact Phone',
                _emergencyPhoneController,
                keyboardType: TextInputType.phone,
                isRequired: true,
              ),

              const SizedBox(height: 20),

              // Donation Details Section
              _buildSectionTitle('Donation Details'),
              _buildDonationTypeSelection(),
              _buildBloodGroupSelection(),
              if (_donationType == 'Living Related Donation')
                _buildTextField(
                  'Relationship to Recipient',
                  _recipientRelationController,
                  isRequired: true,
                ),

              const SizedBox(height: 20),

              // Medical History Section
              _buildSectionTitle('Medical History'),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      'Height (cm)',
                      _heightController,
                      keyboardType: TextInputType.number,
                      isRequired: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      'Weight (kg)',
                      _weightController,
                      keyboardType: TextInputType.number,
                      isRequired: true,
                    ),
                  ),
                ],
              ),
              _buildYesNoQuestion(
                'Do you have any chronic diseases (diabetes, hypertension, etc.)?',
                _hasChronicDiseases,
                (value) {
                  setState(() {
                    _hasChronicDiseases = value;
                  });
                },
              ),
              if (_hasChronicDiseases)
                _buildTextField(
                  'Please specify chronic diseases',
                  _chronicDiseasesController,
                  maxLines: 2,
                  isRequired: true,
                ),
              _buildYesNoQuestion(
                'Have you had any previous surgeries?',
                _hasPreviousSurgeries,
                (value) {
                  setState(() {
                    _hasPreviousSurgeries = value;
                  });
                },
              ),
              if (_hasPreviousSurgeries)
                _buildTextField(
                  'Please specify previous surgeries',
                  _surgeriesController,
                  maxLines: 2,
                  isRequired: true,
                ),
              _buildYesNoQuestion(
                'Are you currently taking any medications?',
                _hasCurrentMedication,
                (value) {
                  setState(() {
                    _hasCurrentMedication = value;
                  });
                },
              ),
              if (_hasCurrentMedication)
                _buildTextField(
                  'Please list current medications',
                  _medicationDetailsController,
                  maxLines: 2,
                  isRequired: true,
                ),
              _buildYesNoQuestion(
                'Do you have any known allergies?',
                _hasAllergies,
                (value) {
                  setState(() {
                    _hasAllergies = value;
                  });
                },
              ),
              if (_hasAllergies)
                _buildTextField(
                  'Please specify allergies',
                  _allergiesController,
                  maxLines: 2,
                  isRequired: true,
                ),

              const SizedBox(height: 20),

              // Lifestyle Factors Section
              _buildSectionTitle('Lifestyle Factors'),
              _buildYesNoQuestion('Do you smoke?', _smoker, (value) {
                setState(() {
                  _smoker = value;
                });
              }),
              if (_smoker)
                _buildTextField(
                  'Smoking details (frequency, duration)',
                  _smokingDetailsController,
                  maxLines: 2,
                ),
              _buildYesNoQuestion(
                'Do you consume alcohol regularly?',
                _alcoholConsumer,
                (value) {
                  setState(() {
                    _alcoholConsumer = value;
                  });
                },
              ),
              if (_alcoholConsumer)
                _buildTextField(
                  'Alcohol consumption details',
                  _alcoholDetailsController,
                  maxLines: 2,
                ),

              const SizedBox(height: 20),

              // Medical Screening Section
              _buildSectionTitle(
                'Medical Screening (to be completed by medical staff)',
              ),
              _buildTextField('Blood Pressure', _bloodPressureController),
              _buildTextField('Serum Creatinine Level', _creatinineController),
              _buildTextField(
                'GFR (Glomerular Filtration Rate)',
                _gfrController,
              ),

              const SizedBox(height: 20),

              // Consent Section
              _buildSectionTitle('Consent and Agreement'),
              CheckboxListTile(
                value: _consentGiven,
                onChanged: (value) {
                  setState(() {
                    _consentGiven = value ?? false;
                  });
                },
                title: Text(
                  'I hereby confirm that I am donating my kidney voluntarily and understand all risks involved. I have been informed about the donation process and post-operative care.',
                  style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                value: _psychologicalEvaluationConsent,
                onChanged: (value) {
                  setState(() {
                    _psychologicalEvaluationConsent = value ?? false;
                  });
                },
                title: Text(
                  'I consent to psychological evaluation and counseling as part of the donation process.',
                  style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
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
                    'Submit Registration',
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
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool isRequired = false,
  }) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: isSmallScreen ? 12 : 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.green),
          ),
        ),
        validator: isRequired
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              }
            : null,
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

  Widget _buildDonationTypeSelection() {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Type of Donation*',
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          ..._donationTypes.map((type) {
            return RadioListTile<String>(
              title: Text(
                type,
                style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
              ),
              value: type,
              groupValue: _donationType,
              onChanged: (value) {
                setState(() {
                  _donationType = value ?? '';
                });
              },
              contentPadding: EdgeInsets.zero,
            );
          }).toList(),
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
            children: _bloodGroups.map((bloodGroup) {
              return FilterChip(
                label: Text(
                  bloodGroup,
                  style: TextStyle(fontSize: isSmallScreen ? 10 : 12),
                ),
                selected: _selectedBloodGroup == bloodGroup,
                onSelected: (selected) {
                  setState(() {
                    _selectedBloodGroup = selected ? bloodGroup : '';
                  });
                },
                selectedColor: Colors.green.withOpacity(0.2),
                checkmarkColor: Colors.green,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildYesNoQuestion(
    String question,
    bool value,
    Function(bool) onChanged,
  ) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: RadioListTile<bool>(
                  title: Text(
                    'Yes',
                    style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                  ),
                  value: true,
                  groupValue: value,
                  onChanged: (val) => onChanged(val ?? false),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              Expanded(
                child: RadioListTile<bool>(
                  title: Text(
                    'No',
                    style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                  ),
                  value: false,
                  groupValue: value,
                  onChanged: (val) => onChanged(val ?? false),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
