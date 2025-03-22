class UserModel {
  final String email;
  final String phone;
  final String name;
  final String address;
  final String id ;

  UserModel({
    required this.email,
    required this.phone,
    required this.name,
    required this.address,
    required this.id,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id:json['user_id'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'user_id':id,
      'email': email,
      'phone': phone,
      'name': name,
      'address': address,
    };
  }

  // Copy with function
  UserModel copyWith({
    String? email,
    String? phone,
    String? name,
    String? address,
    String ? id ,
  }) {
    return UserModel(
      id:  id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      address: address ?? this.address,
    );
  }
}