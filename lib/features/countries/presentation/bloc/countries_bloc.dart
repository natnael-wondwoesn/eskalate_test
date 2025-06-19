import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';

import '../../domain/entity/countries_entity.dart';
import '../../domain/usecase/get_all_countries_usecase.dart';
import '../../domain/usecase/get_country_by_name_usecase.dart';
import 'countries_event.dart';
import 'countries_state.dart';

class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  final GetAllCountriesUseCase getAllCountriesUseCase;
  final GetCountryByNameUseCase getCountryByNameUseCase;
  final Logger _logger = Logger();

  List<CountriesEntity> _allCountries = [];

  CountriesBloc({
    required this.getAllCountriesUseCase,
    required this.getCountryByNameUseCase,
  }) : super(const CountriesInitial()) {
    on<GetAllCountriesEvent>(_onGetAllCountries);
    on<RefreshCountriesEvent>(_onRefreshCountries);
    on<SearchCountriesEvent>(_onSearchCountries);
    on<GetCountryByNameEvent>(_onGetCountryByName);
    on<ResetCountriesEvent>(_onResetCountries);

    // Automatically load countries when BLoC is created
    add(const GetAllCountriesEvent());
  }

  Future<void> _onGetAllCountries(
    GetAllCountriesEvent event,
    Emitter<CountriesState> emit,
  ) async {
    try {
      _logger.i('BLoC: Getting all countries from cache or API');
      emit(const CountriesLoading());

      final countries = await getAllCountriesUseCase.call(forceRefresh: false);
      _allCountries = countries;

      _logger.i('BLoC: Successfully loaded ${countries.length} countries');
      emit(CountriesAllLoaded(countries: countries));
    } catch (e) {
      _logger.e('BLoC: Error getting all countries: $e');
      emit(
          CountriesError(message: 'Failed to load countries: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshCountries(
    RefreshCountriesEvent event,
    Emitter<CountriesState> emit,
  ) async {
    try {
      _logger.i('BLoC: Refreshing countries from API');
      // Don't emit loading state for refresh to avoid UI flicker

      final countries = await getAllCountriesUseCase.call(forceRefresh: true);
      _allCountries = countries;

      _logger.i('BLoC: Successfully refreshed ${countries.length} countries');
      emit(CountriesAllLoaded(countries: countries));
    } catch (e) {
      _logger.e('BLoC: Error refreshing countries: $e');
      // Show error but keep current state if it's already loaded
      if (state is CountriesAllLoaded) {
        // Could emit a special refresh error state here if needed
        emit(CountriesError(message: 'Failed to refresh: ${e.toString()}'));
        // Or keep the current state and show a snackbar from UI
      } else {
        emit(CountriesError(
            message: 'Failed to refresh countries: ${e.toString()}'));
      }
    }
  }

  void _onSearchCountries(
    SearchCountriesEvent event,
    Emitter<CountriesState> emit,
  ) {
    final query = event.query.toLowerCase().trim();

    if (query.isEmpty) {
      // Show all countries if search is empty
      emit(CountriesAllLoaded(countries: _allCountries));
      return;
    }

    // Filter countries based on the search query
    final filteredCountries = _allCountries.where((country) {
      return country.name.toLowerCase().contains(query) ||
          country.region.toLowerCase().contains(query) ||
          country.subregion.toLowerCase().contains(query);
    }).toList();

    _logger.i(
        'BLoC: Search for "$query" returned ${filteredCountries.length} results');
    emit(CountriesAllLoaded(countries: filteredCountries));
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
