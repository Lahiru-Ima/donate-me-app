import 'package:flutter/material.dart';
import 'package:donate_me_app/src/constants/constants.dart';

class CreateBloodPostScreen extends StatefulWidget {
  const CreateBloodPostScreen({super.key});

  @override
  State<CreateBloodPostScreen> createState() => _CreateBloodPostScreenState();
}

class _CreateBloodPostScreenState extends State<CreateBloodPostScreen> {
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

  // Request Details
  final _unitsNeededController = TextEditingController();
  String _urgencyLevel = '';
  final _contactPersonController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _contactEmailController = TextEditingController();

  // Medical Information
  final _medicalConditionController = TextEditingController();
  final _doctorNameController = TextEditingController();
  final _requiredByDateController = TextEditingController();

  // Additional Information
  bool _isEmergency = false;
  final _additionalNotesController = TextEditingController();

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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _hospitalController.dispose();
    _patientNameController.dispose();
    _patientAgeController.dispose();
    _unitsNeededController.dispose();
    _contactPersonController.dispose();
    _contactPhoneController.dispose();
    _contactEmailController.dispose();
    _medicalConditionController.dispose();
    _doctorNameController.dispose();
    _requiredByDateController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      _requiredByDateController.text =
          "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  void _submitPost() {
    if (_formKey.currentState!.validate()) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Blood donation request posted successfully! Your request will be reviewed and published.',
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 4),
        ),
      );
      Navigator.pop(context);
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
          'Create Blood Request',
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
                    left: BorderSide(color: kBloodColor, width: 6),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Blood Donation Request',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.bold,
                        color: kBloodColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create a request for blood donation. Fill out all required information accurately.',
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
                hintText: 'e.g., Urgent A+ Blood Needed for Surgery',
              ),
              _buildTextField(
                'Description',
                _descriptionController,
                maxLines: 3,
                isRequired: true,
                hintText: 'Describe the blood requirement and situation',
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
                hintText: 'Name of the hospital or medical facility',
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

              const SizedBox(height: 20),

              // Request Details Section
              _buildSectionTitle('Request Details'),
              _buildTextField(
                'Units Needed',
                _unitsNeededController,
                keyboardType: TextInputType.number,
                isRequired: true,
                hintText: 'Number of blood units required',
              ),
              _buildUrgencySelection(),
              _buildDateField(
                'Required By Date',
                _requiredByDateController,
                isRequired: true,
              ),
              _buildTextField(
                'Medical Condition',
                _medicalConditionController,
                maxLines: 2,
                isRequired: true,
                hintText: 'Brief description of the medical condition',
              ),
              _buildTextField(
                'Doctor Name',
                _doctorNameController,
                isRequired: true,
                hintText: 'Name of the attending doctor',
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
                  'This is an emergency request',
                  style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                ),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
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
                    backgroundColor: kBloodColor,
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 12 : 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Post Blood Request',
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
                borderSide: BorderSide(color: kBloodColor),
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

  Widget _buildDateField(
    String label,
    TextEditingController controller, {
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
          TextFormField(
            controller: controller,
            readOnly: true,
            onTap: _selectDate,
            decoration: InputDecoration(
              hintText: 'DD/MM/YYYY',
              suffixIcon: const Icon(Icons.calendar_today),
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
                borderSide: BorderSide(color: kBloodColor),
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
                selectedColor: kBloodColor,
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
