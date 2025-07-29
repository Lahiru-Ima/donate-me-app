import 'package:donate_me_app/src/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:donate_me_app/src/models/donation_models/donation_registration_model.dart';
import 'package:donate_me_app/src/providers/donation_registration_provider.dart';

class HairDonationFormScreen extends StatefulWidget {
  final String donationRequestId;
  final String type;
  final String location;
  final String description;

  const HairDonationFormScreen({
    super.key,
    required this.donationRequestId,
    required this.type,
    required this.location,
    required this.description,
  });

  @override
  State<HairDonationFormScreen> createState() => _HairDonationFormScreenState();
}

class _HairDonationFormScreenState extends State<HairDonationFormScreen> {
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

  // Hair Details
  final _hairLengthController = TextEditingController();
  String _hairType = '';
  String _donationPurpose = '';
  bool _hasGreyHair = false;
  String _greyHairPercentage = '';
  final _additionalNotesController = TextEditingController();

  // Donation Method
  String _donationMethod = '';
  String _selectedSalon = '';
  final _pickupAddressController = TextEditingController();
  final _preferredDateController = TextEditingController();
  final _preferredTimeController = TextEditingController();

  // Certificate Request
  bool _requestCertificate = false;
  final _certificateEmailController = TextEditingController();

  // Consent
  bool _consentGiven = false;
  bool _guidelinesRead = false;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _hairTypes = [
    'Natural (No chemical treatment)',
    'Colored/Dyed',
    'Bleached',
    'Permed/Chemically treated',
    'Highlighted',
  ];
  final List<String> _donationPurposes = [
    'Cancer patients support',
    'Alopecia support',
    'General wig making',
    'Children with hair loss',
    'Medical hair loss conditions',
  ];
  final List<String> _greyHairOptions = [
    'Less than 5%',
    '5-10%',
    '10-20%',
    'More than 20%',
  ];
  final List<String> _donationMethods = [
    'Home pickup',
    'Salon donation',
    'Drop-off at hospital',
  ];

  // Salon data
  final Map<String, List<Map<String, String>>> _salonsByProvince = {
    'Western': [
      {
        'name': 'Ramani Fernando Salons',
        'location': 'Colombo 03, Colombo 07',
        'contact': '011-2300631 / 011-2300632',
        'district': 'Colombo',
      },
      {
        'name': 'Cut & Shine Salon',
        'location': 'Negombo, Gampaha',
        'contact': '033 111 9030',
        'district': 'Gampaha',
      },
      {
        'name': 'Salon Nilu',
        'location': 'Kalutara South',
        'contact': '034 652 0835',
        'district': 'Kalutara',
      },
    ],
    'Central': [
      {
        'name': 'Ramani Fernando Salons – Kandy',
        'location': 'Kandy City Center',
        'contact': '081 000 5320',
        'district': 'Kandy',
      },
      {
        'name': 'Salon Salonya',
        'location': 'Matale',
        'contact': '066 182 0883',
        'district': 'Matale',
      },
      {
        'name': 'Salon Niyomi',
        'location': 'Nuwara Eliya Town',
        'contact': '052 002 4503',
        'district': 'Nuwara Eliya',
      },
    ],
    'Southern': [
      {
        'name': 'Salon Harshani',
        'location': 'Galle Fort',
        'contact': '091 510 7041',
        'district': 'Galle',
      },
      {
        'name': 'Salon Deepthi',
        'location': 'Matara Town',
        'contact': '041 222 7601',
        'district': 'Matara',
      },
      {
        'name': 'Salon Rashmi',
        'location': 'Hambantota',
        'contact': '047 225 6285',
        'district': 'Hambantota',
      },
    ],
    'Northern': [
      {
        'name': 'Salon Anjali',
        'location': 'Jaffna Town',
        'contact': '021 832 1003',
        'district': 'Jaffna',
      },
    ],
    'Eastern': [
      {
        'name': 'Salon Imasha',
        'location': 'Trincomalee',
        'contact': '026 310 4038',
        'district': 'Trincomalee',
      },
      {
        'name': 'Salon Lakmi',
        'location': 'Batticaloa Town',
        'contact': '065 042 1211',
        'district': 'Batticaloa',
      },
      {
        'name': 'Salon Siloni',
        'location': 'Ampara',
        'contact': '063 511 1280',
        'district': 'Ampara',
      },
    ],
    'North Central': [
      {
        'name': 'Salon Dilhani',
        'location': 'Anuradhapura',
        'contact': '025 404 1067',
        'district': 'Anuradhapura',
      },
      {
        'name': 'Salon Isuru',
        'location': 'Polonnaruwa Town',
        'contact': '027 881 2533',
        'district': 'Polonnaruwa',
      },
    ],
    'North Western': [
      {
        'name': 'Salon Kaushi',
        'location': 'Kurunegala City',
        'contact': '037 021 0038',
        'district': 'Kurunegala',
      },
      {
        'name': 'Salon Ramya',
        'location': 'Chilaw',
        'contact': '032 446 5335',
        'district': 'Puttalam',
      },
    ],
    'Uva': [
      {
        'name': 'Salon Sumudu',
        'location': 'Badulla Town',
        'contact': '055 500 2493',
        'district': 'Badulla',
      },
      {
        'name': 'Salon Krishni',
        'location': 'Monaragala',
        'contact': '055 127 6235',
        'district': 'Monaragala',
      },
    ],
    'Sabaragamuwa': [
      {
        'name': 'Salon Nilu',
        'location': 'Ratnapura',
        'contact': '045 002 1433',
        'district': 'Ratnapura',
      },
      {
        'name': 'Salon Shehani',
        'location': 'Kegalle Town',
        'contact': '035 656 2233',
        'district': 'Kegalle',
      },
    ],
  };

