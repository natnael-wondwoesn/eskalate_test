import '../../domain/repository/countries_repository.dart';
import '../datasource/countries_datasource_factory.dart';
import 'countries_repository_impl.dart';

class CountriesRepositoryFactory {
  static CountriesRepository createRepository() {
    final remoteDataSource =
        CountriesDataSourceFactory.createRemoteDataSource();

    return CountriesRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );
  }
}
