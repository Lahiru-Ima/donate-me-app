class BloodRequestModel {
  final String? id;
  final String userId;

  // Request Information
  final String title;
  final String description;
  final String location;
  final String hospital;

  // Patient Information
  final String patientName;
  final int patientAge;
  final String bloodGroup;
  final String gender;

  // Request Details
  final int unitsNeeded;
  final String urgencyLevel;
  final DateTime requiredByDate;
  final String medicalCondition;
  final String doctorName;

  // Contact Information
  final String contactPerson;
  final String contactPhone;
  final String? contactEmail;

  // Additional Information
  final bool isEmergency;
  final String? additionalNotes;

  // Status and Timestamps
  final String status; // 'pending', 'approved', 'fulfilled', 'cancelled'
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BloodRequestModel({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.location,
    required this.hospital,
    required this.patientName,
    required this.patientAge,
    required this.bloodGroup,
    required this.gender,
    required this.unitsNeeded,
    required this.urgencyLevel,
    required this.requiredByDate,
    required this.medicalCondition,
    required this.doctorName,
    required this.contactPerson,
    required this.contactPhone,
    this.contactEmail,
    required this.isEmergency,
    this.additionalNotes,
    this.status = 'pending',
    this.createdAt,
    this.updatedAt,
  });

  factory BloodRequestModel.fromMap(Map<String, dynamic> map) {
    return BloodRequestModel(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      location: map['location']?.toString() ?? '',
      hospital: map['hospital']?.toString() ?? '',
      patientName: map['patient_name']?.toString() ?? '',
      patientAge: map['patient_age']?.toInt() ?? 0,
      bloodGroup: map['blood_group']?.toString() ?? '',
      gender: map['gender']?.toString() ?? '',
      unitsNeeded: map['units_needed']?.toInt() ?? 0,
      urgencyLevel: map['urgency_level']?.toString() ?? '',
      requiredByDate: DateTime.parse(map['required_by_date']),
      medicalCondition: map['medical_condition']?.toString() ?? '',
      doctorName: map['doctor_name']?.toString() ?? '',
      contactPerson: map['contact_person']?.toString() ?? '',
      contactPhone: map['contact_phone']?.toString() ?? '',
      contactEmail: map['contact_email']?.toString() ?? '',
      isEmergency: map['is_emergency'] ?? false,
      additionalNotes: map['additional_notes']?.toString(),
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
      'hospital': hospital,
      'patient_name': patientName,
      'patient_age': patientAge,
      'blood_group': bloodGroup,
      'gender': gender,
      'units_needed': unitsNeeded,
      'urgency_level': urgencyLevel,
      'required_by_date': requiredByDate.toIso8601String(),
      'medical_condition': medicalCondition,
      'doctor_name': doctorName,
      'contact_person': contactPerson,
      'contact_phone': contactPhone,
      'contact_email': contactEmail,
      'is_emergency': isEmergency,
      'additional_notes': additionalNotes,
      'status': status,
    };
  }
}
