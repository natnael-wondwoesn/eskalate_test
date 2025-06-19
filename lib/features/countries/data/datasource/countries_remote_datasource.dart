import '../model/countries_model.dart';

abstract class CountriesRemoteDataSource {
  Future<List<CountriesModel>> getAllCountries();
  Future<CountriesModel?> getCountryByName(String name);
}
