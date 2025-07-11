class KidneyRequestModel {
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
  final String kidneyFailureStage;

  // Medical Information
  final String medicalCondition;
  final String doctorName;
  final String hospitalId;
  final String dialysisHistory;
  final String donationType;

  // Urgency and Timeline
  final String urgencyLevel;
  final String timeline;
  final bool onDialysis;
  final String dialysisFrequency;

  // Compatibility Requirements
  final String compatibilityNotes;
  final bool crossMatchRequired;

  // Contact Information
  final String contactPerson;
  final String contactPhone;
  final String contactEmail;

  // Additional Information
  final String familyHistory;
  final String? additionalNotes;
  final bool isEmergency;

  // Status and Timestamps
  final String status; // 'pending', 'approved', 'fulfilled', 'cancelled'
  final DateTime? createdAt;
  final DateTime? updatedAt;

  KidneyRequestModel({
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
    required this.kidneyFailureStage,
    required this.medicalCondition,
    required this.doctorName,
    required this.hospitalId,
    required this.dialysisHistory,
    required this.donationType,
    required this.urgencyLevel,
    required this.timeline,
    required this.onDialysis,
    required this.dialysisFrequency,
    required this.compatibilityNotes,
    required this.crossMatchRequired,
    required this.contactPerson,
    required this.contactPhone,
    required this.contactEmail,
    required this.familyHistory,
    this.additionalNotes,
    required this.isEmergency,
    this.status = 'pending',
    this.createdAt,
    this.updatedAt,
  });

  factory KidneyRequestModel.fromMap(Map<String, dynamic> map) {
    return KidneyRequestModel(
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
      kidneyFailureStage: map['kidney_failure_stage']?.toString() ?? '',
      medicalCondition: map['medical_condition']?.toString() ?? '',
      doctorName: map['doctor_name']?.toString() ?? '',
      hospitalId: map['hospital_id']?.toString() ?? '',
      dialysisHistory: map['dialysis_history']?.toString() ?? '',
      donationType: map['donation_type']?.toString() ?? '',
      urgencyLevel: map['urgency_level']?.toString() ?? '',
      timeline: map['timeline']?.toString() ?? '',
      onDialysis: map['on_dialysis'] ?? false,
      dialysisFrequency: map['dialysis_frequency']?.toString() ?? '',
      compatibilityNotes: map['compatibility_notes']?.toString() ?? '',
      crossMatchRequired: map['cross_match_required'] ?? true,
      contactPerson: map['contact_person']?.toString() ?? '',
      contactPhone: map['contact_phone']?.toString() ?? '',
      contactEmail: map['contact_email']?.toString() ?? '',
      familyHistory: map['family_history']?.toString() ?? '',
      additionalNotes: map['additional_notes']?.toString(),
      isEmergency: map['is_emergency'] ?? false,
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
      'kidney_failure_stage': kidneyFailureStage,
      'medical_condition': medicalCondition,
      'doctor_name': doctorName,
      'hospital_id': hospitalId,
      'dialysis_history': dialysisHistory,
      'donation_type': donationType,
      'urgency_level': urgencyLevel,
      'timeline': timeline,
      'on_dialysis': onDialysis,
      'dialysis_frequency': dialysisFrequency,
      'compatibility_notes': compatibilityNotes,
      'cross_match_required': crossMatchRequired,
      'contact_person': contactPerson,
      'contact_phone': contactPhone,
      'contact_email': contactEmail,
      'family_history': familyHistory,
      'additional_notes': additionalNotes,
      'is_emergency': isEmergency,
      'status': status,
    };
  }
}
