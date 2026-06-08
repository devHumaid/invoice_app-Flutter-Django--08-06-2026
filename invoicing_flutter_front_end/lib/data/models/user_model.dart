class UserModel {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phoneNumber;
  final String role;
  final bool isApproved;
  final String? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.isApproved,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      role: json['role'],
      isApproved: json['is_approved'] ?? false,
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'username': username,
        'email': email,
        'phone_number': phoneNumber,
        'role': role,
        'is_approved': isApproved,
        'created_at': createdAt,
      };
}
