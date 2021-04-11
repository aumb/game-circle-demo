import 'package:equatable/equatable.dart';

class Contact extends Equatable {
  final String? phoneNumber;
  final String? email;

  Contact({
    required this.phoneNumber,
    required this.email,
  });

  @override
  List<Object?> get props => [phoneNumber, email];
}
