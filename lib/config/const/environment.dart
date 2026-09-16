import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String apiAndroid = dotenv.env['API_ANDROID']!;
  static String apiIOS = dotenv.env['API_IOS']!;
}
