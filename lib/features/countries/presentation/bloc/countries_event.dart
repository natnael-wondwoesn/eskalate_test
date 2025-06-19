import 'package:equatable/equatable.dart';

abstract class CountriesEvent extends Equatable {
  const CountriesEvent();

  @override
  List<Object?> get props => [];
}

class GetAllCountriesEvent extends CountriesEvent {
  const GetAllCountriesEvent();
}

class RefreshCountriesEvent extends CountriesEvent {
  const RefreshCountriesEvent();
}

class GetCountryByNameEvent extends CountriesEvent {
  final String countryName;

  const GetCountryByNameEvent({required this.countryName});

  @override
  List<Object?> get props => [countryName];
}

class ResetCountriesEvent extends CountriesEvent {
  const ResetCountriesEvent();
}
