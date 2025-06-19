import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/favorites/favorites_cubit.dart';
import '../../domain/entity/countries_entity.dart';

class CountryDetailPage extends StatelessWidget {
  final CountriesEntity country;

  const CountryDetailPage({
    super.key,
    required this.country,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and country name
            _buildHeader(context),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Flag image
                    _buildFlagSection(),

                    // Key Statistics section
                    _buildKeyStatistics(),

                    // Timezone section
                    _buildTimezoneSection(),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              country.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          // Favorite button
          BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              final isFavorite =
                  context.read<FavoritesCubit>().isFavorite(country.name);

              return GestureDetector(
                onTap: () {
                  context.read<FavoritesCubit>().toggleFavorite(country.name);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                    size: 24,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFlagSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _buildFlagImage(),
      ),
    );
  }

  Widget _buildFlagImage() {
    try {
      if (country.flags is Map && country.flags['svg'] != null) {
        return Image.network(
          country.flags['svg'],
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.grey[200],
              child: const Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildFallbackFlag();
          },
        );
      }
    } catch (e) {
      return _buildFallbackFlag();
    }

    return _buildFallbackFlag();
  }

  Widget _buildFallbackFlag() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.flag,
          color: Colors.grey[500],
          size: 48,
        ),
      ),
    );
  }

  Widget _buildKeyStatistics() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Key Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          _buildStatRow('Area', _formatArea(country.area)),
          _buildStatRow('Population', _formatPopulation(country.population)),
          _buildStatRow('Region', country.region),
          _buildStatRow('Sub Region', country.subregion),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimezoneSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Timezone',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          _buildTimezoneChips(),
        ],
      ),
    );
  }

  Widget _buildTimezoneChips() {
    List<String> timezones = [];

    if (country.timezones is List) {
      timezones =
          (country.timezones as List).map((tz) => tz.toString()).toList();
    } else if (country.timezones != null) {
      timezones = [country.timezones.toString()];
    }

    if (timezones.isEmpty) {
      return Text(
        'No timezone information available',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: timezones.map((timezone) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Text(
            timezone,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatArea(String area) {
    final num = double.tryParse(area);
    if (num == null) return area;

    // Format with comma thousands separator
    final formattedNumber = num.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );

    return '$formattedNumber sq km';
  }

  String _formatPopulation(String population) {
    final num = double.tryParse(population);
    if (num == null) return population;

    if (num >= 1000000000) {
      return '${(num / 1000000000).toStringAsFixed(2)} billion';
    } else if (num >= 1000000) {
      return '${(num / 1000000).toStringAsFixed(2)} million';
    } else if (num >= 1000) {
      return '${(num / 1000).toStringAsFixed(1)} thousand';
    }
    return num.toStringAsFixed(0);
  }
}
