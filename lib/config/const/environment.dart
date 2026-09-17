import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String apiAndroid = dotenv.env['API_ANDROID']!;
  static String apiIOS = dotenv.env['API_IOS']!;
  static String appIdAndroid = dotenv.env['APP_ID_ANDROID']!;
  static String appIdIOS = dotenv.env['APP_ID_IOS']!;
  static String messagingSenderId = dotenv.env['MESSAGING_SENDER_ID']!;
  static String projectId = dotenv.env['PROJECT_ID']!;
  static String storageBucket = dotenv.env['STORAGE_BUCKET']!;
  static String iosBundleId = dotenv.env['IOS_BUNDLE_ID']!;
}
