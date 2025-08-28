import 'package:reachify_app/utils/const/enums.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> urlLaunch(
  LaunchType type, {
  required String value,
  String? message,
  String? subject,
  String? body,
}) async {
  Uri uri;

  switch (type) {
    case LaunchType.call:
      uri = Uri(scheme: 'tel', path: value);
      break;

    case LaunchType.whatsapp:
      uri = Uri.parse(
        "https://wa.me/$value?text=${Uri.encodeComponent(message ?? '')}",
      );
      break;

    case LaunchType.website:
      uri = Uri.parse(value);
      break;

    case LaunchType.mail:
      uri = Uri(
        scheme: 'mailto',
        path: value,
        query:
            'subject=${Uri.encodeComponent(subject ?? '')}&body=${Uri.encodeComponent(body ?? '')}',
      );
      break;
  }

  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $uri';
  }
}
