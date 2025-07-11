import 'package:donate_me_app/src/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:donate_me_app/src/models/donation_models/donation_registration_model.dart';
import 'package:donate_me_app/src/providers/donation_registration_provider.dart';

class FundDonationFormScreen extends StatefulWidget {
  final String donationRequestId;
  final String type;
  final String location;
  final String description;

  const FundDonationFormScreen({
    super.key,
    required this.donationRequestId,
    required this.type,
    required this.location,
    required this.description,
  });

  @override
  State<FundDonationFormScreen> createState() => _FundDonationFormScreenState();
}

class _FundDonationFormScreenState extends State<FundDonationFormScreen> {
  final _donateFormKey = GlobalKey<FormState>();

  // Medical Assistance Request Form Fields
  final _fullNameController = TextEditingController();
  final _nicController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _amountRequestedController = TextEditingController();
  final _reasonController = TextEditingController();

  // Donation Form Fields
  final _donorNameController = TextEditingController();
  final _donorEmailController = TextEditingController();
  final _donorPhoneController = TextEditingController();
  final _donationAmountController = TextEditingController();
  String _selectedPaymentMethod = '';
  String _selectedBank = '';

  // Stripe Card Fields
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderNameController = TextEditingController();

  final List<String> _paymentMethods = [
    'Bank Transfer',
    'Online Payment (Card)',
  ];

  final Map<String, Map<String, String>> _bankDetails = {
    'Commercial Bank of Ceylon PLC': {
      'accountHolder': 'Donate Me Foundation',
      'accountNumber': '1234567890',
      'branch': 'Colombo Main Branch',
      'swiftCode': 'CCEYLKLX',
    },
    'People\'s Bank': {
      'accountHolder': 'Donate Me Foundation',
      'accountNumber': '1234567890',
      'branch': 'Colombo Main Branch',
      'swiftCode': 'PSBKLKLX',
    },
    'Bank of Ceylon (BOC)': {
      'accountHolder': 'Donate Me Foundation',
      'accountNumber': '1234567890',
      'branch': 'Colombo Main Branch',
      'swiftCode': 'BCEYLKLX',
    },
  };

  @override
  void dispose() {
    _fullNameController.dispose();
    _nicController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _amountRequestedController.dispose();
    _reasonController.dispose();
    _donorNameController.dispose();
    _donorEmailController.dispose();
    _donorPhoneController.dispose();
    _donationAmountController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _cardHolderNameController.dispose();
    super.dispose();
  }

  void _processDonation() {
    if (_donateFormKey.currentState!.validate()) {
      if (_selectedPaymentMethod == 'Online Payment (Card)') {
        _processStripePayment();
      } else {
        _showBankTransferConfirmation();
      }
    }
  }

