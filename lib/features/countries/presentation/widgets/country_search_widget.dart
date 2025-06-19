import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/countries_entity.dart';
import '../bloc/countries_bloc.dart';
import '../bloc/countries_event.dart';
import '../bloc/countries_state.dart';

class CountrySearchWidget extends StatefulWidget {
  const CountrySearchWidget({super.key});

  @override
  State<CountrySearchWidget> createState() => _CountrySearchWidgetState();
}

class _CountrySearchWidgetState extends State<CountrySearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search Input
          TextField(
            controller: _searchController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              labelText: 'Enter country name',
              hintText: 'e.g., Germany, France, Japan',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  context
                      .read<CountriesBloc>()
                      .add(const ResetCountriesEvent());
                },
              ),
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (value) => _searchCountry(context, value),
          ),
          const SizedBox(height: 16),

          // Search Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _searchCountry(context, _searchController.text),
              child: const Text('Search Country'),
            ),
          ),
          const SizedBox(height: 24),

          // Search Results
          Expanded(
            child: BlocBuilder<CountriesBloc, CountriesState>(
              builder: (context, state) {
                return _buildSearchResults(state);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _searchCountry(BuildContext context, String countryName) {
    if (countryName.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a country name'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    context.read<CountriesBloc>().add(
          GetCountryByNameEvent(countryName: countryName.trim()),
        );
    _focusNode.unfocus();
  }

  Widget _buildSearchResults(CountriesState state) {
    if (state is CountriesInitial) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Enter a country name to search',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    } else if (state is CountriesLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Searching...'),
          ],
        ),
      );
    } else if (state is CountriesSingleLoaded) {
      return _buildCountryCard(state.country);
    } else if (state is CountriesNotFound) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            Text(
              state.message,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Try searching for a different country',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    } else if (state is CountriesError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Error: ${state.message}',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _searchCountry(context, _searchController.text),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildCountryCard(CountriesEntity country) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Country Name
            Text(
              country.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Country Details
            _buildDetailRow(Icons.public, 'Region', country.region),
            _buildDetailRow(Icons.location_on, 'Subregion', country.subregion),
            _buildDetailRow(Icons.people, 'Population',
                _formatPopulation(country.population)),
            _buildDetailRow(Icons.crop_free, 'Area', '${country.area} km²'),

            // Timezones
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'Timezones',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (country.timezones is List)
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: (country.timezones as List)
                    .map((tz) => Chip(
                          label: Text(tz.toString()),
                          backgroundColor: Colors.blue.shade50,
                        ))
                    .toList(),
              )
            else
              Chip(
                label: Text(country.timezones.toString()),
                backgroundColor: Colors.blue.shade50,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 16),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPopulation(String population) {
    final num = int.tryParse(population);
    if (num == null) return population;

    if (num >= 1000000000) {
      return '${(num / 1000000000).toStringAsFixed(1)}B';
    } else if (num >= 1000000) {
      return '${(num / 1000000).toStringAsFixed(1)}M';
    } else if (num >= 1000) {
      return '${(num / 1000).toStringAsFixed(1)}K';
    }
    return num.toString();
  }
}
