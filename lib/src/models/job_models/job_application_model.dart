class JobApplicationModel {
  final String? id;
  final String jobId;
  final String applicantUserId;
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String? experience;
  final List<String>? skills;
  final String? availability;
  final String? motivation;
  final String? emergencyContact;
  final String? emergencyPhone;
  final String
  status; // 'pending', 'reviewed', 'shortlisted', 'rejected', 'hired'
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Additional fields
  final String? previousEmployment;
  final String? healthConditions;
  final bool? hasTransportation;
  final String? additionalNotes;

  JobApplicationModel({
    this.id,
    required this.jobId,
    required this.applicantUserId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    this.experience,
    this.skills,
    this.availability,
    this.motivation,
    this.emergencyContact,
    this.emergencyPhone,
    this.status = 'pending',
    this.createdAt,
    this.updatedAt,
    this.previousEmployment,
    this.healthConditions,
    this.hasTransportation,
    this.additionalNotes,
  });

  factory JobApplicationModel.fromMap(Map<String, dynamic> map) {
    return JobApplicationModel(
      id: map['id']?.toString() ?? '',
      jobId: map['job_id']?.toString() ?? '',
      applicantUserId: map['applicant_user_id']?.toString() ?? '',
      fullName: map['full_name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      address: map['address']?.toString() ?? '',
      experience: map['experience']?.toString() ?? '',
      skills: map['skills'] != null ? List<String>.from(map['skills']) : [],
      availability: map['availability']?.toString() ?? '',
      motivation: map['motivation']?.toString() ?? '',
      emergencyContact: map['emergency_contact']?.toString() ?? '',
      emergencyPhone: map['emergency_phone']?.toString() ?? '',
      status: map['status']?.toString() ?? 'pending',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
      previousEmployment: map['previous_employment']?.toString(),
      healthConditions: map['health_conditions']?.toString(),
      hasTransportation: map['has_transportation'] ?? false,
      additionalNotes: map['additional_notes']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'job_id': jobId,
      'applicant_user_id': applicantUserId,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'experience': experience,
      'skills': skills,
      'availability': availability,
      'motivation': motivation,
      'emergency_contact': emergencyContact,
      'emergency_phone': emergencyPhone,
      'status': status,
      'previous_employment': previousEmployment,
      'health_conditions': healthConditions,
      'has_transportation': hasTransportation,
      'additional_notes': additionalNotes,
    };
  }

  String get appliedDate {
    if (createdAt == null) return 'Unknown';

    final now = DateTime.now();
    final difference = now.difference(createdAt!);

    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  JobApplicationModel copyWith({
    String? id,
    String? jobId,
    String? applicantUserId,
    String? fullName,
    String? email,
    String? phone,
    String? address,
    String? gender,
    String? experience,
    List<String>? skills,
    String? availability,
    String? motivation,
    List<String>? referencesList,
    String? emergencyContact,
    String? emergencyPhone,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? previousEmployment,
    String? healthConditions,
    bool? hasTransportation,
    String? additionalNotes,
  }) {
    return JobApplicationModel(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      applicantUserId: applicantUserId ?? this.applicantUserId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      experience: experience ?? this.experience,
      skills: skills ?? this.skills,
      availability: availability ?? this.availability,
      motivation: motivation ?? this.motivation,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      previousEmployment: previousEmployment ?? this.previousEmployment,
      healthConditions: healthConditions ?? this.healthConditions,
      hasTransportation: hasTransportation ?? this.hasTransportation,
      additionalNotes: additionalNotes ?? this.additionalNotes,
    );
  }
}
