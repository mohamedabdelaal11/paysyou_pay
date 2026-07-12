import '../exceptions/paysyou_pay_exception.dart';
import '../models/create_invoice_result.dart';

/// Parses the create-invoice API response body.
abstract interface class CreateInvoiceResponseParser {
  CreateInvoiceResult parse(Map<String, dynamic>? body);
}

/// Default parser for the PaysYou create-invoice endpoint.
final class PaysYouCreateInvoiceResponseParser
    implements CreateInvoiceResponseParser {
  const PaysYouCreateInvoiceResponseParser();

  @override
  CreateInvoiceResult parse(Map<String, dynamic>? body) {
    if (body == null) {
      throw const PaysYouPayApiException('Empty response from server.');
    }

    final status = body['status'];
    if (status is! int) {
      throw const PaysYouPayApiException(
        'Response is missing a valid "status" field.',
      );
    }

    final message = body['message'];
    if (message is! String || message.isEmpty) {
      throw const PaysYouPayApiException(
        'Response is missing a valid "message" field.',
      );
    }

    final theTotal = body['the_total'];
    if (theTotal is! num) {
      throw const PaysYouPayApiException(
        'Response is missing a valid "the_total" field.',
      );
    }

    final data = body['data'];
    if (data is! Map<String, dynamic>) {
      throw const PaysYouPayApiException(
        'Response is missing a valid "data" object.',
      );
    }

    final invoiceId = data['invoice_id'];
    if (invoiceId is! int) {
      throw const PaysYouPayApiException(
        'Response is missing a valid "invoice_id".',
      );
    }

    final redirectUrl = data['redirect_url'];
    if (redirectUrl is! String || redirectUrl.isEmpty) {
      throw const PaysYouPayApiException(
        'Response is missing "redirect_url".',
      );
    }

    final redirectDeepLink = data['redirect_deep_link'];
    if (redirectDeepLink is! String || redirectDeepLink.isEmpty) {
      throw const PaysYouPayApiException(
        'Response is missing "redirect_deep_link".',
      );
    }

    final errors = body['errors'];
    if (errors is! Map<String, dynamic>) {
      throw const PaysYouPayApiException(
        'Response is missing a valid "errors" object.',
      );
    }

    return CreateInvoiceResult(
      status: status,
      message: message,
      theTotal: theTotal,
      invoiceId: invoiceId,
      redirectUrl: redirectUrl,
      redirectDeepLink: redirectDeepLink,
      errors: errors,
      rawBody: Map<String, dynamic>.from(body),
    );
  }
}
