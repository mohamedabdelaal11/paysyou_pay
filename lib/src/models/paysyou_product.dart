/// Localized product name sent in the create-invoice payload.
class PaysYouProductName {
  const PaysYouProductName({
    required this.ar,
    required this.en,
  });

  /// Arabic name.
  final String ar;

  /// English name.
  final String en;

  Map<String, dynamic> toJson() => {
        'ar': ar,
        'en': en,
      };
}

/// Line item included on a PaysYou invoice.
class PaysYouProduct {
  const PaysYouProduct({
    required this.name,
    required this.price,
    required this.quantity,
    this.code,
  });

  /// Localized display name.
  final PaysYouProductName name;

  /// Optional merchant product code.
  final String? code;

  /// Unit price.
  final num price;

  /// Units on this invoice.
  final int quantity;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'name': name.toJson(),
      'price': price,
      'quantity': quantity,
    };

    final productCode = code?.trim();
    if (productCode != null && productCode.isNotEmpty) {
      json['code'] = productCode;
    }

    return json;
  }
}
