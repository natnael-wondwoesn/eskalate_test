import '../entity/countries_entity.dart';

abstract class CountriesRepository {
  Future<List<CountriesEntity>> getAllCountries({bool forceRefresh = false});
  Future<CountriesEntity?> getCountryByName(String name);
}
