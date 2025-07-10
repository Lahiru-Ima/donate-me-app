import 'package:flutter/material.dart';
import 'package:donate_me_app/src/constants/constants.dart';

class BloodDonationFormScreen extends StatefulWidget {
  final String type;
  final String location;
  final String description;

  const BloodDonationFormScreen({
    super.key,
    required this.type,
    required this.location,
    required this.description,
  });

  @override
  State<BloodDonationFormScreen> createState() =>
      _BloodDonationFormScreenState();
}

class _BloodDonationFormScreenState extends State<BloodDonationFormScreen> {
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

  // Donation Details
  String _selectedBloodGroup = '';
  bool _hasdonatedBefore = false;
  final _lastDonationController = TextEditingController();

  // Medical Screening
  final _bloodPressureController = TextEditingController();
  final _hemoglobinController = TextEditingController();
  bool _hasCurrentMedication = false;
  final _medicationDetailsController = TextEditingController();

  // Consent
  bool _consentGiven = false;

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

  @override
  void dispose() {
    _fullNameController.dispose();
    _nicController.dispose();
    _dobController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _lastDonationController.dispose();
    _bloodPressureController.dispose();
    _hemoglobinController.dispose();
    _medicationDetailsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _consentGiven) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Blood donation registration submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else if (!_consentGiven) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please give your consent to proceed'),
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
          'Blood Donation Registration',
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
                    left: BorderSide(color: kBloodColor, width: 6),
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
                        color: kBloodColor,
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
              _buildDateField(
                'Date of Birth',
                _dobController,
                isRequired: true,
              ),
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
                'Email Address (optional)',
                _emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              // Donation Details Section
              _buildSectionTitle('Donation Details'),
              _buildBloodGroupSelection(),
              _buildYesNoQuestion(
                'Have you donated blood before?',
                _hasdonatedBefore,
                (value) {
                  setState(() {
                    _hasdonatedBefore = value;
                  });
                },
              ),
              if (_hasdonatedBefore)
                _buildDateField('Last Donation Date', _lastDonationController),

              const SizedBox(height: 20),

              // Medical Screening Section
              _buildSectionTitle(
                'Medical Screening (to be completed by medical staff)',
              ),
              _buildTextField('Blood Pressure', _bloodPressureController),
              _buildTextField('Hemoglobin Level', _hemoglobinController),
              _buildYesNoQuestion(
                'Any current medication or illness?',
                _hasCurrentMedication,
                (value) {
                  setState(() {
                    _hasCurrentMedication = value;
                  });
                },
              ),
              if (_hasCurrentMedication)
                _buildTextField(
                  'If yes, specify',
                  _medicationDetailsController,
                  maxLines: 2,
                ),

              const SizedBox(height: 20),

              // Consent Section
              _buildSectionTitle('Consent'),
              CheckboxListTile(
                value: _consentGiven,
                onChanged: (value) {
                  setState(() {
                    _consentGiven = value ?? false;
                  });
                },
                title: Text(
                  'I hereby confirm that I am donating blood voluntarily and understand the eligibility requirements.',
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
                    backgroundColor: kBloodColor,
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
            borderSide: BorderSide(color: kBloodColor),
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

  Widget _buildDateField(
    String label,
    TextEditingController controller, {
    bool isRequired = false,
  }) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: isSmallScreen ? 12 : 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: kBloodColor),
          ),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        onTap: () => _selectDate(controller),
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
            'Gender',
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

  Widget _buildBloodGroupSelection() {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Blood Group (if known)',
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
                selectedColor: kBloodColor.withOpacity(0.2),
                checkmarkColor: kBloodColor,
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
