import '../model/countries_model.dart';

abstract class CountriesLocalDataSource {
  Future<List<CountriesModel>?> getCachedCountries();
  Future<void> cacheCountries(List<CountriesModel> countries);
  Future<void> clearCache();
  Future<bool> hasCachedData();
}
