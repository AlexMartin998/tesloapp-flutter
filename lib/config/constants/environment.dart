import 'package:flutter_dotenv/flutter_dotenv.dart';


class Environment {

  static String apiUrl = dotenv.env['API_URL'] ?? 'No base url';


  static initEnvironmentVariables() async {
    await dotenv.load(fileName: '.env');
  }

}
