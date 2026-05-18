class UserModel {
  final String? id;
  final String name;
  final String email;
  final String? phone;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.phone,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String?,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}
