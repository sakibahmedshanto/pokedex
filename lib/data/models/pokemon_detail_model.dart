import 'package:equatable/equatable.dart';

/// Model representing detailed Pokemon information.
/// 
/// This model contains comprehensive data about a Pokemon
/// as returned by the /pokemon/{id} endpoint.
class PokemonDetailModel extends Equatable {
  /// Unique identifier of the Pokemon
  final int id;
  
  /// The name of the Pokemon
  final String name;
  
  /// Height of the Pokemon in decimetres
  final int height;
  
  /// Weight of the Pokemon in hectograms
  final int weight;
  
  /// Base experience gained for defeating this Pokemon
  final int baseExperience;
  
  /// List of Pokemon types (e.g., fire, water)
  final List<PokemonType> types;
  
  /// Pokemon abilities
  final List<PokemonAbility> abilities;
  
  /// Pokemon stats (HP, Attack, Defense, etc.)
  final List<PokemonStat> stats;
  
  /// Pokemon sprites/images
  final PokemonSprites sprites;

  const PokemonDetailModel({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.baseExperience,
    required this.types,
    required this.abilities,
    required this.stats,
    required this.sprites,
  });

  /// Creates a PokemonDetailModel from JSON data.
  factory PokemonDetailModel.fromJson(Map<String, dynamic> json) {
    return PokemonDetailModel(
      id: json['id'] as int,
      name: json['name'] as String,
      height: json['height'] as int,
      weight: json['weight'] as int,
      baseExperience: json['base_experience'] as int? ?? 0,
      types: (json['types'] as List<dynamic>)
          .map((item) => PokemonType.fromJson(item as Map<String, dynamic>))
          .toList(),
      abilities: (json['abilities'] as List<dynamic>)
          .map((item) => PokemonAbility.fromJson(item as Map<String, dynamic>))
          .toList(),
      stats: (json['stats'] as List<dynamic>)
          .map((item) => PokemonStat.fromJson(item as Map<String, dynamic>))
          .toList(),
      sprites: PokemonSprites.fromJson(json['sprites'] as Map<String, dynamic>),
    );
  }

  /// Gets the formatted Pokemon ID (e.g., #001, #025, #150)
  String get formattedId => '#${id.toString().padLeft(3, '0')}';

  /// Gets the capitalized name of the Pokemon
  String get capitalizedName {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }

  /// Gets height in meters
  double get heightInMeters => height / 10;

  /// Gets weight in kilograms
  double get weightInKg => weight / 10;

  /// Gets the primary type of the Pokemon
  String get primaryType {
    if (types.isEmpty) return 'unknown';
    return types.first.type.name;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        height,
        weight,
        baseExperience,
        types,
        abilities,
        stats,
        sprites,
      ];
}

/// Model representing a Pokemon type.
class PokemonType extends Equatable {
  final int slot;
  final TypeInfo type;

  const PokemonType({
    required this.slot,
    required this.type,
  });

