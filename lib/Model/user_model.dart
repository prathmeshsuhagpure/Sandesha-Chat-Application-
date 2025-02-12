class UserModel {
  final String phone; // Phone number (required, unique)
  final String? name; // Optional name of the user
  final DateTime createdAt; // Date when the user was created

  UserModel({
    required this.phone,
    this.name,
    required this.createdAt,
  });

  // Factory constructor to create a UserModel from a JSON object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      phone: json['phone'],
      name: json['name'], // This will be null if not provided in the backend response
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Method to convert a UserModel instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
