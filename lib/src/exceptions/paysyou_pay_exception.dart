/// Base exception for all PaysYou Pay errors.
sealed class PaysYouPayException implements Exception {
  const PaysYouPayException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'PaysYouPayException: $message';
}

/// Thrown when request input fails validation before the API call.
final class PaysYouPayValidationException extends PaysYouPayException {
  const PaysYouPayValidationException(super.message, {super.cause});
}

/// Thrown when the API request fails or returns an unexpected response.
final class PaysYouPayApiException extends PaysYouPayException {
  const PaysYouPayApiException(super.message, {super.cause, this.statusCode});

  final int? statusCode;
}

/// Thrown when the deep link cannot be launched on the device.
final class PaysYouPayLaunchException extends PaysYouPayException {
  const PaysYouPayLaunchException(super.message, {super.cause});
}
