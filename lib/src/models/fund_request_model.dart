class FundRequestModel {
  final String? id;
  final String userId;

  // Request Information
  final String title;
  final String description;
  final String requestType; // 'medical' or 'charity'

  // Personal Information (Medical Assistance)
  final String? fullName;
  final String? nic;
  final String? phone;
  final String? email;
  final String? address;

  // Medical Request Details
  final double? amountRequested;
  final String? reason;
  final String? hospital;
  final String? doctor;
  final String? treatment;
  final String? timeline;
  final String? fundCategory;

  // Charity Information
  final String? organization;
  final String? beneficiary;
  final double? targetAmount;
  final String? purpose;
  final String? organizationContact;
  final String? organizationEmail;
  final String? organizationAddress;
  final String? charityCategory;
  final bool? isRegisteredCharity;

  // Supporting Documents
  final List<String> supportingDocuments;
  final String urgencyLevel;

  // Additional Information
  final String? additionalNotes;
  final bool declarationAccepted;

  // Status and Timestamps
  final String status; // 'pending', 'approved', 'fulfilled', 'cancelled'
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FundRequestModel({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.requestType,
    this.fullName,
    this.nic,
    this.phone,
    this.email,
    this.address,
    this.amountRequested,
    this.reason,
    this.hospital,
    this.doctor,
    this.treatment,
    this.timeline,
    this.fundCategory,
    this.organization,
    this.beneficiary,
    this.targetAmount,
    this.purpose,
    this.organizationContact,
    this.organizationEmail,
    this.organizationAddress,
    this.charityCategory,
    this.isRegisteredCharity,
    this.supportingDocuments = const [],
    required this.urgencyLevel,
    this.additionalNotes,
    required this.declarationAccepted,
    this.status = 'pending',
    this.createdAt,
    this.updatedAt,
  });

  factory FundRequestModel.fromMap(Map<String, dynamic> map) {
    return FundRequestModel(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      requestType: map['request_type']?.toString() ?? '',
      fullName: map['full_name']?.toString(),
      nic: map['nic']?.toString(),
      phone: map['phone']?.toString(),
      email: map['email']?.toString(),
      address: map['address']?.toString(),
      amountRequested: map['amount_requested']?.toDouble(),
      reason: map['reason']?.toString(),
      hospital: map['hospital']?.toString(),
      doctor: map['doctor']?.toString(),
      treatment: map['treatment']?.toString(),
      timeline: map['timeline']?.toString(),
      fundCategory: map['fund_category']?.toString(),
      organization: map['organization']?.toString(),
      beneficiary: map['beneficiary']?.toString(),
      targetAmount: map['target_amount']?.toDouble(),
      purpose: map['purpose']?.toString(),
      organizationContact: map['organization_contact']?.toString(),
      organizationEmail: map['organization_email']?.toString(),
      organizationAddress: map['organization_address']?.toString(),
      charityCategory: map['charity_category']?.toString(),
      isRegisteredCharity: map['is_registered_charity'],
      supportingDocuments: map['supporting_documents'] != null
          ? List<String>.from(map['supporting_documents'])
          : [],
      urgencyLevel: map['urgency_level']?.toString() ?? '',
      additionalNotes: map['additional_notes']?.toString(),
      declarationAccepted: map['declaration_accepted'] ?? false,
      status: map['status']?.toString() ?? 'pending',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'title': title,
      'description': description,
      'request_type': requestType,
      'full_name': fullName,
      'nic': nic,
      'phone': phone,
      'email': email,
      'address': address,
      'amount_requested': amountRequested,
      'reason': reason,
      'hospital': hospital,
      'doctor': doctor,
      'treatment': treatment,
      'timeline': timeline,
      'fund_category': fundCategory,
      'organization': organization,
      'beneficiary': beneficiary,
      'target_amount': targetAmount,
      'purpose': purpose,
      'organization_contact': organizationContact,
      'organization_email': organizationEmail,
      'organization_address': organizationAddress,
      'charity_category': charityCategory,
      'is_registered_charity': isRegisteredCharity,
      'supporting_documents': supportingDocuments,
      'urgency_level': urgencyLevel,
      'additional_notes': additionalNotes,
      'declaration_accepted': declarationAccepted,
      'status': status,
    };
  }
}
