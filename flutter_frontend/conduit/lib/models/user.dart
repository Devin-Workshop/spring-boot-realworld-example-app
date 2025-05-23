class User {
  final String email;
  final String token;
  final String username;
  final String bio;
  final String image;

  User({
    required this.email,
    required this.token,
    required this.username,
    this.bio = '',
    this.image = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] ?? '',
      token: json['token'] ?? '',
      username: json['username'] ?? '',
      bio: json['bio'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'token': token,
      'username': username,
      'bio': bio,
      'image': image,
    };
  }

  User copyWith({
    String? email,
    String? token,
    String? username,
    String? bio,
    String? image,
  }) {
    return User(
      email: email ?? this.email,
      token: token ?? this.token,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      image: image ?? this.image,
    );
  }
}
