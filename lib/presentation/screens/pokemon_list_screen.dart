import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/pokemon_model.dart';
import '../blocs/pokemon_list/pokemon_list_bloc.dart';
import '../blocs/pokemon_list/pokemon_list_event.dart';
import '../blocs/pokemon_list/pokemon_list_state.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/pokemon_card.dart';
import 'pokemon_detail_screen.dart';

/// The main screen displaying a horizontal scrolling list of Pokemon.
class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch Pokemon list when screen loads
    context.read<PokemonListBloc>().add(const FetchPokemonList());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToDetail(PokemonModel pokemon) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PokemonDetailScreen(pokemon: pokemon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section (extends into status bar)
          _buildHeader(),
          
          // Search Bar
          _buildSearchBar(),
          
          // Pokemon Count
          _buildPokemonCount(),
          
          // Pokemon List
          Expanded(
            child: _buildPokemonList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    // Get the status bar height to add proper padding
    final statusBarHeight = MediaQuery.of(context).padding.top;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, statusBarHeight + 16, 20, 16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Pokeball Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.catching_pokemon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                AppConstants.appTitle,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Discover all Pokémon in the world!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            context.read<PokemonListBloc>().add(SearchPokemon(value));
          },
          decoration: InputDecoration(
            hintText: 'Search Pokémon by name or ID...',
            hintStyle: TextStyle(
              color: AppTheme.textSecondary.withValues(alpha: 0.6),
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppTheme.primaryColor,
            ),
            suffixIcon: BlocBuilder<PokemonListBloc, PokemonListState>(
              builder: (context, state) {
                if (state is PokemonListLoaded && state.searchQuery.isNotEmpty) {
                  return IconButton(
                    icon: const Icon(
                      Icons.clear_rounded,
                      color: AppTheme.textSecondary,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      context.read<PokemonListBloc>().add(const ClearSearch());
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPokemonCount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: BlocBuilder<PokemonListBloc, PokemonListState>(
        builder: (context, state) {
          if (state is PokemonListLoaded) {
            final isFiltered = state.searchQuery.isNotEmpty;
            return Row(
              children: [
                Text(
                  isFiltered
                      ? '${state.displayedPokemon.length} results'
                      : '${state.allPokemon.length} Pokémon',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                if (isFiltered) ...[
                  Text(
                    ' for "${state.searchQuery}"',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildPokemonList() {
    return BlocBuilder<PokemonListBloc, PokemonListState>(
      builder: (context, state) {
        if (state is PokemonListLoading) {
          return const LoadingWidget(
            message: AppConstants.loadingMessage,
          );
        }
        
        if (state is PokemonListError) {
          return ErrorDisplayWidget(
            message: state.message,
            onRetry: () {
              context.read<PokemonListBloc>().add(const FetchPokemonList());
            },
          );
        }
        
        if (state is PokemonListLoaded) {
          if (state.displayedPokemon.isEmpty) {
            return _buildEmptyState(state.searchQuery);
          }
          
          return RefreshIndicator(
            onRefresh: () async {
              context.read<PokemonListBloc>().add(const RefreshPokemonList());
            },
            color: AppTheme.primaryColor,
            child: _buildHorizontalList(state.displayedPokemon),
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildHorizontalList(List<PokemonModel> pokemonList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
          child: Row(
            children: [
              const Icon(
                Icons.swipe,
                size: 18,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                'Swipe to explore',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary.withValues(alpha: 0.8),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: pokemonList.length,
            itemBuilder: (context, index) {
              final pokemon = pokemonList[index];
              return PokemonCard(
                pokemon: pokemon,
                onTap: () => _navigateToDetail(pokemon),
              );
            },
          ),
        ),
        // Visual indicator for more content
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryColor.withValues(
                    alpha: 0.3 + (index * 0.2),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String searchQuery) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 80,
              color: AppTheme.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Pokémon found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No results for "$searchQuery".\nTry a different search term.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

