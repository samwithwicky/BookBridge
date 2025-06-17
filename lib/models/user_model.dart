class User {
  final String id;
  final String name;
  final String email;
  final String? bio;
  final String? profileImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.bio,
    this.profileImage,
  });

  // copyWith method for easy updates
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? bio,
    String? profileImage,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
