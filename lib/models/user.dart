// ============================================================
//  user.dart — AppUser Model (Employee only)
// ============================================================

class AppUser {
  final String id;
  final String name;
  final String phone;
  final String token;
  final bool isActive;

  const AppUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.token,
    this.isActive = true,
  });

  AppUser copyWith({
    String? id,
    String? name,
    String? phone,
    String? token,
    bool? isActive,
  }) {
    return AppUser(
      id:       id       ?? this.id,
      name:     name     ?? this.name,
      phone:    phone    ?? this.phone,
      token:    token    ?? this.token,
      isActive: isActive ?? this.isActive,
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id:       json['id']       as String,
      name:     json['name']     as String,
      phone:    json['phone']    as String,
      token:    json['token']    as String,
      isActive: (json['isActive'] as bool?) ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id':       id,
    'name':     name,
    'phone':    phone,
    'token':    token,
    'isActive': isActive,
  };

  @override
  String toString() => 'AppUser(id: $id, name: $name, phone: $phone)';
}
