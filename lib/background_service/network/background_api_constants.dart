import 'package:flutter_dotenv/flutter_dotenv.dart';

class BackgroundApiConstants {
  static String baseUrl = dotenv.env['BASE_URL']!;
  static const version = 'v1';
}
