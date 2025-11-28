import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'core/theme/app_theme.dart';
import 'data/datasources/pokemon_remote_datasource.dart';
import 'data/repositories/pokemon_repository.dart';
import 'presentation/blocs/pokemon_list/pokemon_list_bloc.dart';
import 'presentation/screens/pokemon_list_screen.dart';

/// Main entry point for the PokéDex application.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style for a more immersive experience
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.backgroundColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const PokedexApp());
}

/// The root widget of the PokéDex application.
class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokéDex',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: _buildHomeWithProviders(),
    );
  }

  /// Builds the home screen with all necessary BLoC providers.
  Widget _buildHomeWithProviders() {
    // Create dependencies
    final httpClient = http.Client();
    final remoteDataSource = PokemonRemoteDataSourceImpl(client: httpClient);
    final repository = PokemonRepositoryImpl(remoteDataSource: remoteDataSource);

    return BlocProvider(
      create: (context) => PokemonListBloc(repository: repository),
      child: const PokemonListScreen(),
    );
  }
}
