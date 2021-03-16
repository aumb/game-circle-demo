import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int? id;
  final String? name;
  final String? imageUrl;
  final String? email;

  ///Used for post api calls
  final String? password;

  ///Used for post api calls
  final String? confirmPassword;

  User({
    this.id,
    this.name,
    this.imageUrl,
    this.email,
    this.password,
    this.confirmPassword,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        email,
        password,
        confirmPassword,
      ];
}
