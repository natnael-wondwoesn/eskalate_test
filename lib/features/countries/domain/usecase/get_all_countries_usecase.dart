import '../entity/countries_entity.dart';
import '../repository/countries_repository.dart';

class GetAllCountriesUseCase {
  final CountriesRepository repository;

  GetAllCountriesUseCase({required this.repository});

  Future<List<CountriesEntity>> call({bool forceRefresh = false}) async {
    return await repository.getAllCountries(forceRefresh: forceRefresh);
  }
}
