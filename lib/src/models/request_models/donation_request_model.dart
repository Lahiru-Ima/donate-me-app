class DonationRequestModel {
  final String id;
  final String title;
  final String description;
  final String location;
  final String category;
  final bool isUrgent;
  final DateTime createdAt;
  final Map<String, dynamic> additionalData;

  DonationRequestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.category,
    required this.isUrgent,
    required this.createdAt,
    this.additionalData = const {},
  });

  // Factory constructor to create model from Map
  factory DonationRequestModel.fromMap(Map<String, dynamic> map) {
    return DonationRequestModel(
      id: map['id'] ?? '',
      title: map['type'] ?? map['title'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      category: map['category'] ?? '',
      isUrgent: map['isUrgent'] ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      additionalData: Map<String, dynamic>.from(map)
        ..removeWhere(
          (key, value) => [
            'id',
            'title',
            'type',
            'description',
            'location',
            'category',
            'isUrgent',
            'createdAt',
          ].contains(key),
        ),
    );
  }

  // Convert model to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': title, 
      'description': description,
      'location': location,
      'category': category,
      'isUrgent': isUrgent,
      'createdAt': createdAt.toIso8601String(),
      ...additionalData,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DonationRequestModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
