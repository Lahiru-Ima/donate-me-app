class DonationRegistrationModel {
  final String? id;
  final String donationRequestId; // Links to the original donation request
  final String donorUserId;
  final String category; // 'blood', 'hair', 'kidney', 'fund'
  final String status; // 'pending', 'approved', 'rejected', 'completed'
  final DateTime createdAt;
  final DateTime? updatedAt;

  // Common donor information
  final String fullName;
  final String nic;
  final String? email;
  final String phone;
  final String? address;
  final String? gender;
  final int? age;

  // Category-specific data stored as JSON
  final Map<String, dynamic> categorySpecificData;

  // Additional fields
  final String? notes;
  final DateTime? scheduledDate;

  DonationRegistrationModel({
    this.id,
    required this.donationRequestId,
    required this.donorUserId,
    required this.category,
    this.status = 'pending',
    required this.createdAt,
    this.updatedAt,
    required this.fullName,
    required this.nic,
    this.email,
    required this.phone,
     this.address,
    this.gender,
    this.age,
    required this.categorySpecificData,
    this.notes,
    this.scheduledDate,
  });

  factory DonationRegistrationModel.fromMap(Map<String, dynamic> map) {
    return DonationRegistrationModel(
      id: map['id']?.toString(),
      donationRequestId: map['donation_request_id']?.toString() ?? '',
      donorUserId: map['donor_user_id']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      status: map['status']?.toString() ?? 'pending',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
      fullName: map['full_name']?.toString() ?? '',
      nic: map['nic']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      address: map['address']?.toString() ?? '',
      gender: map['gender']?.toString() ?? '',
      age: map['age']?.toInt() ?? 0,
      categorySpecificData: map['category_specific_data'] != null
          ? Map<String, dynamic>.from(map['category_specific_data'])
          : {},
      notes: map['notes']?.toString(),
      scheduledDate: map['scheduled_date'] != null
          ? DateTime.parse(map['scheduled_date'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'donation_request_id': donationRequestId,
      'donor_user_id': donorUserId,
      'category': category,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'full_name': fullName,
      'nic': nic,
      'email': email,
      'phone': phone,
      'address': address,
      'gender': gender,
      'age': age,
      'category_specific_data': categorySpecificData,
      'notes': notes,
      'scheduled_date': scheduledDate?.toIso8601String(),
    };
  }

  DonationRegistrationModel copyWith({
    String? id,
    String? donationRequestId,
    String? donorUserId,
    String? category,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? fullName,
    String? nic,
    String? email,
    String? phone,
    String? address,
    String? gender,
    int? age,
    DateTime? dateOfBirth,
    Map<String, dynamic>? categorySpecificData,
    String? notes,
    DateTime? scheduledDate,
  }) {
    return DonationRegistrationModel(
      id: id ?? this.id,
      donationRequestId: donationRequestId ?? this.donationRequestId,
      donorUserId: donorUserId ?? this.donorUserId,
      category: category ?? this.category,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fullName: fullName ?? this.fullName,
      nic: nic ?? this.nic,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      categorySpecificData: categorySpecificData ?? this.categorySpecificData,
      notes: notes ?? this.notes,
      scheduledDate: scheduledDate ?? this.scheduledDate,
    );
  }

  // Helper methods for category-specific data
  Map<String, dynamic> get bloodSpecificData {
    if (category == 'blood') {
      return categorySpecificData;
    }
    return {};
  }

  Map<String, dynamic> get hairSpecificData {
    if (category == 'hair') {
      return categorySpecificData;
    }
    return {};
  }

  Map<String, dynamic> get kidneySpecificData {
    if (category == 'kidney') {
      return categorySpecificData;
    }
    return {};
  }

  Map<String, dynamic> get fundSpecificData {
    if (category == 'fund') {
      return categorySpecificData;
    }
    return {};
  }

  // Status helpers
  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
  bool get isCompleted => status == 'completed';

  // Formatted getters
  String get formattedCreatedAt {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }
}