  factory PokemonType.fromJson(Map<String, dynamic> json) {
    return PokemonType(
      slot: json['slot'] as int,
      type: TypeInfo.fromJson(json['type'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [slot, type];
}

/// Model representing type information.
class TypeInfo extends Equatable {
  final String name;
  final String url;

  const TypeInfo({
    required this.name,
    required this.url,
  });

  factory TypeInfo.fromJson(Map<String, dynamic> json) {
    return TypeInfo(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }

  /// Gets the capitalized type name
  String get capitalizedName {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  List<Object?> get props => [name, url];
}

/// Model representing a Pokemon ability.
class PokemonAbility extends Equatable {
  final bool isHidden;
  final int slot;
  final AbilityInfo ability;

  const PokemonAbility({
    required this.isHidden,
    required this.slot,
    required this.ability,
  });

  factory PokemonAbility.fromJson(Map<String, dynamic> json) {
    return PokemonAbility(
      isHidden: json['is_hidden'] as bool,
      slot: json['slot'] as int,
      ability: AbilityInfo.fromJson(json['ability'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [isHidden, slot, ability];
}

/// Model representing ability information.
class AbilityInfo extends Equatable {
  final String name;
  final String url;

  const AbilityInfo({
    required this.name,
    required this.url,
  });

  factory AbilityInfo.fromJson(Map<String, dynamic> json) {
    return AbilityInfo(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }

  /// Gets the formatted ability name (replaces hyphens with spaces and capitalizes)
  String get formattedName {
    if (name.isEmpty) return name;
    return name.split('-').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  @override
  List<Object?> get props => [name, url];
}

/// Model representing a Pokemon stat.
class PokemonStat extends Equatable {
  final int baseStat;
  final int effort;
  final StatInfo stat;

  const PokemonStat({
    required this.baseStat,
    required this.effort,
    required this.stat,
  });

  factory PokemonStat.fromJson(Map<String, dynamic> json) {
    return PokemonStat(
      baseStat: json['base_stat'] as int,
      effort: json['effort'] as int,
      stat: StatInfo.fromJson(json['stat'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [baseStat, effort, stat];
}

/// Model representing stat information.
class StatInfo extends Equatable {
  final String name;
  final String url;

  const StatInfo({
    required this.name,
    required this.url,
  });

  factory StatInfo.fromJson(Map<String, dynamic> json) {
    return StatInfo(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }

  /// Gets the abbreviated stat name for display
  String get abbreviation {
    switch (name) {
      case 'hp':
        return 'HP';
      case 'attack':
        return 'ATK';
      case 'defense':
        return 'DEF';
      case 'special-attack':
        return 'SP.ATK';
      case 'special-defense':
        return 'SP.DEF';
      case 'speed':
        return 'SPD';
      default:
        return name.toUpperCase();
    }
  }

  @override
  List<Object?> get props => [name, url];
}

/// Model representing Pokemon sprites/images.
class PokemonSprites extends Equatable {
  final String? frontDefault;
  final String? frontShiny;
  final String? backDefault;
  final String? backShiny;
  final OtherSprites? other;

  const PokemonSprites({
    this.frontDefault,
    this.frontShiny,
    this.backDefault,
    this.backShiny,
    this.other,
  });

  factory PokemonSprites.fromJson(Map<String, dynamic> json) {
    return PokemonSprites(
      frontDefault: json['front_default'] as String?,
      frontShiny: json['front_shiny'] as String?,
      backDefault: json['back_default'] as String?,
      backShiny: json['back_shiny'] as String?,
      other: json['other'] != null
          ? OtherSprites.fromJson(json['other'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Gets the official artwork URL (preferred) or falls back to front_default
  String? get officialArtwork {
    return other?.officialArtwork?.frontDefault ?? frontDefault;
  }

  @override
  List<Object?> get props => [
        frontDefault,
        frontShiny,
        backDefault,
        backShiny,
        other,
      ];
}

/// Model for other sprite sources.
class OtherSprites extends Equatable {
  final OfficialArtwork? officialArtwork;

  const OtherSprites({
    this.officialArtwork,
  });

  factory OtherSprites.fromJson(Map<String, dynamic> json) {
    return OtherSprites(
      officialArtwork: json['official-artwork'] != null
          ? OfficialArtwork.fromJson(
              json['official-artwork'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  List<Object?> get props => [officialArtwork];
}

/// Model for official artwork sprites.
class OfficialArtwork extends Equatable {
  final String? frontDefault;
  final String? frontShiny;

  const OfficialArtwork({
    this.frontDefault,
    this.frontShiny,
  });

  factory OfficialArtwork.fromJson(Map<String, dynamic> json) {
    return OfficialArtwork(
      frontDefault: json['front_default'] as String?,
      frontShiny: json['front_shiny'] as String?,
    );
  }

  @override
  List<Object?> get props => [frontDefault, frontShiny];
}

