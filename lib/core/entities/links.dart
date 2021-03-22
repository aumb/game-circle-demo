import 'package:equatable/equatable.dart';

class Links extends Equatable {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  Links({
    required this.first,
    required this.last,
    required this.prev,
    required this.next,
  });

  @override
  List<Object?> get props => [first, last, prev, next];
}
