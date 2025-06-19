import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/animations/animated_widgets.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/theme/theme_cubit.dart';

import '../bloc/countries_bloc.dart';
import '../bloc/countries_event.dart';
import '../bloc/countries_state.dart';
import '../widgets/country_card_widget.dart';
import '../widgets/favorites_page.dart';

class CountriesPage extends StatelessWidget {
  const CountriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CountriesBloc>(),
      child: const CountriesView(),
    );
  }
}

class CountriesView extends StatefulWidget {
  const CountriesView({super.key});

  @override
  State<CountriesView> createState() => _CountriesViewState();
}

class _CountriesViewState extends State<CountriesView>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _tabController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder: (child, animation) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(0.3, 0), end: Offset.zero).chain(
                CurveTween(curve: Curves.easeInOut),
              ),
            ),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        child: _selectedIndex == 0
            ? Container(
                key: const ValueKey('home'),
                child: _buildHomeTab(),
              )
            : const FavoritesPage(),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            if (index != _selectedIndex) {
              _tabController.reset();
              _tabController.forward();
              setState(() {
                _selectedIndex = index;
              });
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor:
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: AnimatedScale(
                scale: _selectedIndex == 0 ? 1.2 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(Icons.home),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: AnimatedScale(
                scale: _selectedIndex == 1 ? 1.2 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(Icons.favorite),
              ),
              label: 'Favorites',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return SafeArea(
      child: Column(
        children: [
          // Header with title and theme toggle
          SlideInAnimation(
            delay: const Duration(milliseconds: 100),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Countries',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  BlocBuilder<ThemeCubit, ThemeMode>(
                    builder: (context, themeMode) {
                      return AnimatedRotation(
                        turns: themeMode == ThemeMode.dark ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: IconButton(
                          onPressed: () {
                            context.read<ThemeCubit>().toggleTheme();
                          },
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return RotationTransition(
                                turns: animation,
                                child: child,
                              );
                            },
                            child: Icon(
                              themeMode == ThemeMode.dark
                                  ? Icons.light_mode
                                  : Icons.dark_mode,
                              key: ValueKey(themeMode),
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Search bar
          SlideInAnimation(
            delay: const Duration(milliseconds: 200),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    context.read<CountriesBloc>().add(
                          SearchCountriesEvent(query: value),
                        );
                  },
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search for a country',
                    hintStyle: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Countries list
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                context
                    .read<CountriesBloc>()
                    .add(const RefreshCountriesEvent());
                await context.read<CountriesBloc>().stream.firstWhere(
                      (state) => state is! CountriesLoading,
                    );
              },
              child: BlocBuilder<CountriesBloc, CountriesState>(
                builder: (context, state) {
                  return _buildCountriesContent(state);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountriesContent(CountriesState state) {
    if (state is CountriesInitial || state is CountriesLoading) {
      return SlideInAnimation(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Loading countries...',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (state is CountriesAllLoaded) {
      if (state.countries.isEmpty) {
        return SlideInAnimation(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: 1.0,
                  duration: const Duration(milliseconds: 500),
                  child: Icon(
                    Icons.search_off,
                    size: 64,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No countries found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: state.countries.length,
        itemBuilder: (context, index) {
          final country = state.countries[index];
          return StaggeredListAnimation(
            index: index,
            child: CountryCardWidget(country: country),
          );
        },
      );
    } else if (state is CountriesError) {
      return SlideInAnimation(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: 1.0,
                duration: const Duration(milliseconds: 500),
                child: const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Error: ${state.message}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              AnimatedScale(
                scale: 1.0,
                duration: const Duration(milliseconds: 300),
                child: ElevatedButton(
                  onPressed: () {
                    context
                        .read<CountriesBloc>()
                        .add(const RefreshCountriesEvent());
                  },
                  child: const Text('Retry'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
