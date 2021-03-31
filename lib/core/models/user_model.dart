import 'package:gamecircle/core/entities/user.dart';

class UserModel extends User {
  UserModel({
    int? id,
    String? name,
    String? imageUrl,
    String? email,
    String? password,
    String? confirmPassword,
  }) : super(
          id: id,
          name: name,
          imageUrl: imageUrl,
          email: email,
          password: password,
          confirmPassword: confirmPassword,
        );

  factory UserModel.fromJson(Map<String, dynamic>? json) {
    final Map<String, dynamic>? innerBody = json?['data'];
    if (innerBody != null) {
      return UserModel(
        id: innerBody['id'],
        name: innerBody['name'],
        email: innerBody['email'],
        imageUrl: innerBody['avatar'],
      );
    }
    return UserModel(
      id: json?['id'],
      name: json?['name'],
      email: json?['email'],
      imageUrl: json?['avatar'],
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (password != null) 'password': password,
        if (confirmPassword != null) 'confirm_password': confirmPassword,
      };
}
