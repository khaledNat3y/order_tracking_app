class UserModel {
  final String userName;
  final String email;
  final String uid;

  UserModel({required this.userName, required this.email, required this.uid});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userName: json['userName'],
      email: json['email'],
      uid: json['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'email': email,
      'uid': uid,
    };
  }
}