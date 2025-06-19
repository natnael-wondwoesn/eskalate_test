import '../../domain/entity/countries_entity.dart';
import '../../domain/repository/countries_repository.dart';
import '../datasource/countries_remote_datasource.dart';

class CountriesRepositoryImpl implements CountriesRepository {
  final CountriesRemoteDataSource remoteDataSource;

  CountriesRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<CountriesEntity>> getAllCountries() async {
    try {
      final countriesModels = await remoteDataSource.getAllCountries();
      return countriesModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get all countries: $e');
    }
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
}
