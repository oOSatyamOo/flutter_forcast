import '../../domain/entities/city.dart';

class CityModel extends City {
  const CityModel({
    required super.name,
    required super.country,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      name: json['name'] as String,
      country: json['country'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
    };
  }
}
