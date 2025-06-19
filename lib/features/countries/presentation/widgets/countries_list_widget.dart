import 'package:flutter/material.dart';
import '../../domain/entity/countries_entity.dart';

class CountriesListWidget extends StatelessWidget {
  final List<CountriesEntity> countries;

  const CountriesListWidget({
    super.key,
    required this.countries,
  });

  @override
  Widget build(BuildContext context) {
    if (countries.isEmpty) {
      return const Center(
        child: Text(
          'No countries found',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: countries.length,
      itemBuilder: (context, index) {
        final country = countries[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text(
                country.name.isNotEmpty ? country.name[0].toUpperCase() : '?',
                style: TextStyle(
                  color: Colors.blue.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              country.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Region: ${country.region}'),
                if (country.subregion.isNotEmpty)
                  Text('Subregion: ${country.subregion}'),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Pop: ${_formatNumber(country.population)}',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  'Area: ${_formatNumber(country.area)} km²',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            onTap: () => _showCountryDetails(context, country),
          ),
        );
      },
    );
  }

  String _formatNumber(String number) {
    final num = int.tryParse(number);
    if (num == null) return number;

    if (num >= 1000000) {
      return '${(num / 1000000).toStringAsFixed(1)}M';
    } else if (num >= 1000) {
      return '${(num / 1000).toStringAsFixed(1)}K';
    }
    return number;
  }

  void _showCountryDetails(BuildContext context, CountriesEntity country) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(country.name),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Region', country.region),
                _buildDetailRow('Subregion', country.subregion),
                _buildDetailRow('Population', country.population),
                _buildDetailRow('Area', '${country.area} km²'),
                const SizedBox(height: 8),
                const Text(
                  'Timezones:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                if (country.timezones is List)
                  ...((country.timezones as List).map((tz) => Text('• $tz')))
                else
                  Text('• ${country.timezones}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
