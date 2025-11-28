/// Custom exceptions for the PokéDex application.
/// 
/// These exceptions provide more specific error handling compared to 
/// generic exceptions and help in displaying user-friendly error messages.
library;

/// Exception thrown when a network-related error occurs.
class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  const NetworkException({
    this.message = 'A network error occurred',
    this.statusCode,
  });

  @override
  String toString() => 'NetworkException: $message (Status Code: $statusCode)';
}

/// Exception thrown when the server returns an error response.
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    this.message = 'Server error occurred',
    this.statusCode,
  });

  @override
  String toString() => 'ServerException: $message (Status Code: $statusCode)';
}

/// Exception thrown when there's an error parsing API response.
class ParsingException implements Exception {
  final String message;

  const ParsingException({
    this.message = 'Error parsing data',
  });

  @override
  String toString() => 'ParsingException: $message';
}

/// Exception thrown when requested data is not found.
class NotFoundException implements Exception {
  final String message;

  const NotFoundException({
    this.message = 'Requested data not found',
  });

  @override
  String toString() => 'NotFoundException: $message';
}

