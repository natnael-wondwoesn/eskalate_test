import 'package:equatable/equatable.dart';

class CountriesEntity extends Equatable {
  final String name;
  final String region;
  final String subregion;
  final String population;
  final String area;
  final dynamic timezones;
  final dynamic flags;

  const CountriesEntity({
    required this.name,
    required this.region,
    required this.subregion,
    required this.population,
    required this.area,
    required this.timezones,
    required this.flags,
  });

  @override
  List<Object?> get props =>
      [name, region, subregion, population, area, timezones, flags];
}
