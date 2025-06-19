import '../entity/countries_entity.dart';

abstract class CountriesRepository {
  Future<List<CountriesEntity>> getAllCountries();
  Future<CountriesEntity?> getCountryByName(String name);
}
