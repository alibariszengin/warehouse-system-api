import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:warehouse/pages/auth/reset_password_page.dart';
import 'package:warehouse/pages/splash_screen_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks(
      onAppLink: (Uri uri, String stringUri) {
        if (uri.path == "/api/auth/resetpassword") {
          resetPassword(uri.queryParameters["resetPasswordToken"]);
        }
      },
    );

    _appLinks.getInitialAppLink().then((appLink) {
      if (appLink != null && appLink.hasQuery) {
        if (appLink.path == "/api/auth/resetpassword") {
          resetPassword(appLink.queryParameters["resetPasswordToken"]);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: kDebugMode,
      navigatorKey: _navigatorKey,
      title: 'Warehouse System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreenPage(),
    );
  }

  void resetPassword(String? token) {
    if (token == null) return;
    _navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => ResetPasswordPage(
          token: token,
        ),
      ),
      (route) => false,
    );
  }
}
