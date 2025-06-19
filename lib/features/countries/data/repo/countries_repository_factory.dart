import '../../domain/repository/countries_repository.dart';
import '../datasource/countries_datasource_factory.dart';
import 'countries_repository_impl.dart';

class CountriesRepositoryFactory {
  static Future<CountriesRepository> createRepository() async {
    final remoteDataSource =
        CountriesDataSourceFactory.createRemoteDataSource();
    final localDataSource =
        await CountriesDataSourceFactory.createLocalDataSource();

    return CountriesRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
  }
}
