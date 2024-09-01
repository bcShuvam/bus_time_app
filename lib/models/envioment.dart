import 'package:flutter_dotenv/flutter_dotenv.dart';

class Enviroment {
  static String get busTimeList {
    return dotenv.get('KEY_BUS_TIME_LIST', fallback: 'KEY not available');
  }

  static String get id {
    return dotenv.get('KEY_ID', fallback: 'KEY not available');
  }
}
