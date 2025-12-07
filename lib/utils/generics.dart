library generic;

import 'package:url_launcher/url_launcher.dart';

String formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

Future<void> openWhatsApp(String phone) async {
  final Uri whatsappUrl = Uri.parse("https://wa.me/$phone");

  try {
    await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
  } catch (e) {
    print(e);
    throw "No se pudo abrir WhatsApp";
  }
}
