import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

import '../model/countries_model.dart';
import 'countries_local_datasource.dart';

class CountriesLocalDataSourceImpl implements CountriesLocalDataSource {
  final SharedPreferences sharedPreferences;
  final Logger logger;

  static const String _countriesKey = 'cached_countries';
  static const String _timestampKey = 'cache_timestamp';
  static const int _cacheValidityHours = 24; // Cache valid for 24 hours

  CountriesLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.logger,
  });

  @override
  Future<List<CountriesModel>?> getCachedCountries() async {
    try {
      // Check if cache is still valid
      if (!await _isCacheValid()) {
        logger.i('Cache is expired, clearing old data');
        await clearCache();
        return null;
      }

      final String? countriesJson = sharedPreferences.getString(_countriesKey);
      if (countriesJson == null) {
        logger.i('No cached countries found');
        return null;
      }

      final List<dynamic> decodedJson = jsonDecode(countriesJson);
      final List<CountriesModel> countries = decodedJson
          .map((countryJson) => CountriesModel.fromJson(countryJson))
          .toList();

      logger.i('Retrieved ${countries.length} countries from cache');
      return countries;
    } catch (e) {
      logger.e('Error retrieving cached countries: $e');
      await clearCache(); // Clear corrupted cache
      return null;
    }
  }

  @override
  Future<void> cacheCountries(List<CountriesModel> countries) async {
    try {
      final List<Map<String, dynamic>> countriesJson =
          countries.map((country) => country.toJson()).toList();

      final String encodedJson = jsonEncode(countriesJson);

      await sharedPreferences.setString(_countriesKey, encodedJson);
      await sharedPreferences.setInt(
        _timestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );

      logger.i('Cached ${countries.length} countries successfully');
    } catch (e) {
      logger.e('Error caching countries: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(_countriesKey);
      await sharedPreferences.remove(_timestampKey);
      logger.i('Cache cleared successfully');
    } catch (e) {
      logger.e('Error clearing cache: $e');
      rethrow;
    }
  }

  @override
  Future<bool> hasCachedData() async {
    try {
      final bool hasData = sharedPreferences.containsKey(_countriesKey);
      final bool isValid = await _isCacheValid();
      return hasData && isValid;
    } catch (e) {
      logger.e('Error checking cached data: $e');
      return false;
    }
  }

  Future<bool> _isCacheValid() async {
    try {
      final int? timestamp = sharedPreferences.getInt(_timestampKey);
      if (timestamp == null) return false;

      final DateTime cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(cacheTime);

      final bool isValid = difference.inHours < _cacheValidityHours;
      logger.d('Cache age: ${difference.inHours} hours, valid: $isValid');

      return isValid;
    } catch (e) {
      logger.e('Error checking cache validity: $e');
      return false;
    }
  }
}
