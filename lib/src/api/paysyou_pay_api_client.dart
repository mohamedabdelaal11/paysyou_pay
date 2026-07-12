import 'package:dio/dio.dart';

import '../exceptions/paysyou_pay_exception.dart';
import '../mappers/create_invoice_payload_mapper.dart';
import '../models/create_invoice_result.dart';
import '../models/paysyou_invoice.dart';
import '../models/paysyou_pay_config.dart';
import '../parsers/create_invoice_response_parser.dart';
import '../validators/invoice_validator.dart';
import '../validators/paysyou_invoice_validator.dart';
import 'invoice_api.dart';

/// HTTP implementation of [InvoiceApi].
final class PaysYouPayApiClient implements InvoiceApi {
  PaysYouPayApiClient({
    required PaysYouPayConfig config,
    Dio? dio,
    InvoiceValidator? validator,
    CreateInvoicePayloadMapper? payloadMapper,
    CreateInvoiceResponseParser? responseParser,
  })  : _dio = dio ?? config.dio ?? Dio(),
        _validator = validator ?? const PaysYouInvoiceValidator(),
        _payloadMapper =
            payloadMapper ?? PaysYouCreateInvoicePayloadMapper(),
        _responseParser =
            responseParser ?? const PaysYouCreateInvoiceResponseParser();

  final Dio _dio;
  final InvoiceValidator _validator;
  final CreateInvoicePayloadMapper _payloadMapper;
  final CreateInvoiceResponseParser _responseParser;

  static const _baseUrl = 'https://backend.pays-you.com';
  static const _createInvoicePath = '/facility-api/v1/pay_invoice';
  static const _jsonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  @override
  Future<CreateInvoiceResult> createInvoice(PaysYouInvoice invoice) async {
    _validator.validate(invoice);

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$_baseUrl$_createInvoicePath',
        data: _payloadMapper.toJson(invoice),
        options: Options(headers: _jsonHeaders),
      );

      return _responseParser.parse(response.data);
    } on PaysYouPayException {
      rethrow;
    } on DioException catch (error) {
      throw PaysYouPayApiException(
        _messageFromDio(error),
        cause: error,
        statusCode: error.response?.statusCode,
      );
    } catch (error) {
      throw PaysYouPayApiException(
        'Unexpected error while creating invoice.',
        cause: error,
      );
    }
  }

  String _messageFromDio(DioException error) {
    final responseData = error.response?.data;
    if (responseData is Map<String, dynamic>) {
      final message = responseData['message'] ?? responseData['error'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    return error.message ?? 'Network request failed.';
  }
}
