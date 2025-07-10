class UserModel {
  final String id;
  final String email;
  final String name;
  final String phoneNumber;
  final String? dateOfBirth;
  final String? gender;
  final String? profileImgUrl;
  final DateTime? createdAt;

  UserModel({
    required this.name,
    required this.phoneNumber,
    required this.id,
    required this.email,
    this.dateOfBirth,
    this.gender,
    this.profileImgUrl,
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      dateOfBirth: map['date_of_birth'],
      gender: map['gender'],
      profileImgUrl: map['profile_img_url'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone_number': phoneNumber,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'profile_img_url': profileImgUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