  @override
  void dispose() {
    _fullNameController.dispose();
    _nicController.dispose();
    _dobController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _hairLengthController.dispose();
    _additionalNotesController.dispose();
    _pickupAddressController.dispose();
    _preferredDateController.dispose();
    _preferredTimeController.dispose();
    _certificateEmailController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      controller.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  Future<void> _selectTime(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      controller.text = picked.format(context);
    }
  }

  void _showGuidelinesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hair Donation Guidelines'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGuidelineItem(
                  '1. Minimum Hair Length',
                  'At least 8 to 12 inches (20–30 cm), measured from tip to tip',
                ),
                _buildGuidelineItem(
                  '2. Clean and Dry',
                  'Hair must be washed, dried, and product-free before cutting',
                ),
                _buildGuidelineItem(
                  '3. No Chemically Treated Hair',
                  'Most organizations prefer natural hair without dye, bleach, or perm',
                ),
                _buildGuidelineItem(
                  '4. Tied Before Cutting',
                  'Hair should be tied in a ponytail or braid before cutting',
                ),
                _buildGuidelineItem(
                  '5. No Split Ends or Damage',
                  'Healthy hair without significant damage is ideal',
                ),
                _buildGuidelineItem(
                  '6. Grey Hair Rules Vary',
                  'Some accept limited grey hair, others don\'t',
                ),
                _buildGuidelineItem(
                  '7. Packed Properly',
                  'After cutting, seal in a plastic bag and place in an envelope',
                ),
                _buildGuidelineItem(
                  '8. Not Swept Off the Floor',
                  'Hair should be cut directly from the head',
                ),
                const SizedBox(height: 16),
                const Text(
                  'මාර්ගෝපදේශ (සිංහල)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                _buildGuidelineItem(
                  '1. අවම කෙස් දිග',
                  'අවම වශයෙන් අඟල් 8 සිට 12 (සෙ.මී. 20-30) දක්වා',
                ),
                _buildGuidelineItem(
                  '2. පිරිසිදු සහ වියළි',
                  'කපන්න කලින් කෙස් සෝදා, වියළා, නිෂ්පාදන රහිත විය යුතුය',
                ),
                _buildGuidelineItem(
                  '3. රසායනික ප්‍රතිකාර නොකළ',
                  'සාමාන්‍යයෙන් ස්වාභාවික කෙස් වඩාත් සුදුසුය',
                ),
                _buildGuidelineItem(
                  '4. කැපීමට පෙර බැඳීම',
                  'කැපීමට පෙර කෙස් පෝනි ටේල් හෝ ෙගත්තක් ලෙස බැඳිය යුතුය',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGuidelineItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(description),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _consentGiven && _guidelinesRead) {
      try {


        // Prepare hair-specific data
        Map<String, dynamic> hairSpecificData = {
          'hairLength': _hairLengthController.text,
          'hasGreyHair': _hasGreyHair,
          'additionalNotes': _additionalNotesController.text,
          'selectedSalon': _selectedSalon,
          'pickupAddress': _pickupAddressController.text,
          'preferredDate': _preferredDateController.text,
          'preferredTime': _preferredTimeController.text,
          'requestCertificate': _requestCertificate,
          'certificateEmail': _certificateEmailController.text,
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
          category: 'hair',
          status: 'pending',
          createdAt: DateTime.now(),
          fullName: _fullNameController.text,
          nic: _nicController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          address: _addressController.text,
          gender: _selectedGender,
          age: int.tryParse(_ageController.text) ?? 0,
          categorySpecificData: hairSpecificData,
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
                'Hair donation registration submitted successfully! You will receive confirmation and pickup details soon.',
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
    } else if (!_consentGiven || !_guidelinesRead) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please read guidelines and provide consent to proceed',
          ),
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
          'Hair Donation Registration',
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
                    left: BorderSide(color: Colors.brown, width: 6),
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
                        color: Colors.brown,
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

              // Guidelines Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _showGuidelinesDialog,
                  icon: const Icon(Icons.info_outline),
                  label: const Text('Read Hair Donation Guidelines'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.brown,
                    side: const BorderSide(color: Colors.brown),
                  ),
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

              const SizedBox(height: 20),

              // Hair Details Section
              _buildSectionTitle('Hair Details'),
              _buildTextField(
                'Hair Length (in inches)',
                _hairLengthController,
                keyboardType: TextInputType.number,
                isRequired: true,
                helpText: 'Minimum 8-12 inches required',
              ),
              _buildDropdownField('Hair Type*', _hairType, _hairTypes, (value) {
                setState(() {
                  _hairType = value ?? '';
                });
              }),
              _buildDropdownField(
                'Donation Purpose*',
                _donationPurpose,
                _donationPurposes,
                (value) {
                  setState(() {
                    _donationPurpose = value ?? '';
                  });
                },
              ),
              _buildYesNoQuestion(
                'Does your hair contain grey/white hair?',
                _hasGreyHair,
                (value) {
                  setState(() {
                    _hasGreyHair = value;
                    if (!value) _greyHairPercentage = '';
                  });
                },
              ),
              if (_hasGreyHair)
                _buildDropdownField(
                  'Grey Hair Percentage*',
                  _greyHairPercentage,
                  _greyHairOptions,
                  (value) {
                    setState(() {
                      _greyHairPercentage = value ?? '';
                    });
                  },
                ),
              _buildTextField(
                'Additional Notes',
                _additionalNotesController,
                maxLines: 3,
                helpText: 'Any special considerations or information',
              ),

              const SizedBox(height: 20),

              // Donation Method Section
              _buildSectionTitle('Donation Method'),
              _buildDonationMethodSelection(),

              if (_donationMethod == 'Home pickup') ...[
                _buildTextField(
                  'Pickup Address',
                  _pickupAddressController,
                  maxLines: 2,
                  isRequired: true,
                ),
                _buildDateField(
                  'Preferred Pickup Date',
                  _preferredDateController,
                  isRequired: true,
                ),
                _buildTimeField(
                  'Preferred Pickup Time',
                  _preferredTimeController,
                  isRequired: true,
                ),
              ],

              if (_donationMethod == 'Salon donation') ...[
                _buildSalonSelection(),
              ],

              if (_donationMethod == 'Drop-off at hospital') ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Maharagama Cancer Hospital',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('Address: Maharagama 10280'),
                      const Text('Contact: 011-2850261'),
                      const Text('Working Hours: 8:00 AM - 4:00 PM (Mon-Fri)'),
                      const SizedBox(height: 8),
                      const Text(
                        'Please bring this form and your hair donation properly packaged in a sealed plastic bag.',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Certificate Request Section
              _buildSectionTitle('Certificate Request'),
              CheckboxListTile(
                value: _requestCertificate,
                onChanged: (value) {
                  setState(() {
                    _requestCertificate = value ?? false;
                  });
                },
                title: Text(
                  'I would like to receive a hair donation certificate',
                  style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              if (_requestCertificate)
                _buildTextField(
                  'Email for Certificate',
                  _certificateEmailController,
                  keyboardType: TextInputType.emailAddress,
                  isRequired: true,
                ),

              const SizedBox(height: 20),

              // Consent Section
              _buildSectionTitle('Consent and Agreement'),
              CheckboxListTile(
                value: _guidelinesRead,
                onChanged: (value) {
                  setState(() {
                    _guidelinesRead = value ?? false;
                  });
                },
                title: Text(
                  'I have read and understood the hair donation guidelines',
                  style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                value: _consentGiven,
                onChanged: (value) {
                  setState(() {
                    _consentGiven = value ?? false;
                  });
                },
                title: Text(
                  'I hereby confirm that I am donating my hair voluntarily for the benefit of those in need. I understand that donated hair cannot be returned.',
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
                    backgroundColor: Colors.brown,
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 12 : 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Submit Hair Donation Registration',
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
    String? helpText,
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
          helperText: helpText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.brown),
          ),
        ),
        validator: isRequired
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                if (label.contains('Hair Length') && value.isNotEmpty) {
                  final length = double.tryParse(value);
                  if (length == null || length < 8) {
                    return 'Hair length must be at least 8 inches';
                  }
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
            borderSide: const BorderSide(color: Colors.brown),
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

  Widget _buildTimeField(
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
            borderSide: const BorderSide(color: Colors.brown),
          ),
          suffixIcon: const Icon(Icons.access_time),
        ),
        onTap: () => _selectTime(controller),
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

  Widget _buildDropdownField(
    String label,
    String value,
    List<String> options,
    Function(String?) onChanged,
  ) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value.isEmpty ? null : value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: isSmallScreen ? 12 : 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.brown),
          ),
        ),
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(
              option,
              style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        validator: label.contains('*')
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

  Widget _buildDonationMethodSelection() {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How would you like to donate?*',
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          ..._donationMethods.map((method) {
            return RadioListTile<String>(
              title: Text(
                method,
                style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
              ),
              value: method,
              groupValue: _donationMethod,
              onChanged: (value) {
                setState(() {
                  _donationMethod = value ?? '';
                  _selectedSalon = ''; // Reset salon selection
                });
              },
              contentPadding: EdgeInsets.zero,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSalonSelection() {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select a Salon*',
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          ..._salonsByProvince.entries.map((province) {
            return ExpansionTile(
              title: Text(
                '${province.key} Province',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: province.value.map((salon) {
                final salonInfo = '${salon['name']} - ${salon['location']}';
                return RadioListTile<String>(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        salon['name']!,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        salon['location']!,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        'Contact: ${salon['contact']}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  value: salonInfo,
                  groupValue: _selectedSalon,
                  onChanged: (value) {
                    setState(() {
                      _selectedSalon = value ?? '';
                    });
                  },
                );
              }).toList(),
            );
          }),
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
