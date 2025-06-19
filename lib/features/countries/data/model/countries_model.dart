import '../../domain/entity/countries_entity.dart';

class CountriesModel extends CountriesEntity {
  const CountriesModel({
    required super.name,
    required super.region,
    required super.subregion,
    required super.population,
    required super.area,
    required super.timezones,
  });

  factory CountriesModel.fromJson(Map<String, dynamic> json) {
    return CountriesModel(
      name: json['name']?['common'] ?? '',
      region: json['region'] ?? '',
      subregion: json['subregion'] ?? '',
      population: json['population']?.toString() ?? '0',
      area: json['area']?.toString() ?? '0',
      timezones: json['timezones'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': {'common': name},
      'region': region,
      'subregion': subregion,
      'population': int.tryParse(population) ?? 0,
      'area': double.tryParse(area) ?? 0.0,
      'timezones': timezones,
    };
  }

  CountriesEntity toEntity() {
    return CountriesEntity(
      name: name,
      region: region,
      subregion: subregion,
      population: population,
      area: area,
      timezones: timezones,
    );
  }
}
