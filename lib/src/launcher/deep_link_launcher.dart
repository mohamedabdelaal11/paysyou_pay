import 'package:url_launcher/url_launcher.dart';

import '../exceptions/paysyou_pay_exception.dart';

/// Opens a deep link in an external application.
abstract interface class DeepLinkLauncher {
  Future<bool> launch(Uri uri);
}

/// Default launcher using [url_launcher].
final class DefaultDeepLinkLauncher implements DeepLinkLauncher {
  const DefaultDeepLinkLauncher();

  static const _webViewHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  @override
  Future<bool> launch(Uri uri) {
    return launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webViewConfiguration: const WebViewConfiguration(
        headers: _webViewHeaders,
      ),
    );
  }
}

/// Throws [PaysYouPayLaunchException] when [DeepLinkLauncher.launch] returns false.
Future<void> launchDeepLinkOrThrow(
  DeepLinkLauncher launcher,
  String deepLink,
) async {
  final uri = Uri.tryParse(deepLink);
  if (uri == null) {
    throw PaysYouPayLaunchException('Invalid deep link: $deepLink');
  }

  final launched = await launcher.launch(uri);
  if (!launched) {
    throw PaysYouPayLaunchException(
      'Could not open PaysYou app. Deep link: $deepLink',
    );
  }
}
