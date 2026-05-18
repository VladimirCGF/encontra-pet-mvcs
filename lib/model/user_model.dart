class UserModel {
  final String? id;
  final String name;
  final String email;
  final String? phone;
  final String syncStatus;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.phone,
    this.syncStatus = 'synced',
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String?,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String?,
      syncStatus: map['sync_status'] as String? ?? 'synced',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'sync_status': syncStatus,
    };
  }
}
