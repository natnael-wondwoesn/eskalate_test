import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';

import '../../domain/usecase/get_all_countries_usecase.dart';
import '../../domain/usecase/get_country_by_name_usecase.dart';
import 'countries_event.dart';
import 'countries_state.dart';

class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  final GetAllCountriesUseCase getAllCountriesUseCase;
  final GetCountryByNameUseCase getCountryByNameUseCase;
  final Logger _logger = Logger();

  CountriesBloc({
    required this.getAllCountriesUseCase,
    required this.getCountryByNameUseCase,
  }) : super(const CountriesInitial()) {
    on<GetAllCountriesEvent>(_onGetAllCountries);
    on<GetCountryByNameEvent>(_onGetCountryByName);
    on<ResetCountriesEvent>(_onResetCountries);
  }

  Future<void> _onGetAllCountries(
    GetAllCountriesEvent event,
    Emitter<CountriesState> emit,
  ) async {
    try {
      _logger.i('BLoC: Getting all countries');
      emit(const CountriesLoading());

      final countries = await getAllCountriesUseCase.call();

      _logger.i('BLoC: Successfully loaded ${countries.length} countries');
      emit(CountriesAllLoaded(countries: countries));
    } catch (e) {
      _logger.e('BLoC: Error getting all countries: $e');
      emit(
          CountriesError(message: 'Failed to load countries: ${e.toString()}'));
    }
  }

  Future<void> _onGetCountryByName(
    GetCountryByNameEvent event,
    Emitter<CountriesState> emit,
  ) async {
    try {
      _logger.i('BLoC: Getting country by name: ${event.countryName}');
      emit(const CountriesLoading());

      final country = await getCountryByNameUseCase.call(event.countryName);

      if (country != null) {
        _logger.i('BLoC: Successfully loaded country: ${country.name}');
        emit(CountriesSingleLoaded(country: country));
      } else {
        _logger.w('BLoC: Country not found: ${event.countryName}');
        emit(CountriesNotFound(
            message: 'Country "${event.countryName}" not found'));
      }
    } catch (e) {
      _logger.e('BLoC: Error getting country by name: $e');
      emit(CountriesError(message: 'Failed to load country: ${e.toString()}'));
    }
  }

  Future<void> _onResetCountries(
    ResetCountriesEvent event,
    Emitter<CountriesState> emit,
  ) async {
    _logger.i('BLoC: Resetting countries state');
    emit(const CountriesInitial());
  }
}