  void _processStripePayment() {
    // Simulate Stripe payment processing
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Processing Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('Processing LKR ${_donationAmountController.text}...'),
          ],
        ),
      ),
    );

    // Simulate payment processing delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close processing dialog
      _showPaymentSuccess();
    });
  }

  Future<void> _saveFundDonationToDatabase() async {
    try {
      // Prepare fund-specific data
      Map<String, dynamic> fundSpecificData = {
        'donorName': _donorNameController.text,
        'donorEmail': _donorEmailController.text,
        'donorPhone': _donorPhoneController.text,
        'donationAmount': _donationAmountController.text,
        'selectedPaymentMethod': _selectedPaymentMethod,
        'amountRequested': _amountRequestedController.text,
        'reason': _reasonController.text,
        'paymentComplete': true,
        'transactionId': 'TXN${DateTime.now().millisecondsSinceEpoch}',
      };

       final authProvider = Provider.of<AuthenticationProvider>(
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
        category: 'fund',
        status: 'pending',
        createdAt: DateTime.now(),
        fullName: _donorNameController.text,
        nic: _nicController.text,
        email: _donorEmailController.text,
        phone: _donorPhoneController.text,
        address: _addressController.text,
        categorySpecificData: fundSpecificData,
      );

      // Save to database
      final provider = Provider.of<DonationRegistrationProvider>(
        context,
        listen: false,
      );
      await provider.createDonationRegistration(registration);
    } catch (e) {
      print('Error saving fund donation: $e');
    }
  }

  void _showPaymentSuccess() async {
    // Save to database first
    await _saveFundDonationToDatabase();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Successful!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Thank you for your generous donation!'),
            const SizedBox(height: 8),
            Text('Amount: LKR ${_donationAmountController.text}'),
            Text('Transaction ID: TXN${DateTime.now().millisecondsSinceEpoch}'),
            const SizedBox(height: 8),
            const Text('A receipt has been sent to your email.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to home
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showBankTransferConfirmation() async {
    // Save to database for bank transfer as well
    await _saveFundDonationToDatabase();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Thank you! Please use the provided bank details to complete your donation.',
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Fund Donation',
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
        key: _donateFormKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Donation Info
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
                      widget.type,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
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

              // Donor Information
              _buildSectionTitle('Donor Information'),
              _buildTextField(
                'Full Name',
                _donorNameController,
                isRequired: true,
              ),
              _buildTextField(
                'Email Address',
                _donorEmailController,
                keyboardType: TextInputType.emailAddress,
                isRequired: true,
              ),
              _buildTextField(
                'Phone Number',
                _donorPhoneController,
                keyboardType: TextInputType.phone,
                isRequired: true,
              ),

              const SizedBox(height: 20),

              // Donation Amount
              _buildSectionTitle('Donation Amount'),
              _buildTextField(
                'Amount (LKR)',
                _donationAmountController,
                keyboardType: TextInputType.number,
                isRequired: true,
                prefix: 'LKR ',
              ),

              const SizedBox(height: 20),

              // Payment Method
              _buildSectionTitle('Payment Method'),
              ..._paymentMethods.map((method) {
                return RadioListTile<String>(
                  title: Text(
                    method,
                    style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                  ),
                  value: method,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value ?? '';
                      _selectedBank = '';
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                );
              }).toList(),

              if (_selectedPaymentMethod == 'Bank Transfer') ...[
                const SizedBox(height: 16),
                _buildSectionTitle('Select Bank'),
                ..._bankDetails.keys.map((bank) {
                  return RadioListTile<String>(
                    title: Text(
                      bank,
                      style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                    ),
                    value: bank,
                    groupValue: _selectedBank,
                    onChanged: (value) {
                      setState(() {
                        _selectedBank = value ?? '';
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  );
                }).toList(),

                if (_selectedBank.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedBank,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Account Holder: ${_bankDetails[_selectedBank]!['accountHolder']}',
                        ),
                        Text(
                          'Account Number: ${_bankDetails[_selectedBank]!['accountNumber']}',
                        ),
                        Text(
                          'Branch: ${_bankDetails[_selectedBank]!['branch']}',
                        ),
                        Text(
                          'SWIFT Code: ${_bankDetails[_selectedBank]!['swiftCode']} (For international donors)',
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Please use the above details to transfer your donation amount.',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],

              if (_selectedPaymentMethod == 'Online Payment (Card)') ...[
                const SizedBox(height: 16),
                _buildSectionTitle('Card Details'),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.credit_card, color: Colors.orange),
                          const SizedBox(width: 8),
                          const Text(
                            'Secure Payment with Stripe',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Image.asset(
                            'assets/images/stripe_logo.png',
                            height: 20,
                            errorBuilder: (context, error, stackTrace) =>
                                const Text('Stripe'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        'Card Number',
                        _cardNumberController,
                        isRequired: true,
                        keyboardType: TextInputType.number,
                        hintText: '1234 5678 9012 3456',
                      ),
                      _buildTextField(
                        'Cardholder Name',
                        _cardHolderNameController,
                        isRequired: true,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              'Expiry Date',
                              _expiryDateController,
                              isRequired: true,
                              hintText: 'MM/YY',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              'CVV',
                              _cvvController,
                              isRequired: true,
                              keyboardType: TextInputType.number,
                              hintText: '123',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 30),

              // Donate Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedPaymentMethod.isEmpty
                      ? null
                      : _processDonation,
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
                    _selectedPaymentMethod == 'Online Payment (Card)'
                        ? 'Donate Now - LKR ${_donationAmountController.text}'
                        : 'Confirm Donation',
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
    String? prefix,
    String? hintText,
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
          hintText: hintText,
          labelStyle: TextStyle(fontSize: isSmallScreen ? 12 : 14),
          helperText: helpText,
          prefixText: prefix,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.orange),
          ),
        ),
        validator: isRequired
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                if (label.contains('Email') && value.isNotEmpty) {
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                }
                if (label.contains('Amount') && value.isNotEmpty) {
                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return 'Please enter a valid amount';
                  }
                }
                return null;
              }
            : null,
      ),
    );
  }
}
