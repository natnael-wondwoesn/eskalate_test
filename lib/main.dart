import 'package:flutter/material.dart';

import 'core/di/dependency_injection.dart';
import 'features/countries/presentation/pages/countries_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countries Explorer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CountriesPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
