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
      }
      return;

    case LaunchType.whatsapp:
      if (value.startsWith('https://api.whatsapp.com/send') ||
          value.startsWith('https://wa.me/')) {
        if (value.startsWith('https://api.whatsapp.com/send')) {
          final Uri originalUri = Uri.parse(value);
          final String? phone = originalUri.queryParameters['phone'];
          final String? text = originalUri.queryParameters['text'];

          if (phone != null) {
            final String cleanPhone = phone.replaceAll('+', '');
            uri = Uri.parse(
              "https://wa.me/$cleanPhone${text != null ? '?text=$text' : ''}",
            );
          } else {
            uri = Uri.parse(value);
          }
        } else {
          uri = Uri.parse(value);
        }
      } else {
        final String phoneNumber = value.replaceAll(RegExp(r'[^\d]'), '');
        uri = Uri.parse(
          "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message ?? '')}",
        );
      }

      try {
        if (await canLaunchUrl(uri)) {
          final bool launched = await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );

          if (!launched) {
            logger.d('Could not launch WhatsApp: $uri');
            throw 'Could not launch WhatsApp';
          }
        } else {
          logger.d('WhatsApp is not installed or cannot handle this URL: $uri');
          throw 'WhatsApp is not available';
        }
      } catch (e) {
        logger.d('Error launching WhatsApp: $e');
        rethrow;
      }
      return;

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

      if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
        logger.d('Could not launch $uri');
      }
      return;
  }

  try {
    if (type == LaunchType.website) {
      if (await canLaunchUrl(uri)) {
        final bool launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
            enableDomStorage: true,
          ),
        );

        if (!launched) {
          logger.d('InAppWebView failed, trying external application');
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      } else {
        logger.d('Cannot launch URL: $uri');
        throw 'Cannot launch URL: $uri';
      }
    }
  } catch (e) {
    logger.d('Error launching URL: $e');
    rethrow;
  }
}
