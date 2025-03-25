class UserModel {
  final String email;
  final String phone;
  final String name;
  final String address;
  final String id ;
  final String bio ;
  final String userName;
  final String imageUrl;
  final int profilePoints;
  final bool isProfileCompleted;
  UserModel({
    required this.email,
    required this.phone,
    required this.name,
    required this.address,
    required this.id,
    required this.bio,
    required this.userName,
    required this.imageUrl,
    required this.isProfileCompleted,
    required this.profilePoints,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id:json['user_id'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      bio: json['bio'] ?? '',
      userName: json['userName'] ?? '',
      imageUrl: json['userName'] ?? '',
      profilePoints: (json['profilePoints'] as num).toInt(),
      isProfileCompleted: json['isProfileCompleted'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'user_id':id,
      'email': email,
      'phone': phone,
      'name': name,
      'address': address,
      'bio':bio,
      'userName':userName,
      'imageUrl':imageUrl,
      'isProfileCompleted':isProfileCompleted,
      'profilePoints':profilePoints
    };
  }

  UserModel copyWith({
    String? email,
    String? phone,
    String? name,
    String? address,
    String? id,
    String? bio,
    String? userName,
    String? imageUrl,
    bool ? isProfileCompleted,
    int ? profilePoints,
  }) {
    return UserModel(
      isProfileCompleted:  isProfileCompleted ?? this.isProfileCompleted,
      profilePoints:  profilePoints ?? this.profilePoints,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      address: address ?? this.address,
      id: id ?? this.id,
      bio: bio ?? this.bio,
      userName: userName ?? this.userName,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}