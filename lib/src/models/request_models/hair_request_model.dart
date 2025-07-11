class HairRequestModel {
  final String? id;
  final String userId;

  // Request Information
  final String title;
  final String description;
  final String location;
  final String organization;

  // Hair Requirements
  final String hairType;
  final double minLength;
  final double maxLength;
  final String hairColor;
  final String purposeCategory;

  // Recipient Information
  final int recipientAge;
  final String recipientGender;
  final String medicalCondition;

  // Collection Details
  final String collectionMethod;
  final String collectionLocation;
  final String availableDates;

  // Contact Information
  final String contactPerson;
  final String contactPhone;
  final String contactEmail;

  // Additional Information
  final int quantityNeeded;
  final String urgencyLevel;
  final String? additionalNotes;
  final bool certificateOffered;

  // Status and Timestamps
  final String status; // 'pending', 'approved', 'fulfilled', 'cancelled'
  final DateTime? createdAt;
  final DateTime? updatedAt;

  HairRequestModel({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.location,
    required this.organization,
    required this.hairType,
    required this.minLength,
    required this.maxLength,
    required this.hairColor,
    required this.purposeCategory,
    required this.recipientAge,
    required this.recipientGender,
    required this.medicalCondition,
    required this.collectionMethod,
    required this.collectionLocation,
    required this.availableDates,
    required this.contactPerson,
    required this.contactPhone,
    required this.contactEmail,
    required this.quantityNeeded,
    required this.urgencyLevel,
    this.additionalNotes,
    required this.certificateOffered,
    this.status = 'pending',
    this.createdAt,
    this.updatedAt,
  });

  factory HairRequestModel.fromMap(Map<String, dynamic> map) {
    return HairRequestModel(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      location: map['location']?.toString() ?? '',
      organization: map['organization']?.toString() ?? '',
      hairType: map['hair_type']?.toString() ?? '',
      minLength: (map['min_length'] ?? 0).toDouble(),
      maxLength: (map['max_length'] ?? 0).toDouble(),
      hairColor: map['hair_color']?.toString() ?? '',
      purposeCategory: map['purpose_category']?.toString() ?? '',
      recipientAge: map['recipient_age']?.toInt() ?? 0,
      recipientGender: map['recipient_gender']?.toString() ?? '',
      medicalCondition: map['medical_condition']?.toString() ?? '',
      collectionMethod: map['collection_method']?.toString() ?? '',
      collectionLocation: map['collection_location']?.toString() ?? '',
      availableDates: map['available_dates']?.toString() ?? '',
      contactPerson: map['contact_person']?.toString() ?? '',
      contactPhone: map['contact_phone']?.toString() ?? '',
      contactEmail: map['contact_email']?.toString() ?? '',
      quantityNeeded: map['quantity_needed']?.toInt() ?? 0,
      urgencyLevel: map['urgency_level']?.toString() ?? '',
      additionalNotes: map['additional_notes']?.toString(),
      certificateOffered: map['certificate_offered'] ?? false,
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
      'location': location,
      'organization': organization,
      'hair_type': hairType,
      'min_length': minLength,
      'max_length': maxLength,
      'hair_color': hairColor,
      'purpose_category': purposeCategory,
      'recipient_age': recipientAge,
      'recipient_gender': recipientGender,
      'medical_condition': medicalCondition,
      'collection_method': collectionMethod,
      'collection_location': collectionLocation,
      'available_dates': availableDates,
      'contact_person': contactPerson,
      'contact_phone': contactPhone,
      'contact_email': contactEmail,
      'quantity_needed': quantityNeeded,
      'urgency_level': urgencyLevel,
      'additional_notes': additionalNotes,
      'certificate_offered': certificateOffered,
      'status': status,
    };
  }
}
