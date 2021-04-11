import 'package:gamecircle/features/lounges/domain/entities/contact.dart';

class ContactModel extends Contact {
  ContactModel({
    required String? phoneNumber,
    required String? email,
  }) : super(
          phoneNumber: phoneNumber,
          email: email,
        );

  factory ContactModel.fromJson(Map<String, dynamic>? json) {
    return ContactModel(
      phoneNumber: json?['phone_number'],
      email: json?['email'],
    );
  }
}
