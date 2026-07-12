## 0.1.0

* Initial release.
* Added `PaysYouPay` facade for payment preparation, deep-link launching, and one-tap `payAndLaunch()` flows.
* Added typed `PaysYouInvoice` request model and `CreateInvoiceResult` response model with full `toJson()` payload access.
* Added support for custom business flows using `redirectUrl` for hosted checkout and `redirectDeepLink` for app deep links.
* Added SOLID-based API architecture with injectable validator, mapper, parser, API client, and launcher abstractions.
* Added branded `PaysYouPayButton` widgets with filled and outlined styles.
* Added premium PaysYou button styling with logo asset, gradient branding, dark-theme support, and configurable border radius.
* Added custom button support through `builder` and `loadingBuilder`.
* Added exported `PaysYouPayLogo` widget for custom branded UIs.
* Added example app demonstrating button usage and response-driven payment handling.
* Added package documentation and MIT license.
