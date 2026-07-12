import 'package:dio/dio.dart';

/// Configuration for [PaysYouPay].
class PaysYouPayConfig {
  const PaysYouPayConfig({
    this.dio,
  });

  /// Optional shared [Dio] instance. A new instance is created when omitted.
  final Dio? dio;
}
