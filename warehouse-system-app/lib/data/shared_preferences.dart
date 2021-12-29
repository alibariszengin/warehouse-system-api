import 'package:shared_preferences/shared_preferences.dart' as sh;

class SharedPreferences {
  SharedPreferences._();
  static late SharedPreferences instance;
  late sh.SharedPreferences prefs;
  static Future init() async {
    instance = SharedPreferences._();
    instance.prefs = await sh.SharedPreferences.getInstance();
  }
}
