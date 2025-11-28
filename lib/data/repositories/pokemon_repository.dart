import '../../core/errors/exceptions.dart';
import '../datasources/pokemon_remote_datasource.dart';
import '../models/pokemon_detail_model.dart';
import '../models/pokemon_model.dart';

/// Repository for Pokemon data operations.
/// 
/// This repository acts as the single source of truth for Pokemon data,
/// abstracting the data sources from the business logic layer.
abstract class PokemonRepository {
  /// Fetches the list of all Pokemon.
  /// 
  /// Returns a [PokemonListResponse] containing the list of Pokemon.
  /// Throws an exception if the fetch fails.
  Future<PokemonListResponse> getPokemonList();

  /// Fetches detailed information for a specific Pokemon.
  /// 
  /// [url] - The full URL to the Pokemon's detail endpoint.
  /// Returns a [PokemonDetailModel] with complete Pokemon information.
  /// Throws an exception if the fetch fails.
  Future<PokemonDetailModel> getPokemonDetail(String url);
}

/// Implementation of [PokemonRepository].
class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource remoteDataSource;

  PokemonRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PokemonListResponse> getPokemonList() async {
    try {
      return await remoteDataSource.getPokemonList();
    } on NetworkException {
      rethrow;
    } on ServerException {
      rethrow;
    } on ParsingException {
      rethrow;
    } on NotFoundException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<PokemonDetailModel> getPokemonDetail(String url) async {
    try {
      return await remoteDataSource.getPokemonDetail(url);
    } on NetworkException {
      rethrow;
    } on ServerException {
      rethrow;
    } on ParsingException {
      rethrow;
    } on NotFoundException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }
}

