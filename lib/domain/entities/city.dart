import 'package:equatable/equatable.dart';

class City extends Equatable {
  final String name;
  final String country;

  const City({
    required this.name,
    required this.country,
  });

  @override
  List<Object?> get props => [name, country];
}
