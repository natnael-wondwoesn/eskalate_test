import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
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
          // All Countries Tab
          BlocBuilder<CountriesBloc, CountriesState>(
            builder: (context, state) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        context
                            .read<CountriesBloc>()
                            .add(const GetAllCountriesEvent());
                      },
                      child: const Text('Load All Countries'),
                    ),
                  ),
                  Expanded(
                    child: _buildCountriesContent(state),
                  ),
                ],
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
        child: Text(
          'Tap "Load All Countries" to get started',
          style: TextStyle(fontSize: 16),
        ),
      );
    } else if (state is CountriesLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is CountriesAllLoaded) {
      return CountriesListWidget(countries: state.countries);
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
              onPressed: () {
                context.read<CountriesBloc>().add(const GetAllCountriesEvent());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
