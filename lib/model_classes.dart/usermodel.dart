class UserDetails {
  String? id;
  String? email;
  String? password;
  String? profile;
  String? name;
  String? username;
  String? bio;
  bool? isEmailverified;
  bool? isPrivate;
  List<String>? followers;
  List<String>? following;
  List<String>? followRequest;
  String? uid;

  UserDetails({
    this.id,
    this.email,
    this.password,
    this.profile,
    this.name,
    this.username,
    this.bio,
    this.isEmailverified,
    this.followers,
    this.following,
    this.followRequest,
    this.isPrivate,
    this.uid,
  });

  Map<String,dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'profile': profile,
      'name': name,
      'username': username,
      'bio': bio,
      'isEmailVerfied': isEmailverified,
      'followers': followers,
      'following': following,
      'followRequest': followRequest,
      'isPrivate': isPrivate,
      'uid': uid,
    };
  }

  factory UserDetails.fromMap(Map<String,dynamic> map,{String? documentId}){
    return UserDetails(
      id: documentId,
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      profile: map['profile'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      bio: map['bio'] ?? '',
      isEmailverified: map['isEmailVerified'] ?? false,
      followers: List<String>.from(map['followers'] ?? []),
      following: List<String>.from(map['following'] ?? []),
      followRequest: List<String>.from(map['followRequest'] ?? []),
      isPrivate: map['isPrivate'] ?? false,
      uid: map['uid'] ?? '',
    );
  }

  UserDetails copyWith({
  String? id,
  String? email,
  String? password,
  String? profile,
  String? name,
  String? username,
  String? bio,
  bool? isEmailverified,
  bool? isPrivate,
  List<String>? followers,
  List<String>? following,
  List<String>? followRequest,
  String? uid,
  bool? isAccepted,
}) {
  return UserDetails(
    id: id ?? this.id,
    email: email ?? this.email,
    password: password ?? this.password,
    profile: profile ?? this.profile,
    name: name ?? this.name,
    username: username ?? this.username,
    bio: bio ?? this.bio,
    isEmailverified: isEmailverified ?? this.isEmailverified,
    isPrivate: isPrivate ?? this.isPrivate,
    followers: followers ?? this.followers,
    following: following ?? this.following,
    followRequest: followRequest ?? this.followRequest,
    uid: uid ?? this.uid,
  );
}

}