import 'package:flutter_test/flutter_test.dart';
import 'package:skycast/data/models/city_model.dart';
import 'package:skycast/domain/entities/city.dart';

void main() {
  const tCityModel = CityModel(name: 'London', country: 'GB');

  test('should be a subclass of City entity', () async {
    // assert
    expect(tCityModel, isA<City>());
  });

  group('fromJson', () {
    test('should return a valid city model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "name": "London",
        "country": "GB"
      };

      // act
      final result = CityModel.fromJson(jsonMap);

      // assert
      expect(result, tCityModel);
    });
  });

  group('toJson', () {
    test('should return exactly mapped dictionary data', () async {
      // act
      final result = tCityModel.toJson();

      // assert
      final expectedMap = {
        "name": "London",
        "country": "GB"
      };
      expect(result, expectedMap);
    });
  });
}
