class Profile {
  final String username;
  final String bio;
  final String image;
  final bool following;

  Profile({
    required this.username,
    this.bio = '',
    this.image = '',
    this.following = false,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      username: json['username'] ?? '',
      bio: json['bio'] ?? '',
      image: json['image'] ?? '',
      following: json['following'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'bio': bio,
      'image': image,
      'following': following,
    };
  }

  Profile copyWith({
    String? username,
    String? bio,
    String? image,
    bool? following,
  }) {
    return Profile(
      username: username ?? this.username,
      bio: bio ?? this.bio,
      image: image ?? this.image,
      following: following ?? this.following,
    );
  }
}
