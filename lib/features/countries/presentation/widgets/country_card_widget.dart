import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/animations/animated_widgets.dart';
import '../../../../core/animations/page_transitions.dart';
import '../../../../core/favorites/favorites_cubit.dart';
import '../../domain/entity/countries_entity.dart';
import '../pages/country_detail_page.dart';

class CountryCardWidget extends StatelessWidget {
  final CountriesEntity country;

  const CountryCardWidget({
    super.key,
    required this.country,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: AnimatedCard(
        onTap: () {
          Navigator.push(
            context,
            PageTransitions.slideTransition(
              CountryDetailPage(country: country),
            ),
          );
        },
        child: Row(
          children: [
            // Flag image with Hero animation
            Hero(
              tag: 'flag-${country.name}',
              child: Container(
                width: 90,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.3),
                    width: 0.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildFlagImage(context),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Country info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'name-${country.name}',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        country.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Population: ${_formatPopulation(country.population)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Animated favorite heart icon
            BlocBuilder<FavoritesCubit, FavoritesState>(
              builder: (context, state) {
                final isFavorite =
                    context.read<FavoritesCubit>().isFavorite(country.name);

                return AnimatedFavoriteButton(
                  isFavorite: isFavorite,
                  onTap: () {
                    context.read<FavoritesCubit>().toggleFavorite(country.name);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlagImage(BuildContext context) {
    try {
      if (country.flags is Map && country.flags['png'] != null) {
        return Image.network(
          country.flags['png'],
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildFallbackFlag(context);
          },
        );
      }
    } catch (e) {
      return _buildFallbackFlag(context);
    }

    return _buildFallbackFlag(context);
  }

  Widget _buildFallbackFlag(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.flag,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          size: 24,
        ),
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
