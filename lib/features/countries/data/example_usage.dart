import 'package:logger/logger.dart';
import '../domain/entity/countries_entity.dart';
import '../domain/repository/countries_repository.dart';
import 'repo/countries_repository_factory.dart';

/// Example usage of the Countries data layer
///
/// This example demonstrates how to:
/// 1. Create a repository instance using the factory
/// 2. Fetch all countries
/// 3. Fetch a specific country by name
/// 4. Handle errors appropriately
class CountriesDataLayerExample {
  late final CountriesRepository _repository;
  final _logger = Logger();
  bool _initialized = false;

  /// Initialize the repository
  Future<void> initialize() async {
    if (!_initialized) {
      _repository = await CountriesRepositoryFactory.createRepository();
      _initialized = true;
    }
  }

  /// Example: Fetch all countries
  Future<void> fetchAllCountriesExample() async {
    await initialize();

    try {
      _logger.i('Starting to fetch all countries...');

      final List<CountriesEntity> countries =
          await _repository.getAllCountries();

      _logger.i('Successfully fetched ${countries.length} countries');

      // Print first 5 countries as example
      for (int i = 0; i < countries.take(5).length; i++) {
        final country = countries[i];
        _logger.i('Country ${i + 1}: ${country.name} (${country.region})');
      }
    } catch (e) {
      _logger.e('Error fetching all countries: $e');
      rethrow;
    }
  }

  /// Example: Fetch a specific country by name
  Future<void> fetchCountryByNameExample(String countryName) async {
    await initialize();

    try {
      _logger.i('Starting to fetch country: $countryName');

      final CountriesEntity? country =
          await _repository.getCountryByName(countryName);

      if (country != null) {
        _logger.i('Successfully fetched country: ${country.name}');
        _logger.i('Region: ${country.region}');
        _logger.i('Subregion: ${country.subregion}');
        _logger.i('Population: ${country.population}');
        _logger.i('Area: ${country.area}');
        _logger.i('Timezones: ${country.timezones}');
      } else {
        _logger.w('No country found with name: $countryName');
      }
    } catch (e) {
      _logger.e('Error fetching country by name: $e');
      rethrow;
    }
  }

  /// Example: Search for multiple countries
  Future<void> searchMultipleCountriesExample(List<String> countryNames) async {
    await initialize();

    _logger.i('Starting to search for multiple countries...');

    final List<Future<CountriesEntity?>> futures =
        countryNames.map((name) => _repository.getCountryByName(name)).toList();

    try {
      final List<CountriesEntity?> results = await Future.wait(futures);

      for (int i = 0; i < countryNames.length; i++) {
        final country = results[i];
        if (country != null) {
          _logger.i('Found: ${country.name} (${country.region})');
        } else {
          _logger.w('Not found: ${countryNames[i]}');
        }
      }
    } catch (e) {
      _logger.e('Error searching multiple countries: $e');
      rethrow;
    }
  }

  /// Example: Fetch with force refresh
  Future<void> fetchAllCountriesWithRefreshExample() async {
    await initialize();

    try {
      _logger.i('Starting to fetch all countries with force refresh...');

      final List<CountriesEntity> countries =
          await _repository.getAllCountries(forceRefresh: true);

      _logger.i('Successfully fetched ${countries.length} countries from API');
    } catch (e) {
      _logger.e('Error fetching countries with refresh: $e');
      rethrow;
    }
  }
}

// Example usage in main function or widget
void main() async {
  final example = CountriesDataLayerExample();

  // Example 1: Fetch all countries
  await example.fetchAllCountriesExample();

  // Example 2: Fetch specific country
  await example.fetchCountryByNameExample('Germany');

  // Example 3: Search multiple countries
  await example.searchMultipleCountriesExample(['France', 'Japan', 'Brazil']);

  // Example 4: Force refresh
  await example.fetchAllCountriesWithRefreshExample();
}
