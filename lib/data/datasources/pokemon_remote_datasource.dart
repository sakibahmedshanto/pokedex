import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/pokemon_detail_model.dart';
import '../models/pokemon_model.dart';

/// Remote data source for fetching Pokemon data from the PokeAPI.
/// 
/// This class handles all HTTP requests to the PokeAPI and converts
/// the JSON responses into model objects.
abstract class PokemonRemoteDataSource {
  /// Fetches the list of all Pokemon.
  Future<PokemonListResponse> getPokemonList();

  /// Fetches detailed information for a specific Pokemon.
  /// 
  /// [url] - The full URL to the Pokemon's detail endpoint.
  Future<PokemonDetailModel> getPokemonDetail(String url);
}

/// Implementation of [PokemonRemoteDataSource] using the http package.
class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  final http.Client client;

  PokemonRemoteDataSourceImpl({required this.client});

  @override
  Future<PokemonListResponse> getPokemonList() async {
    try {
      final response = await client.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.pokemonListEndpoint}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return PokemonListResponse.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        throw const NotFoundException(message: 'Pokemon list not found');
      } else {
        throw ServerException(
          message: 'Failed to load Pokemon list',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw const NetworkException(
        message: AppConstants.networkErrorMessage,
      );
    } on FormatException {
      throw const ParsingException(message: 'Error parsing Pokemon list data');
    } on http.ClientException {
      throw const NetworkException(
        message: AppConstants.networkErrorMessage,
      );
    }
  }

  @override
  Future<PokemonDetailModel> getPokemonDetail(String url) async {
    try {
      final response = await client.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return PokemonDetailModel.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        throw const NotFoundException(message: 'Pokemon not found');
      } else {
        throw ServerException(
          message: 'Failed to load Pokemon details',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw const NetworkException(
        message: AppConstants.networkErrorMessage,
      );
    } on FormatException {
      throw const ParsingException(
        message: 'Error parsing Pokemon detail data',
      );
    } on http.ClientException {
      throw const NetworkException(
        message: AppConstants.networkErrorMessage,
      );
    }
  }
}

