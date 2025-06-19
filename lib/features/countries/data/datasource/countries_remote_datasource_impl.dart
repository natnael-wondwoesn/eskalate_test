import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/constants/api.dart';
import '../model/countries_model.dart';
import 'countries_remote_datasource.dart';

class CountriesRemoteDataSourceImpl implements CountriesRemoteDataSource {
  final Dio dio;
  final Logger logger;

  CountriesRemoteDataSourceImpl({
    required this.dio,
    required this.logger,
  });

  @override
  Future<List<CountriesModel>> getAllCountries() async {
    try {
      logger.i('Fetching all countries from API');

      final response = await dio.get(
        '$baseUrl/all',
        queryParameters: {
          'status': 'true',
          'fields': 'name,region,subregion,population,area,timezones,flags',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final countries = data
            .map((countryJson) => CountriesModel.fromJson(countryJson))
            .toList();

        logger.i('Successfully fetched ${countries.length} countries');
        return countries;
      } else {
        logger.e('Failed to fetch countries: ${response.statusCode}');
        throw Exception('Failed to fetch countries: ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.e('Dio error while fetching countries: ${e.message}');
      rethrow;
    } catch (e) {
      logger.e('Unexpected error while fetching countries: $e');
      throw Exception('Failed to fetch countries: $e');
    }
  }

  @override
  Future<CountriesModel?> getCountryByName(String name) async {
    try {
      logger.i('Fetching country by name: $name');

      final response = await dio.get(
        '$baseUrl/name/$name',
        queryParameters: {
          'fields': 'name,region,subregion,population,area,timezones,flags',
          'fullText': 'true',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        if (data.isNotEmpty) {
          final country = CountriesModel.fromJson(data.first);
          logger.i('Successfully fetched country: ${country.name}');
          return country;
        } else {
          logger.w('No country found with name: $name');
          return null;
        }
      } else {
        logger.e('Failed to fetch country by name: ${response.statusCode}');
        throw Exception(
            'Failed to fetch country by name: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        logger.w('Country not found: $name');
        return null;
      }
      logger.e('Dio error while fetching country by name: ${e.message}');
      rethrow;
    } catch (e) {
      logger.e('Unexpected error while fetching country by name: $e');
      throw Exception('Failed to fetch country by name: $e');
    }
  }
}
