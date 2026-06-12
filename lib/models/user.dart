class AppUser {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String? photoUrl;
  final String role;

  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    this.photoUrl,
    this.role = "user",
  });

  factory AppUser.fromFirestore(String uid, Map<String, dynamic> data) {
    return AppUser(
      uid: uid,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      photoUrl: data['photoUrl'],
      role: data['role'] ?? 'user',
    );
  }

  factory AppUser.fromCache(Map<String, String?> data) {
    return AppUser(
      uid: data['uid'] ?? '',
      name: data['name'] ?? 'Sem nome',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      photoUrl: data['photoUrl'],
      role: data['role'] ?? 'user',
    );
  }

  /// Map pros campos do documento no Firestore (sem metadados como
  /// createdAt/updatedAt, que ficam a cargo de quem persiste).
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'role': role,
    };
  }

  /// Map pro cache local. As chaves espelham o que [AppUser.fromCache] lê.
  Map<String, String?> toCacheMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'role': role,
    };
  }

  bool get isAdmin => role == 'admin';
}