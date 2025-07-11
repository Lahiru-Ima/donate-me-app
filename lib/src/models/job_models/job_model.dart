class JobModel {
  final String? id;
  final String userId;
  final String title;
  final String type;
  final String location;
  final String workHours;
  final String salary;
  final List<String> requiredSkills;
  final String preferredGender;
  final String preferredAge;
  final String description;
  final String postedBy;
  final bool urgentHiring;
  final String status; // 'active', 'paused', 'filled', 'cancelled'
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Contact Information
  final String? contactPerson;
  final String? contactPhone;
  final String? contactEmail;

  // Additional Information
  final String? requirements;
  final String? benefits;
  final String? workEnvironment;
  final String? additionalNotes;

  JobModel({
    this.id,
    required this.userId,
    required this.title,
    required this.type,
    required this.location,
    required this.workHours,
    required this.salary,
    required this.requiredSkills,
    required this.preferredGender,
    required this.preferredAge,
    required this.description,
    required this.postedBy,
    required this.urgentHiring,
    this.status = 'active',
    this.createdAt,
    this.updatedAt,
 this.contactPerson,
   this.contactPhone,
   this.contactEmail,
    this.requirements,
    this.benefits,
    this.workEnvironment,
    this.additionalNotes,
  });

  factory JobModel.fromMap(Map<String, dynamic> map) {
    return JobModel(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      type: map['type']?.toString() ?? '',
      location: map['location']?.toString() ?? '',
      workHours: map['work_hours']?.toString() ?? '',
      salary: map['salary']?.toString() ?? '',
      requiredSkills: map['required_skills'] != null
          ? List<String>.from(map['required_skills'])
          : [],
      preferredGender: map['preferred_gender']?.toString() ?? '',
      preferredAge: map['preferred_age']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      postedBy: map['posted_by']?.toString() ?? '',
      urgentHiring: map['urgent_hiring'] ?? false,
      status: map['status']?.toString() ?? 'active',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
      contactPerson: map['contact_person']?.toString() ?? '',
      contactPhone: map['contact_phone']?.toString() ?? '',
      contactEmail: map['contact_email']?.toString() ?? '',
      requirements: map['requirements']?.toString(),
      benefits: map['benefits']?.toString(),
      workEnvironment: map['work_environment']?.toString(),
      additionalNotes: map['additional_notes']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'title': title,
      'type': type,
      'location': location,
      'work_hours': workHours,
      'salary': salary,
      'required_skills': requiredSkills,
      'preferred_gender': preferredGender,
      'preferred_age': preferredAge,
      'description': description,
      'posted_by': postedBy,
      'urgent_hiring': urgentHiring,
      'status': status,
      'contact_person': contactPerson,
      'contact_phone': contactPhone,
      'contact_email': contactEmail,
      'requirements': requirements,
      'benefits': benefits,
      'work_environment': workEnvironment,
      'additional_notes': additionalNotes,
    };
  }

  String get postedDate {
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

  JobModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? type,
    String? location,
    String? workHours,
    String? salary,
    List<String>? requiredSkills,
    String? preferredGender,
    String? preferredAge,
    String? description,
    String? postedBy,
    bool? urgentHiring,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? contactPerson,
    String? contactPhone,
    String? contactEmail,
    String? requirements,
    String? benefits,
    String? workEnvironment,
    String? additionalNotes,
  }) {
    return JobModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      type: type ?? this.type,
      location: location ?? this.location,
      workHours: workHours ?? this.workHours,
      salary: salary ?? this.salary,
      requiredSkills: requiredSkills ?? this.requiredSkills,
      preferredGender: preferredGender ?? this.preferredGender,
      preferredAge: preferredAge ?? this.preferredAge,
      description: description ?? this.description,
      postedBy: postedBy ?? this.postedBy,
      urgentHiring: urgentHiring ?? this.urgentHiring,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      contactPerson: contactPerson ?? this.contactPerson,
      contactPhone: contactPhone ?? this.contactPhone,
      contactEmail: contactEmail ?? this.contactEmail,
      requirements: requirements ?? this.requirements,
      benefits: benefits ?? this.benefits,
      workEnvironment: workEnvironment ?? this.workEnvironment,
      additionalNotes: additionalNotes ?? this.additionalNotes,
    );
  }
}
