import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../core/theme/app_theme.dart';
import '../../data/datasources/pokemon_remote_datasource.dart';
import '../../data/models/pokemon_detail_model.dart';
import '../../data/models/pokemon_model.dart';
import '../../data/repositories/pokemon_repository.dart';
import '../blocs/pokemon_detail/pokemon_detail_bloc.dart';
import '../blocs/pokemon_detail/pokemon_detail_event.dart';
import '../blocs/pokemon_detail/pokemon_detail_state.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';

/// Screen displaying detailed information about a specific Pokemon.
class PokemonDetailScreen extends StatelessWidget {
  /// The Pokemon data passed from the list screen
  final PokemonModel pokemon;

  const PokemonDetailScreen({
    super.key,
    required this.pokemon,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PokemonDetailBloc(
        repository: PokemonRepositoryImpl(
          remoteDataSource: PokemonRemoteDataSourceImpl(
            client: http.Client(),
          ),
        ),
      )..add(FetchPokemonDetail(
          url: pokemon.url,
          pokemonName: pokemon.capitalizedName,
        )),
      child: _PokemonDetailView(pokemon: pokemon),
    );
  }
}

class _PokemonDetailView extends StatelessWidget {
  final PokemonModel pokemon;

  const _PokemonDetailView({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonDetailBloc, PokemonDetailState>(
      builder: (context, state) {
        Color backgroundColor = AppTheme.primaryColor;
        
        if (state is PokemonDetailLoaded) {
          backgroundColor = AppTheme.getTypeColor(state.pokemon.primaryType);
        }

        return Scaffold(
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                // App Bar
                _buildAppBar(context, state),
                
                // Content
                Expanded(
                  child: _buildContent(context, state, backgroundColor),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, PokemonDetailState state) {
    String title = pokemon.capitalizedName;
    String id = pokemon.formattedId;

    if (state is PokemonDetailLoaded) {
      title = state.pokemon.capitalizedName;
      id = state.pokemon.formattedId;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              id,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    PokemonDetailState state,
    Color backgroundColor,
  ) {
    if (state is PokemonDetailLoading) {
      return const Center(
        child: LoadingWidget(message: 'Loading Pokémon details...'),
      );
    }

    if (state is PokemonDetailError) {
      return ErrorDisplayWidget(
        message: state.message,
        onRetry: () {
          context.read<PokemonDetailBloc>().add(FetchPokemonDetail(
                url: pokemon.url,
                pokemonName: pokemon.capitalizedName,
              ));
        },
      );
    }

    if (state is PokemonDetailLoaded) {
      return _buildDetailContent(context, state.pokemon, backgroundColor);
    }

    return const SizedBox.shrink();
  }

  Widget _buildDetailContent(
    BuildContext context,
    PokemonDetailModel pokemonDetail,
    Color backgroundColor,
  ) {
    return Column(
      children: [
        // Pokemon Image Section
        Expanded(
          flex: 2,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background Pattern
              Positioned(
                right: -50,
                top: -20,
                child: Opacity(
                  opacity: 0.1,
                  child: Icon(
                    Icons.catching_pokemon,
                    size: 200,
                    color: Colors.white,
                  ),
                ),
              ),
              // Pokemon Image
              Hero(
                tag: 'pokemon-${pokemon.id}',
                child: CachedNetworkImage(
                  imageUrl: pokemonDetail.sprites.officialArtwork ?? 
                            pokemon.imageUrl,
                  height: 200,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.catching_pokemon,
                    size: 120,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Detail Card Section
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Types
                  _buildTypesSection(pokemonDetail),
                  const SizedBox(height: 24),

                  // About Section
                  _buildAboutSection(pokemonDetail),
                  const SizedBox(height: 24),

                  // Base Stats Section
                  _buildStatsSection(pokemonDetail, backgroundColor),
                  const SizedBox(height: 24),

                  // Abilities Section
                  _buildAbilitiesSection(pokemonDetail, backgroundColor),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypesSection(PokemonDetailModel pokemonDetail) {
    return Center(
      child: Wrap(
        spacing: 12,
        children: pokemonDetail.types.map((type) {
          final typeColor = AppTheme.getTypeColor(type.type.name);
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: typeColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: typeColor.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              type.type.capitalizedName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAboutSection(PokemonDetailModel pokemonDetail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildAboutItem(
              icon: Icons.straighten,
              label: 'Height',
              value: '${pokemonDetail.heightInMeters} m',
            ),
            _buildDivider(),
            _buildAboutItem(
              icon: Icons.fitness_center,
              label: 'Weight',
              value: '${pokemonDetail.weightInKg} kg',
            ),
            _buildDivider(),
            _buildAboutItem(
              icon: Icons.stars_rounded,
              label: 'Base Exp',
              value: '${pokemonDetail.baseExperience}',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAboutItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppTheme.textSecondary,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 50,
      width: 1,
      color: AppTheme.dividerColor,
    );
  }

  Widget _buildStatsSection(
    PokemonDetailModel pokemonDetail,
    Color accentColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Base Stats',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ...pokemonDetail.stats.map(
          (stat) => _buildStatBar(
            stat.stat.abbreviation,
            stat.baseStat,
            accentColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatBar(String label, int value, Color color) {
    // Max stat value for scaling (considering 255 as max base stat)
    const int maxStat = 255;
    final double percentage = value / maxStat;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              value.toString().padLeft(3, '0'),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Stack(
              children: [
                // Background bar
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                // Filled bar
                FractionallySizedBox(
                  widthFactor: percentage.clamp(0.0, 1.0),
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbilitiesSection(
    PokemonDetailModel pokemonDetail,
    Color accentColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Abilities',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: pokemonDetail.abilities.map((ability) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: ability.isHidden
                    ? AppTheme.textSecondary.withValues(alpha: 0.1)
                    : accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ability.isHidden
                      ? AppTheme.textSecondary.withValues(alpha: 0.3)
                      : accentColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    ability.ability.formattedName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: ability.isHidden
                          ? AppTheme.textSecondary
                          : accentColor,
                    ),
                  ),
                  if (ability.isHidden) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.textSecondary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Hidden',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

