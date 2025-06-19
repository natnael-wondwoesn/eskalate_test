import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../bloc/countries_bloc.dart';
import '../bloc/countries_event.dart';
import '../bloc/countries_state.dart';
import '../widgets/countries_list_widget.dart';
import '../widgets/country_search_widget.dart';

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
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries Explorer'),
        actions: [
          // Dark mode toggle
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return PopupMenuButton<ThemeMode>(
                icon: Icon(
                  themeMode == ThemeMode.dark
                      ? Icons.dark_mode
                      : themeMode == ThemeMode.light
                          ? Icons.light_mode
                          : Icons.auto_mode,
                ),
                onSelected: (ThemeMode mode) {
                  final themeCubit = context.read<ThemeCubit>();
                  switch (mode) {
                    case ThemeMode.light:
                      themeCubit.setLightTheme();
                      break;
                    case ThemeMode.dark:
                      themeCubit.setDarkTheme();
                      break;
                    case ThemeMode.system:
                      themeCubit.setSystemTheme();
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                    value: ThemeMode.light,
                    child: ListTile(
                      leading: Icon(Icons.light_mode),
                      title: Text('Light'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: ThemeMode.dark,
                    child: ListTile(
                      leading: Icon(Icons.dark_mode),
                      title: Text('Dark'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: ThemeMode.system,
                    child: ListTile(
                      leading: Icon(Icons.auto_mode),
                      title: Text('System'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.list),
              text: 'All Countries',
            ),
            Tab(
              icon: Icon(Icons.search),
              text: 'Search Country',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // All Countries Tab with Pull-to-Refresh
          BlocBuilder<CountriesBloc, CountriesState>(
            builder: (context, state) {
              return RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<CountriesBloc>()
                      .add(const RefreshCountriesEvent());
                  // Wait for the refresh to complete
                  await context.read<CountriesBloc>().stream.firstWhere(
                        (state) => state is! CountriesLoading,
                      );
                },
                child: _buildCountriesContent(state),
              );
            },
          ),
          // Search Country Tab
          const CountrySearchWidget(),
        ],
      ),
    );
  }

  Widget _buildCountriesContent(CountriesState state) {
    if (state is CountriesInitial) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Loading countries...',
              style: TextStyle(fontSize: 16),
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
            Text(
              'Loading countries...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    } else if (state is CountriesAllLoaded) {
      if (state.countries.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.public_off,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'No countries found',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pull down to refresh',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<CountriesBloc>()
                      .add(const RefreshCountriesEvent());
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }
      return CountriesListWidget(countries: state.countries);
    } else if (state is CountriesError) {
      return Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Error: ${state.message}',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pull down to refresh',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<CountriesBloc>()
                      .add(const RefreshCountriesEvent());
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
