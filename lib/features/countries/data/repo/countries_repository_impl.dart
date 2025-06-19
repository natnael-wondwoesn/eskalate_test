import '../../domain/entity/countries_entity.dart';
import '../../domain/repository/countries_repository.dart';
import '../datasource/countries_remote_datasource.dart';
import '../datasource/countries_local_datasource.dart';

class CountriesRepositoryImpl implements CountriesRepository {
  final CountriesRemoteDataSource remoteDataSource;
  final CountriesLocalDataSource localDataSource;

  CountriesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<CountriesEntity>> getAllCountries(
      {bool forceRefresh = false}) async {
    try {
      // If force refresh is requested, skip cache and fetch from API
      if (forceRefresh) {
        return await _fetchFromRemoteAndCache();
      }

      // First, try to get from cache
      final cachedCountries = await localDataSource.getCachedCountries();
      if (cachedCountries != null && cachedCountries.isNotEmpty) {
        return cachedCountries.map((model) => model.toEntity()).toList();
      }

      // If no cache or cache is empty, fetch from remote
      return await _fetchFromRemoteAndCache();
    } catch (e) {
      // If remote fails, try cache as fallback
      final cachedCountries = await localDataSource.getCachedCountries();
      if (cachedCountries != null && cachedCountries.isNotEmpty) {
        return cachedCountries.map((model) => model.toEntity()).toList();
      }
      throw Exception('Failed to get all countries: $e');
    }
  }

  Future<List<CountriesEntity>> _fetchFromRemoteAndCache() async {
    final countriesModels = await remoteDataSource.getAllCountries();

    // Cache the fetched data
    await localDataSource.cacheCountries(countriesModels);

    return countriesModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<CountriesEntity?> getCountryByName(String name) async {
    try {
      final countryModel = await remoteDataSource.getCountryByName(name);
      return countryModel?.toEntity();
    } catch (e) {
      throw Exception('Failed to get country by name: $e');
    }
  }

  Future<bool> hasCachedData() async {
    return await localDataSource.hasCachedData();
  }

  Future<void> clearCache() async {
    await localDataSource.clearCache();
  }
}
