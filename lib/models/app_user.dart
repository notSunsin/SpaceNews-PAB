class AppUser {
  final String uid;
  final String fullName;
  final String email;
  final String instagram;
  final String photoUrl;

  AppUser({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.instagram,
    required this.photoUrl,
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> map) {
    return AppUser(
      uid: uid,
      fullName: map['fullName']?.toString() ?? '-',
      email: map['email']?.toString() ?? '-',
      instagram: map['instagram']?.toString() ?? '-',
      photoUrl: map['photoUrl']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'instagram': instagram,
      'photoUrl': photoUrl,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}
