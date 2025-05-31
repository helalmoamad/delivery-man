import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String deliveryUrl = dotenv.env['DELIVERY_URL']!;
  static String marketUrl = dotenv.env['MARKET_URL']!;
  static String chatUrl = dotenv.env['CHAT_URL']!;
  static const version = 'v1';
}
