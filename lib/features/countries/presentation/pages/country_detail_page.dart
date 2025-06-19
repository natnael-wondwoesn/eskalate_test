import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and country name
            _buildHeader(context),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Flag image
                    _buildFlagSection(),

                    // Key Statistics section
                    _buildKeyStatistics(context),

                    // Timezone section
                    _buildTimezoneSection(context),

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
              child: Icon(
                Icons.arrow_back,
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              country.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
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
                    color: isFavorite
                        ? Colors.red
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        height: 240,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: _buildFlagImage(),
        ),
      ),
    );
  }

  Widget _buildFlagImage() {
    try {
      if (country.flags is Map) {
        // Try SVG first
        if (country.flags['svg'] != null) {
          return SvgPicture.network(
            country.flags['svg'],
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            placeholderBuilder: (context) => Container(
              color: Colors.grey[200],
              child: const Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              ),
            ),
          );
        }
        // Fallback to PNG if SVG is not available
        else if (country.flags['png'] != null) {
          return Image.network(
            country.flags['png'],
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

  Widget _buildKeyStatistics(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 16),r
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
                alpha: Theme.of(context).brightness == Brightness.dark
                    ? 0.2
                    : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          _buildStatRow(context, 'Area', _formatArea(country.area)),
          _buildStatRow(
              context, 'Population', _formatPopulation(country.population)),
          _buildStatRow(context, 'Region', country.region),
          _buildStatRow(context, 'Sub Region', country.subregion),
        ],
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimezoneSection(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Timezone',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          _buildTimezoneChips(context),
        ],
      ),
    );
  }

  Widget _buildTimezoneChips(BuildContext context) {
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
          fontWeight: FontWeight.w800,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            timezone,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Theme.of(context).colorScheme.onSurface,
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
