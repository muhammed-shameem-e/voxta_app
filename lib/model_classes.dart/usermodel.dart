class UserDetails {
  String? email;
  String? password;
  String? profile;
  String? name;
  String? username;
  String? bio;
  bool? isEmailverified;

  UserDetails({
    this.email,
    this.password,
    this.profile,
    this.name,
    this.username,
    this.bio,
    this.isEmailverified,
  });

  Map<String,dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'profile': profile,
      'name': name,
      'username': username,
      'bio': bio,
      'isEmailVerfied': isEmailverified,
    };
  }

  factory UserDetails.fromMap(Map<String,dynamic> map){
    return UserDetails(
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      profile: map['profile'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      bio: map['bio'] ?? '',
      isEmailverified: map['isEmailVerified'],
    );
  }
}