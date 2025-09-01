import 'package:reachify_app/utils/const/enums.dart';
import 'package:reachify_app/utils/const/logger.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> urlLaunch(
  LaunchType type, {
  required String value,
  String? message,
  String? subject,
  String? body,
}) async {
  Uri uri;
  logger.d('URL Launcher $value\n Type :$type');

  switch (type) {
    case LaunchType.call:
      uri = Uri(scheme: 'tel', path: value);
      if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
        logger.d('Could not launch $uri');
        // throw 'Could not launch $uri';
      }
      return;

    case LaunchType.whatsapp:
      uri = Uri.parse(
        "https://wa.me/$value?text=${Uri.encodeComponent(message ?? '')}",
      );
      break;

    case LaunchType.website:
      final String formattedUrl = value.startsWith('http')
          ? value
          : 'https://${value.replaceAll(RegExp(r'^/+'), '')}';
      uri = Uri.parse(formattedUrl);
      break;

    case LaunchType.mail:
      uri = Uri(
        scheme: 'mailto',
        path: value,
        query:
            'subject=${Uri.encodeComponent(subject ?? '')}&body=${Uri.encodeComponent(body ?? '')}',
      );
      // Use platformDefault for mailto
      if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
        logger.d('Could not launch $uri');
      }
      return;
  }

  // For website & whatsapp - try inAppWebView first, fallback to external
  try {
    if (type == LaunchType.website) {
      // First check if the URL can be launched
      if (await canLaunchUrl(uri)) {
        bool launched = await launchUrl(
          uri,
          mode: LaunchMode.inAppWebView,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
            enableDomStorage: true,
          ),
        );

        if (!launched) {
          logger.d('InAppWebView failed, trying external application');
          // Fallback to external application
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      } else {
        logger.d('Cannot launch URL: $uri');
        throw 'Cannot launch URL: $uri';
      }
    } else {
      // For WhatsApp, use external application
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        logger.d('Could not launch $uri');
        throw 'Could not launch $uri';
      }
    }
  } catch (e) {
    logger.d('Error launching URL: $e');
  }
}
