import '../entity/countries_entity.dart';
import '../repository/countries_repository.dart';

class GetCountryByNameUseCase {
  final CountriesRepository repository;

  GetCountryByNameUseCase({required this.repository});

  Future<CountriesEntity?> call(String name) async {
    return await repository.getCountryByName(name);
  }
}
